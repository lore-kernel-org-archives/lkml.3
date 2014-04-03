Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162508AbaDCH7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:59:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45944 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162492AbaDCH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:59:39 -0400
Date: Thu, 3 Apr 2014 09:59:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Subject: 3.15-rc0: warn_on in suspend_test.c
Message-ID: <20140403075938.GA10355@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Wakeup took longer than usual, and then I got: 

usb 2-1: reset low-speed USB device number 2 using uhci_hcd
usb 5-1: reset low-speed USB device number 2 using uhci_hcd
usb 1-8: reset high-speed USB device number 6 using ehci-pci
usb 1-8: device descriptor read/64, error -110
usb 1-8: device descriptor read/64, error -110
usb 1-8: reset high-speed USB device number 6 using ehci-pci
PM: resume of devices complete after 43288.193 msecs
PM: resume devices took 43.392 seconds
------------[ cut here ]------------
WARNING: CPU: 1 PID: 7045 at kernel/power/suspend_test.c:53
suspend_test_finish+0x84/0x90()
Component: resume devices, time: 43392
Modules linked in:
CPU: 1 PID: 7045 Comm: pm-suspend Tainted: G        W    3.14.0+ #332
Hardware name:                  /DG41MJ, BIOS
MJG4110H.86A.0006.2009.1223.1155 12/23/2009
 00000035 c08a9e30 c47dd48b c49d015e c08a9e60 c40384ea c49d0145
 c08a9e8c
 00001b85 c49d015e 00000035 c407b734 c407b734 0000a980 c49d00ea
 c08a9eb0
 c08a9e78 c403858e 00000009 c08a9e70 c49d0145 c08a9e8c c08a9e9c
 c407b734
Call Trace:
 [<c47dd48b>] dump_stack+0x41/0x52
 [<c40384ea>] warn_slowpath_common+0x7a/0xa0
 [<c407b734>] ? suspend_test_finish+0x84/0x90
 [<c407b734>] ? suspend_test_finish+0x84/0x90
 [<c403858e>] warn_slowpath_fmt+0x2e/0x30
 [<c407b734>] suspend_test_finish+0x84/0x90
 [<c407b259>] suspend_devices_and_enter+0x159/0x2e0
 [<c47dd33a>] ? printk+0x38/0x3a
 [<c407b5e1>] pm_suspend+0x201/0x240
 [<c407a7bd>] state_store+0x8d/0x90
 [<c407a730>] ? wakeup_count_show+0x40/0x40
 [<c42703a0>] kobj_attr_store+0x20/0x30
 [<c414615b>] sysfs_kf_write+0x3b/0x50
 [<c4149395>] kernfs_fop_write+0xb5/0x110
 [<c4146120>] ? sysfs_file_ops+0x50/0x50
 [<c40eddee>] vfs_write+0x9e/0x190
 [<c41492e0>] ? kernfs_vma_page_mkwrite+0x80/0x80
 [<c410680d>] ? __fdget+0xd/0x10
 [<c40edfd6>] SyS_write+0x56/0xc0
 [<c4106d1b>] ? __close_fd+0x6b/0x90
 [<c47e27ff>] sysenter_do_call+0x12/0x31
---[ end trace df8f3e773ca202a7 ]---

Now.. usb-to-video convertor was plugged in, so maybe that's
responsible?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
