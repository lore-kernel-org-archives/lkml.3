Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3APLgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:36:51 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49832 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3APLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:36:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130116025251.GM2668@htj.dyndns.org>
References: <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com> <20130116025251.GM2668@htj.dyndns.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Wed, 16 Jan 2013 12:36:27 +0100
Message-ID: <CALxABCY9HZozo2BGZLGpKo1NXwYjmsN8HiubShTb-KBVY-BpXA@mail.gmail.com>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 3:52 AM, Tejun Heo <tj@kernel.org> wrote:
> This avoids the described deadlock because iosched module doesn't use
> async and thus wouldn't invoke async_synchronize_full().  This is
> hacky and incomplete.  It will deadlock if async module loading nests;
> however, this works around the known problem case and seems to be the
> best of bad options.

I confirm it fixes the original problem.

Tested-by: Alex Riesen <raa.lkml@gmail.com>

[   27.594951] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0004
[   27.595245] hub 1-1:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   27.698995] hub 1-1:1.0: debounce: port 2: total 100ms stable 100ms
status 0x101
[   27.709977] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[   27.771888] usb 1-1.2: new high-speed USB device number 3 using ehci-pci
[   27.782871] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[   27.857503] usb 1-1.2: default language 0x0409
[   27.858248] usb 1-1.2: udev 3, busnum 1, minor = 2
[   27.858258] usb 1-1.2: New USB device found, idVendor=0781, idProduct=5408
[   27.858263] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   27.858267] usb 1-1.2: Product: U3 Titanium
[   27.858271] usb 1-1.2: Manufacturer: SanDisk Corporation
[   27.858275] usb 1-1.2: SerialNumber: 0000187A3A60F1E9
[   27.858800] usb 1-1.2: usb_probe_device
[   27.858815] usb 1-1.2: configuration #1 chosen from 1 choice
[   27.858940] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
[   27.859246] usb-storage 1-1.2:1.0: usb_probe_interface
[   27.859258] usb-storage 1-1.2:1.0: usb_probe_interface - got id
[   27.859516] scsi6 : usb-storage 1-1.2:1.0
[   28.865771] io scheduler deadline registered (default)
[   28.866705] scsi 6:0:0:0: Direct-Access     SanDisk  U3 Titanium
  2.18 PQ: 0 ANSI: 2
[   28.869483] sd 6:0:0:0: Attached scsi generic sg1 type 0
[   28.869700] sd 6:0:0:0: [sdb] 4013713 512-byte logical blocks:
(2.05 GB/1.91 GiB)
[   28.870197] sd 6:0:0:0: [sdb] Write Protect is off
[   28.870204] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   28.870692] sd 6:0:0:0: [sdb] No Caching mode page present
[   28.870697] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   28.873565] sd 6:0:0:0: [sdb] No Caching mode page present
[   28.873575] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   28.883895]  sdb: sdb1
[   28.887775] sd 6:0:0:0: [sdb] No Caching mode page present
[   28.887783] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   28.887789] sd 6:0:0:0: [sdb] Attached SCSI removable disk

The filesystem can be mounted and files can be read.
