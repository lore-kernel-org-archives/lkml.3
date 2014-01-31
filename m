Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaAaVL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:11:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaAaVL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:11:28 -0500
Date: Fri, 31 Jan 2014 16:11:18 -0500
From: Dave Jones <davej@redhat.com>
To: gregkh@linuxfoundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: removing usb debug cable triggers lockdep warning.
Message-ID: <20140131211118.GA23873@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, gregkh@linuxfoundation.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb 3-3: USB disconnect, device number 2
console [ttyUSB0] disabled
debug ttyUSB0: debug converter now disconnected from ttyUSB0
usb_debug 3-3:1.0: device disconnected
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 3 PID: 66 Comm: khubd Not tainted 3.13.0+ #104 
 ffffffffbb28cf50 000000000f74f0eb ffff880242eb3a08 ffffffffba73a377
 ffff880243741740 ffff880242eb3a18 ffffffffba7368b9 ffff880242eb3a90
 ffffffffba0c1560 0000000000000003 ffff880242eb2000 ffff880242eb3aa8
Call Trace:
 [<ffffffffba73a377>] dump_stack+0x4e/0x7a
 [<ffffffffba7368b9>] register_lock_class.part.21+0x38/0x3c
 [<ffffffffba0c1560>] __lock_acquire.isra.28+0xa10/0xa50
 [<ffffffffba0c1cfd>] lock_acquire+0x8d/0x120
 [<ffffffffba24ba88>] ? kernfs_addrm_finish+0x38/0x60
 [<ffffffffba24acde>] kernfs_deactivate+0x10e/0x150
 [<ffffffffba24ba88>] ? kernfs_addrm_finish+0x38/0x60
 [<ffffffffba24ba88>] kernfs_addrm_finish+0x38/0x60
 [<ffffffffba24bd00>] kernfs_remove_by_name_ns+0x60/0xc0
 [<ffffffffba2498d1>] remove_files.isra.1+0x41/0x80
 [<ffffffffba249bc7>] sysfs_remove_group+0x47/0xa0
 [<ffffffffba249cf3>] sysfs_remove_groups+0x33/0x50
 [<ffffffffba4ded6d>] device_remove_attrs+0x4d/0x80
 [<ffffffffba4df9ae>] device_del+0x12e/0x1d0
 [<ffffffffba53ce08>] usb_disconnect+0x138/0x1d0
 [<ffffffffba540153>] hub_thread+0x723/0x1700
 [<ffffffffba09d7c4>] ? finish_task_switch+0x44/0x190
 [<ffffffffba0ba030>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffffba53fa30>] ? usb_reset_device+0x1d0/0x1d0
 [<ffffffffba093dcc>] kthread+0xfc/0x120
 [<ffffffffba093cd0>] ? kthread_create_on_node+0x230/0x230
 [<ffffffffba74d96c>] ret_from_fork+0x7c/0xb0
 [<ffffffffba093cd0>] ? kthread_create_on_node+0x230/0x230

