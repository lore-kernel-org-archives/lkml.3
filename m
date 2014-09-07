Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaIGKnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:43:45 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54144 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaIGKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1409051340450.879-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1409051340450.879-100000@iolanthe.rowland.org>
Date: Sun, 7 Sep 2014 18:43:43 +0800
Message-ID: <CACVXFVOS2RbFQH4CNqSTDeGCoJ3L7c1JCCsAzQrOn+hbVQvbCA@mail.gmail.com>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 1:45 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> James and Jens:
>
> I got a WARNING when unbinding the sd driver from a USB flash drive and
> then binding it back again.  Here's where the flash drive gets probed
> initially:
>
> [  143.300886] usb-storage 4-8:1.0: usb_probe_interface
> [  143.300911] usb-storage 4-8:1.0: usb_probe_interface - got id
> [  143.300930] usb-storage 4-8:1.0: USB Mass Storage device detected
> [  143.318239] scsi host0: usb-storage 4-8:1.0
> [  143.359979] scsi 0:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
> [  143.376366] usbcore: registered new interface driver usb-storage
> [  143.468464] sd 0:0:0:0: [sda] 7892040 512-byte logical blocks: (4.04 GB/3.76 GiB)
> [  143.481725] sd 0:0:0:0: [sda] Write Protect is off
> [  143.485712] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
> [  143.487064] sd 0:0:0:0: [sda] Asking for cache data failed
> [  143.498428] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [  143.656797]  sda: sda1
> [  143.676922] sd 0:0:0:0: [sda] Attached SCSI removable disk
>
> Then I did
>
>         echo 0:0:0:0 >/sys/bus/scsi/drivers/sd_mod/unbind
>
> followed by
>
>         echo 0:0:0:0 >/sys/bus/scsi/drivers/sd_mod/bind

I can reproduce it on virtio-blk too with scsi-mq, and can't duplicate
it on non-scsi devices, so looks there are refcounts leak in scsi subsystem?


Thanks,
-- 
Ming Lei
