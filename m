Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaGONq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:46:26 -0400
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:59651 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaGONqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:46:24 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 09:46:24 EDT
Date: Tue, 15 Jul 2014 22:40:46 +0900
To: linux-kernel@vger.kernel.org
Subject: btrfs hanging since 3.16-rc3 or so
Message-ID: <20140715134046.GX23620@auth.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all

(please keep Cc)

Since 3.16-rc3 or so I regularly get btrfs hanging in some transations.

Usually during apt-get upgrade or some other large file operations
(cowbuilder building of packages).

The log files give me for loads of processes things like:
[ 6236.746546] INFO: task aptitude:22775 blocked for more than 120 seconds.
[ 6236.746547]       Tainted: G        W  O  3.16.0-rc5 #27
[ 6236.746548] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6236.746549] aptitude        D ffff8800b21a3868     0 22775  22709 0x00000000
[ 6236.746550]  ffff88003644fd10 0000000000000082 ffffffff81a15500 ffff88003644ffd8
[ 6236.746552]  ffff8800b21a3430 0000000000011c00 ffff880147da9c30 ffff880147da9c30
[ 6236.746553]  ffff88003644fd58 ffff880034b3ed48 ffff880034b3ed38 ffff88003644fd20
[ 6236.746555] Call Trace:
[ 6236.746557]  [<ffffffff81585b4a>] schedule+0x64/0x66
[ 6236.746560]  [<ffffffff811bb22e>] btrfs_wait_logged_extents+0xa4/0xdc
[ 6236.746561]  [<ffffffff810635c1>] ? finish_wait+0x5d/0x5d
[ 6236.746564]  [<ffffffff811d9489>] btrfs_sync_log+0x5ef/0x8a2
[ 6236.746567]  [<ffffffff811b43cf>] btrfs_sync_file+0x21b/0x24d
[ 6236.746569]  [<ffffffff811b43cf>] ? btrfs_sync_file+0x21b/0x24d
[ 6236.746571]  [<ffffffff8110db8a>] vfs_fsync_range+0x1c/0x1e
[ 6236.746574]  [<ffffffff810d1681>] SyS_msync+0x15d/0x1ea
[ 6236.746575]  [<ffffffff81588712>] system_call_fastpath+0x16/0x1b

THis is aptitude, but I have all the other tasks accessing the disk
hanging, too.

This time, issueing a Sysrq-s for emergency syncing did the laptop
out of the hang.

Hardware: Sonly VAIO Pro 13
Distribution: Debian/sid
self compiled kernel, config on request.

Please let me know if there is anything else I can provide.

Thanks a lot

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
