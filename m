Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3BSRkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:40:33 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:42824 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3BSRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:40:32 -0500
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 19:40:31 +0200
Message-ID: <CA+ydwtpxZYx7cAUdkrnvwsX21oa9i0DWv5W7Ytv3Qh_FHj2RDw@mail.gmail.com>
Subject: idr_remove called for id=4096 which is not allocated
From: Tommi Rantala <tt.rantala@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Saw this WARNING a few times while fuzzing the kernel with Trinity in
a qemu virtual machine:

[   22.883257] idr_remove called for id=4096 which is not allocated.
[   22.884487] Pid: 2303, comm: trinity-child1 Not tainted 3.8.0+ #87
[   22.885601] Call Trace:
[   22.886080]  [<ffffffff8134b111>] idr_remove+0x131/0x1f0
[   22.887107]  [<ffffffff8143c678>] drm_ctxbitmap_free+0x38/0x50
[   22.888158]  [<ffffffff8143cbd3>] drm_rmctx+0x63/0x100
[   22.889091]  [<ffffffff8143d710>] drm_ioctl+0x3d0/0x4d0
[   22.890034]  [<ffffffff8143cb70>] ? drm_newctx+0xb0/0xb0
[   22.890970]  [<ffffffff812fb640>] ? avc_has_perm_flags+0x1d0/0x2a0
[   22.892127]  [<ffffffff812fb498>] ? avc_has_perm_flags+0x28/0x2a0
[   22.893218]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[   22.894401]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[   22.895461]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[   22.896447]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[   22.897453]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[   22.898429]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   22.899629]  [<ffffffff81ca07e9>] system_call_fastpath+0x16/0x1b

Tommi
