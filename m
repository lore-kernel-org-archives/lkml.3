Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3LTRD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:03:26 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52623 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3LTRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:03:25 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: linux-kernel@vger.kernel.org
Subject: next-20131218 - BUG: spinlock wrong CPU on CPU#3, mount/563
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1387559001_2579P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Dec 2013 12:03:21 -0500
Message-ID: <6244.1387559001@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1387559001_2579P
Content-Type: text/plain; charset=us-ascii

(Resending, first try seems to have vanished in the ether)

Saw this while booting latest linux-next.  I've only triggered it once,
so I suspect a race condition of some sort that I don't always hit.

[   18.248796] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   18.267473] BUG: spinlock wrong CPU on CPU#3, mount/563
[   18.267476]  lock: 0xffff880124c3c4a8, .magic: dead4ead, .owner: mount/563, .owner_cpu: 35
[   18.267478] CPU: 3 PID: 563 Comm: mount Not tainted 3.13.0-rc4-next-20131218 #129
[   18.267480] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
[   18.267484]  0000000000000000 ffff880124815cd8 ffffffff8164c74f ffff88012486e590
[   18.267487]  ffff880124815cf8 ffffffff8107901b ffff880124c3c4a8 0000000000000001
[   18.267491]  ffff880124815d18 ffffffff81079046 ffff880124c3c4a8 ffffffff81a9fb92
[   18.267491] Call Trace:
[   18.267497]  [<ffffffff8164c74f>] dump_stack+0x4f/0xa2
[   18.267501]  [<ffffffff8107901b>] spin_dump+0x8c/0x91
[   18.267504]  [<ffffffff81079046>] spin_bug+0x26/0x28
[   18.267506]  [<ffffffff8107934d>] do_raw_spin_unlock+0xdc/0xf3
[   18.267509]  [<ffffffff81656575>] _raw_spin_unlock_irqrestore+0x27/0x83
[   18.267512]  [<ffffffff81070c0d>] __wake_up+0x3f/0x46
[   18.267516]  [<ffffffff8115e334>] fsnotify_add_notify_event+0xba/0xdf
[   18.267519]  [<ffffffff811612e9>] ? SyS_inotify_rm_watch+0xf3/0xf3
[   18.267522]  [<ffffffff811614f6>] fanotify_handle_event+0x16f/0x256
[   18.267525]  [<ffffffff816571e0>] ? retint_restore_args+0xe/0xe
[   18.267528]  [<ffffffff8115dba9>] send_to_group.isra.1+0x114/0x123
[   18.267531]  [<ffffffff8115deb7>] fsnotify+0x2dd/0x41d
[   18.267533]  [<ffffffff8165650a>] ? _raw_spin_unlock+0x5b/0x67
[   18.267537]  [<ffffffff811257b8>] do_sys_open+0x109/0x12e
[   18.267540]  [<ffffffff811257f6>] SyS_open+0x19/0x1b
[   18.267543]  [<ffffffff8165d722>] system_call_fastpath+0x16/0x1b
[   18.371071] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   18.371564] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs

--==_Exmh_1387559001_2579P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUrR4WQdmEQWDXROgAQKYZw//fbv0U9E2swtHjMK1rnF/jvChaKm+awW0
EIDwlrBAaTAsvzCph8CClvuAJRdBbZKmtdAv5eur5wcLoVpGQt5V3U10JRAaXCuj
KPjDREvkGW6x2bb5OCbvJLkBwvP/nhGN/U2DzD4S5CpoF3p3OxwLerXOV72fSR0G
ZNpXNAG+0tPZQEkJDgy2MDRe2Yop5z2xK31Y/jwMLjAgxj+Q7A3XZei4DiR2puvp
MwI1it1//aFEyx9yMJscXalo1yqfNTAVk9k67IRBkM0a+vVGrLbS/L+6aEGXpdlp
GVCVwJvVJ1UJcwBWR9xnonDU7caujmgKsVmAWHhpum2CTr97LFtSF496ENsfVskn
KTkr0MwVe4+f1o5a5ltuGHW4yWb/ApQsFA1ToyKCaIDvd+xfKy7E5O6EXW5dcB6z
Flm8ikCpp4cDpxSh4jG5cX1Y8MmLuSXsfvdvKN6BwiQTig5RpecNIsfQBEHIy5Oh
XQAlLPetCwIfUq/V3J/FEPDplxS86LInGFNwSjhYjHS+0FEPa1lB/0PaNOqTPCip
RUN3FqtiK/aq5r5ZJJnshbiEth2QjEr9MBapqhBw3w2WVQF68KgZbkJMOfiLXGF7
Cg9M1buMk3Kh8no4H0lQqeEPJFlOJO0Wu7AzLPVy357Fv/7Bh4teTKvxL2TNT0Fg
RXSiBNWpCfo=
=9Wp3
-----END PGP SIGNATURE-----

--==_Exmh_1387559001_2579P--
