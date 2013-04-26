Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3DZRax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:30:53 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38528 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3DZRau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:30:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 26 Apr 2013 19:30:46 +0200
Message-ID: <CA+icZUVCmFeh3Xna37VJDDzvZ34sYJ_Dser7i5rRzGLhMTi5-Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 26 [ bluetooth on suspend/resume ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130424:
>
> Removed tree: ppc-temp (remerged into powerpc)
>
> The net-next tree gained conflicts against the net and pci trees and a
> build failure for which I applied a merge fix patch.
>
> The omap_dss2 tree gained a build failure so I used the version from
> next-20130424.
>
> The trivial tree gained a conflict against the arm tree.
>
> The staging tree still had its build failure for which I applied a
> supplied patch.
>
> The arm-soc tree gained a conflict against the spi-mb tree.
>
> The renesas tree gained a conflict against the input tree.
>

[ CC linux-bluetooth + linux-pm folks ]

I see the following:

[  176.667799] PM: Syncing filesystems ... done.
[  176.670014] PM: Preparing system for mem sleep
[  176.670422] Freezing user space processes ...
[  196.656719] Freezing of tasks failed after 20.00 seconds (1 tasks
refusing to freeze, wq_busy=0):
[  196.656728] bluetoothd      D ffffffff8180d8c0     0  1012    863 0x00000004
[  196.656731]  ffff88008fdb3cc8 0000000000000046 ffff8800926530d0
0000020000000000
[  196.656735]  ffff88008feca200 ffff88008fdb3fd8 ffff88008fdb3fd8
ffff88008fdb3fd8
[  196.656738]  ffff880119f78300 ffff88008feca200 ffff88008fdb3cf8
ffff880095281950
[  196.656741] Call Trace:
[  196.656749]  [<ffffffff816cfc99>] schedule+0x29/0x70
[  196.656752]  [<ffffffff816cff9e>] schedule_preempt_disabled+0xe/0x10
[  196.656754]  [<ffffffff816ce075>] __mutex_lock_slowpath+0x125/0x2f0
[  196.656757]  [<ffffffff816ce25e>] mutex_lock+0x1e/0x40
[  196.656773]  [<ffffffffa016f8b1>] hci_dev_open+0x51/0x2e0 [bluetooth]
[  196.656780]  [<ffffffffa0182752>] hci_sock_ioctl+0x1f2/0x3f0 [bluetooth]
[  196.656783]  [<ffffffff815c6050>] sock_do_ioctl+0x30/0x70
[  196.656786]  [<ffffffff815c75f9>] sock_ioctl+0x79/0x2f0
[  196.656790]  [<ffffffff811a8046>] do_vfs_ioctl+0x96/0x560
[  196.656794]  [<ffffffff811a85a1>] SyS_ioctl+0x91/0xb0
[  196.656797]  [<ffffffff816d989d>] system_call_fastpath+0x1a/0x1f
[  196.656811]
[  196.656812] Restarting tasks ... done.
