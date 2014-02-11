Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBKSn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:43:29 -0500
Received: from canardo.mork.no ([148.122.252.1]:58596 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaBKSn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:43:27 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [BUGREPORT] Linux USB 3.0
Organization: m
References: <CA+O4pCJAL_Dqrt0mF5rbErBXbLTALx8Rrs1+vB3JmT=+rT0jCg@mail.gmail.com>
	<CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
	<CA+O4pCJ5xUQwRem3rvZbvv7K8BEnMW983Qq_vR0tVzwAwmVS6A@mail.gmail.com>
	<CA+O4pCJ9dFuwrcVF2b5MsreUb4NJX8t6664i3XHM9CYrdN7VzA@mail.gmail.com>
	<20140120193510.GC5545@xanatos>
	<CA+O4pC+inTZBSVJDBs4PfaDv0et3ZT+eN-1epThRJMztdgQryQ@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B8058@AcuExch.aculab.com>
	<CA+O4pCKedNsBcLoVP6T0BHT6sq00D+XNHLT790UDgdx-r7TL4Q@mail.gmail.com>
	<52F80C28.5040709@gmail.com>
	<CA+O4pCL8gUqFs7zTJZ+0UftOq_jALpg=rsmz3hSypOPr2qZg7Q@mail.gmail.com>
Date: Tue, 11 Feb 2014 19:43:11 +0100
In-Reply-To: <CA+O4pCL8gUqFs7zTJZ+0UftOq_jALpg=rsmz3hSypOPr2qZg7Q@mail.gmail.com>
	(Markus Rechberger's message of "Tue, 11 Feb 2014 19:29:47 +0100")
Message-ID: <87ob2d7ao0.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger <mrechberger@gmail.com> writes:

> Next kernel crash report, this time a Synology NAS System:
> http://support.sundtek.com/index.php/topic,1511.0.html

There is no etxhci_hcd driver in the mainline kernel...


Feb 11 18:50:41 DiskStation kernel: [103740.405521] Backtrace:
Feb 11 18:50:41 DiskStation kernel: [103740.408095] [<7f2d8f2c>] (find_trb_seg+0x0/0x54 [etxhci_hcd]) from [<7f2d9ac0>] (etxhci_find_new_dequeue_state+0x5c/0x200 [etxhci_hcd])
Feb 11 18:50:41 DiskStation kernel: [103740.420389]  r4:9675fd44
Feb 11 18:50:41 DiskStation kernel: [103740.423046] [<7f2d9a64>] (etxhci_find_new_dequeue_state+0x0/0x200 [etxhci_hcd]) from [<7f2d4520>] (etxhci_cleanup_stalled_ring+0x50/0x140 [etxhci_hcd])
Feb 11 18:50:41 DiskStation kernel: [103740.436749] [<7f2d44d0>] (etxhci_cleanup_stalled_ring+0x0/0x140 [etxhci_hcd]) from [<7f2d46e0>] (etxhci_endpoint_reset+0xd0/0x100 [etxhci_hcd])
Feb 11 18:50:41 DiskStation kernel: [103740.449738]  r7:bc0e9830 r6:965b6360 r5:bc0e9800 r4:be34cc00
Feb 11 18:50:41 DiskStation kernel: [103740.455595] [<7f2d4610>] (etxhci_endpoint_reset+0x0/0x100 [etxhci_hcd]) from [<7f086c00>] (usb_hcd_reset_endpoint+0x2c/0x80 [usbcore])
Feb 11 18:50:41 DiskStation kernel: [103740.467837] [<7f086bd4>] (usb_hcd_reset_endpoint+0x0/0x80 [usbcore]) from [<7f088ff0>] (usb_enable_endpoint+0x70/0x74 [usbcore])
Feb 11 18:50:41 DiskStation kernel: [103740.479558] [<7f088f80>] (usb_enable_endpoint+0x0/0x74 [usbcore]) from [<7f08903c>] (usb_enable_interface+0x48/0x5c [usbcore])
Feb 11 18:50:41 DiskStation kernel: [103740.491066]  r8:00000001 r7:be34cc00 r6:be8ff368 r5:00000001 r4:0000002c
Feb 11 18:50:41 DiskStation kernel: [103740.497750] r3:00000001
Feb 11 18:50:41 DiskStation kernel: [103740.500522] [<7f088ff4>] (usb_enable_interface+0x0/0x5c [usbcore]) from [<7f08942c>] (usb_set_interface+0x1c8/0x22c [usbcore])
Feb 11 18:50:41 DiskStation kernel: [103740.512032]  r8:be04c860 r7:bdc4d600 r6:00000000 r5:be8ff368 r4:be34cc00
Feb 11 18:50:41 DiskStation kernel: [103740.518715] r3:be8ff368
Feb 11 18:50:41 DiskStation kernel: [103740.521495] [<7f089264>] (usb_set_interface+0x0/0x22c [usbcore]) from [<7f0902c0>] (usbdev_ioctl+0xf40/0x1cac [usbcore])
Feb 11 18:50:41 DiskStation kernel: [103740.532512] [<7f08f380>] (usbdev_ioctl+0x0/0x1cac [usbcore]) from [<800db114>] (do_vfs_ioctl+0xa8/0x8bc)
Feb 11 18:50:41 DiskStation kernel: [103740.542109] [<800db06c>] (do_vfs_ioctl+0x0/0x8bc) from [<800db968>] (sys_ioctl+0x40/0x64)
Feb 11 18:50:41 DiskStation kernel: [103740.550396]  r9:9675e000 r8:8000e388 r7:00000017 r6:80085504 r5:2f4f54f4
Feb 11 18:50:41 DiskStation kernel: [103740.557079] r4:bc10b540
Feb 11 18:50:41 DiskStation kernel: [103740.559822] [<800db928>] (sys_ioctl+0x0/0x64) from [<8000e1e0>] (ret_fast_syscall+0x0/0x30)
Feb 11 18:50:41 DiskStation kernel: [103740.568282]  r7:00000036 r6:00000000 r5:00000000 r4:2f4f64d8


Bjørn
