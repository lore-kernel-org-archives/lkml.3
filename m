Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab3BSSPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:15:10 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:55736 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3BSSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:15:08 -0500
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 20:14:57 +0200
Message-ID: <CA+ydwtpAKaY08q_hr+pNZdDZ0BDnojnG9LHf_m0B4PTT+ya9gg@mail.gmail.com>
Subject: autofs ioctl() => impossibly large user copy
From: Tommi Rantala <tt.rantala@gmail.com>
To: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Saw this WARNING while fuzzing the kernel with trinity in qemu virtual
machine as the root user:

[  392.585489] ------------[ cut here ]------------
[  392.586464] WARNING: at
/home/ttrantal/git/linux-2.6/mm/page_alloc.c:2376
__alloc_pages_nodemask+0x20e/0x970()
[  392.588446] Hardware name: Bochs
[  392.589170] Pid: 2811, comm: trinity-child12 Not tainted 3.8.0+ #87
[  392.590486] Call Trace:
[  392.591023]  [<ffffffff81097b86>] warn_slowpath_common+0x86/0xb0
[  392.592374]  [<ffffffff81097c75>] warn_slowpath_null+0x15/0x20
[  392.593507]  [<ffffffff81159b8e>] __alloc_pages_nodemask+0x20e/0x970
[  392.594650]  [<ffffffff810d51a5>] ? sched_clock_local+0x25/0xa0
[  392.595862]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[  392.597304]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[  392.599000]  [<ffffffff8118fba4>] alloc_pages_current+0x124/0x150
[  392.600547]  [<ffffffff81156639>] __get_free_pages+0x9/0x50
[  392.601927]  [<ffffffff81195779>] kmalloc_order_trace+0x39/0xd0
[  392.603501]  [<ffffffff81197f46>] __kmalloc_track_caller+0x46/0x1d0
[  392.605203]  [<ffffffff812d2b7a>] ? _autofs_dev_ioctl+0x9a/0x3e0
[  392.606724]  [<ffffffff8116b44b>] memdup_user+0x2b/0x80
[  392.608076]  [<ffffffff8117a1f0>] ? might_fault+0x40/0x90
[  392.609403]  [<ffffffff812d2b7a>] _autofs_dev_ioctl+0x9a/0x3e0
[  392.610845]  [<ffffffff812fb640>] ? avc_has_perm_flags+0x1d0/0x2a0
[  392.612380]  [<ffffffff812fb498>] ? avc_has_perm_flags+0x28/0x2a0
[  392.613817]  [<ffffffff812d2ece>] autofs_dev_ioctl+0xe/0x20
[  392.615191]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[  392.616554]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[  392.617623]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[  392.618599]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  392.619796]  [<ffffffff81ca07e9>] system_call_fastpath+0x16/0x1b
[  392.620956] ---[ end trace 6628336fa0115cb7 ]---

Tommi
