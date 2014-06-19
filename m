Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbaFSPCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:02:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59912 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932867AbaFSPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:02:40 -0400
Date: Thu, 19 Jun 2014 11:02:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [usb resume regression] in 3.16-rc1
In-Reply-To: <CADDKRnDMbBzgkbC1tftGggfgsznntbO_st2fQW42d++D1rJsSw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1406191059520.1247-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Jörg Otte wrote:

> on resume with 3.16-rc1 I get the following error messages in dmesg
> which are alltogether not present in 3.15:
> 
> [   43.518116] dpm_run_callback(): 0xffffffffa53c4120 returns -13
> [   43.518119] PM: Device 1-1 failed to resume async: error -13
> [   43.522380] hub 1-1:1.0: hub_port_status failed (err = -71)
> [   43.528538] sd 0:0:0:0: [sda] Starting disk
> [   43.530886] hub 1-1:1.0: hub_port_status failed (err = -71)
> [   43.535140] usb 1-1-port2: cannot disable (err = -71)
> [   43.535142] dpm_run_callback(): 0xffffffffa53c4120 returns -71
> [   43.535145] PM: Device 1-1.2 failed to resume async: error -71
> [   43.543673] usb 1-1-port4: cannot disable (err = -71)
> [   43.543674] dpm_run_callback(): 0xffffffffa53c4120 returns -71
> [   43.543679] PM: Device 1-1.4 failed to resume async: error -71
> 
> usb devices connected to the hub (in my case mouse and keyboard) are
> all death after resume and cannot be activated again.

-13 is -EACCES.  It's not clear what could have caused that error, 
since EACCES isn't used in the USB core or in ehci-hcd.

Can you try doing the same thing after enabling dynamic debugging in 
usbcore and ehci-hcd?

Alan Stern

