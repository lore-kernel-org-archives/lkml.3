Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbbAJSgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:36:43 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:46610 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbbAJSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:36:42 -0500
Date: Sat, 10 Jan 2015 19:36:33 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1463471745.20150110193633@eikelenboom.it>
To: Mike Isely <isely@pobox.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: media
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

With a 3.19-rc3 kernel i'm running into the warning below on boot with a pvrusb2 device.

It's hitting this warn:
        /*
         * Drivers MUST fill in device_caps, so check for this and
         * warn if it was forgotten.
         */
        WARN_ON(!(cap->capabilities & V4L2_CAP_DEVICE_CAPS) ||
                !cap->device_caps);

--
Sander

[   25.604846] ------------[ cut here ]------------
[   25.622165] WARNING: CPU: 4 PID: 2133 at drivers/media/v4l2-core/v4l2-ioctl.c:1025 v4l_querycap+0x3e/0x70()
[   25.654888] Modules linked in:
[   25.667494] CPU: 4 PID: 2133 Comm: v4l_id Not tainted 3.19.0-rc3-20150110-pciback-doflr+ #1
[   25.695927] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
[   25.723022]  ffffffff81fcf468 ffff880546fefbc8 ffffffff81bb3fc9 ffff880544a83240
[   25.748684]  0000000000000000 ffff880546fefc08 ffffffff810c738d ffff880544a83240
[   25.774301]  ffff880546fefd38 0000000080685600 0000000000000000 ffff880544b78e00
[   25.799936] Call Trace:
[   25.810584]  [<ffffffff81bb3fc9>] dump_stack+0x45/0x57
[   25.829319]  [<ffffffff810c738d>] warn_slowpath_common+0x8d/0xd0
[   25.850669]  [<ffffffff810c73e5>] warn_slowpath_null+0x15/0x20
[   25.871477]  [<ffffffff81851fae>] v4l_querycap+0x3e/0x70
[   25.890692]  [<ffffffff818513f4>] __video_do_ioctl+0x284/0x300
[   25.911478]  [<ffffffff81103556>] ? __lock_acquire+0x4e6/0x21a0
[   25.932412]  [<ffffffff818521d1>] video_usercopy+0x1f1/0x4e0
[   25.952525]  [<ffffffff81851170>] ? v4l_printk_ioctl+0xa0/0xa0
[   25.973136]  [<ffffffff811018dd>] ? trace_hardirqs_on+0xd/0x10
[   25.993791]  [<ffffffff818524d0>] video_ioctl2+0x10/0x20
[   26.012844]  [<ffffffff81892df7>] pvr2_v4l2_ioctl+0xa7/0x180
[   26.032939]  [<ffffffff8184e2ff>] v4l2_ioctl+0x12f/0x150
[   26.051927]  [<ffffffff811d6163>] do_vfs_ioctl+0x83/0x5b0
[   26.071161]  [<ffffffff811d3321>] ? final_putname+0x21/0x50
[   26.090911]  [<ffffffff81bbf995>] ? sysret_check+0x22/0x5d
[   26.110395]  [<ffffffff811d66d7>] SyS_ioctl+0x47/0x90
[   26.128537]  [<ffffffff81bbf969>] system_call_fastpath+0x12/0x17
[   26.149531] ---[ end trace 52e366625e9023ef ]---
[   26.166528] ------------[ cut here ]------------

