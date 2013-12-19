Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaACR60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:58:26 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48599 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaACR6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:58:24 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: linux-kernel@vger.kernel.org
Subject: next-20131218 - BUG: spinlock wrong CPU on CPU#3, mount/563
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1387476045_3146P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 19 Dec 2013 13:00:45 -0500
Message-ID: <6106.1387476045@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1387476045_3146P
Content-Type: text/plain; charset=us-ascii

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


--==_Exmh_1387476045_3146P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUrM0TQdmEQWDXROgAQJu6A//aGdijeZGzMSxGhyQHkwIXz4QUfKV2/oJ
IagLiMVK+iSOZnXL1ZyL8IyZNX5FxFfREVWlTOCgreZoxYccA1g1sTL3yEBHZzKT
VU2B5TeRdWAzz9SYPuyOm5wxdguU4076EzEeUVtvax7sUJ9rV/w3fYU9DUUrYGiZ
MFIzeUq0lhPrdWLCI/wrZi4TUIb6wi5Ofq1nrsdTPCpgLpYtgcayBJekdZTf2mE2
+9awWzB8x0RwH5eJZPgXHajFuGQEhzXPM+FFv+WTMfRbJMPlhfETmKigxLV6gWz8
g492p0cCPdXdIaoatGCmX6lK5zZO4vU13SZTFTviYKbH4KgOtbObe/ZER754t06t
Tzi0CPMS6r1CD/+ZndCrjRwhPJRYp3cNxwSkSAFFmkNX9O3E5uDGHBf/CpGVKEe7
A8WrZ33gowZbzbjv7Ykf9nEsxrxbEH8m2y9eRrLZ2GTiwyokb78IKGrpkdAzpkiU
ZMhjYWQbJcV3BE6tybaiYI4gvvOzl8naQ8qFEvws4U4pHwmveFK+3Ag7/yNAg+Zf
gcNvJQUAKoovWU+U20sg9A5ZH9s+VRVJvbmKmZGJclzl0BOy+ZExMw4Cft+tpJyV
v2qTEz3TWIsvlI2aA/eQP67cxKREmSPvWPV2BPzjaqoDUsbA2oEYeaCp/Fd3uO7B
9LzucoI9eIw=
=g4pk
-----END PGP SIGNATURE-----

--==_Exmh_1387476045_3146P--
