Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab3IGQCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:02:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54280 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3IGQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:02:35 -0400
X-Nat-Received: from [202.181.97.72]:56047 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378569629.13785
To: maarten.lankhorst@canonical.com
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch, robdclark@gmail.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootable kernel.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 8 Sep 2013 01:00:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 07092013 #10996500, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed that 3.11 and current linux.git do not boot (they hang before
printing the "Linux version 3.10.0-rc7-00026-g040a0a3" line) when built with
CONFIG_DEBUG_MUTEXES=y using gcc (GCC) 3.3.5 (Debian 1:3.3.5-13). They boot OK
when built with the same config using gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3.

Bisection reached commit 040a0a37 "mutex: Add support for wound/wait style
locks". This commit might contain gcc version dependent trick, but how can I
find it?

Kernel config (only for testing whether the kernel version line is printed) is
at http://I-love.SAKURA.ne.jp/tmp/config-3.11-mutex and the command line I used
for testing is

  $ qemu-system-i386 -m 512 -nographic -kernel arch/x86/boot/bzImage --append "console=ttyS0,115200n8"

.

Regards.

---------- bisection log start ----------
# bad: [ad81f0545ef01ea651886dddac4bef6cec930092] Linux 3.11-rc1
# good: [8bb495e3f02401ee6f76d1b1d77f3ac9f079e376] Linux 3.10
# good: [c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1] Linux 3.9
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
# good: [28a33cbc24e4256c143dce96c7d93bf423229f92] Linux 3.5
# good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
# good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect start 'v3.11-rc1' 'v3.10' 'v3.9' 'v3.8' 'v3.7' 'v3.6' 'v3.5' 'v3.4' 'v3.3' 'v3.2' 'v3.1' 'v3.0'
# bad: [1286da8bc009cb2aee7f285e94623fc974c0c983] Merge tag 'sound-3.11' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect bad 1286da8bc009cb2aee7f285e94623fc974c0c983
# good: [ee1a8d402e7e204d57fb108aa40003b6d1633036] Merge tag 'dt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good ee1a8d402e7e204d57fb108aa40003b6d1633036
# bad: [3e34131a65127e73fbae68c82748f32c8af7e4a4] Merge tag 'stable/for-linus-3.11-rc0-tag-two' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect bad 3e34131a65127e73fbae68c82748f32c8af7e4a4
# bad: [790eac5640abf7a57fa3a644386df330e18c11b0] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad 790eac5640abf7a57fa3a644386df330e18c11b0
# bad: [f0bb4c0ab064a8aeeffbda1cee380151a594eaab] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad f0bb4c0ab064a8aeeffbda1cee380151a594eaab
# good: [3e42dee676e8cf5adca817b1518b2e99d1c138ff] Merge branch 'core-locking-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 3e42dee676e8cf5adca817b1518b2e99d1c138ff
# good: [130768b8c93cd8d21390a136ec8cef417153ca14] perf/x86/intel: Add Haswell PEBS record support
git bisect good 130768b8c93cd8d21390a136ec8cef417153ca14
# bad: [ab3d681e9d41816f90836ea8fe235168d973207f] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad ab3d681e9d41816f90836ea8fe235168d973207f
# good: [14961444696effb2e660fe876e5c1880f8bc3932] rcu: Shrink TINY_RCU by reworking CPU-stall ifdefs
git bisect good 14961444696effb2e660fe876e5c1880f8bc3932
# good: [be77f87c001b770f13fe742becb08b847d9542f1] Merge branches 'cbnum.2013.06.10a', 'doc.2013.06.10a', 'fixes.2013.06.10a', 'srcu.2013.06.10a' and 'tiny.2013.06.10a' into HEAD
git bisect good be77f87c001b770f13fe742becb08b847d9542f1
# bad: [2fe3d4b149ccebbb384062fbbe6634439f2bf120] mutex: Add more tests to lib/locking-selftest.c
git bisect bad 2fe3d4b149ccebbb384062fbbe6634439f2bf120
# bad: [040a0a37100563754bb1fee6ff6427420bcfa609] mutex: Add support for wound/wait style locks
git bisect bad 040a0a37100563754bb1fee6ff6427420bcfa609
# good: [a41b56efa70e060f650aeb54740aaf52044a1ead] arch: Make __mutex_fastpath_lock_retval return whether fastpath succeeded or not
git bisect good a41b56efa70e060f650aeb54740aaf52044a1ead
---------- bisection log end ----------
