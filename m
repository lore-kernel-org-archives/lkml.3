Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaI3RFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:05:31 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:60232 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaI3RFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:05:30 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: linux-kernel@vger.kernel.org
Subject: next-20140930 dies while trying to leave initramfs
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1412096723_2351P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Sep 2014 13:05:23 -0400
Message-ID: <4053.1412096723@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1412096723_2351P
Content-Type: text/plain; charset=us-ascii

Seeing a number of different tracebacks right around when the initramfs
is trying to pivot over to the real root. Out of 4 testing boots, I've seen
4 failures.  next-20140922 runs fine.  Anybody recognize this, before I
spend several hours bisecting?

Traceback 1 (Seen 3 times)

[   37.243757] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   37.500350] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   37.553497] general protection fault: 0000 [#1] PREEMPT SMP
[   37.553548] Modules linked in:
[   37.553571] CPU: 1 PID: 274 Comm: systemd-udevd Not tainted 3.17.0-rc7-next-20140930-dirty #31
[   37.553618] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
[   37.553659] task: ffff8800bd871810 ti: ffff88022241c000 task.ti: ffff88022241c000
[   37.555308] RIP: 0010:[<ffffffffb5171d12>]  [<ffffffffb5171d12>] atomic64_add_unless.constprop.3+0x10/0x7f
[   37.557005] RSP: 0018:ffff88022241fdd8  EFLAGS: 00010296
[   37.558648] RAX: ffff8800bd871801 RBX: 24a7ca3510f61eb3 RCX: 01ff88022241fef8
[   37.560315] RDX: ffff8800bd871f58 RSI: 0000000000000000 RDI: 24a7ca3510f61e9b
[   37.561951] RBP: ffff88022241fe08 R08: 0000000000000000 R09: 0000000000000000
[   37.563597] R10: 0000000000000000 R11: 0000000000000000 R12: 24a7ca3510f61e9b
[   37.565209] R13: ffff880224c2c1c0 R14: ffff8800bd871f58 R15: ffff88022241fef8
[   37.566871] FS:  00007f0d39acb880(0000) GS:ffff88022dc80000(0000) knlGS:0000000000000000
[   37.568524] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.570145] CR2: 00007fe11b400afc CR3: 0000000035c11000 CR4: 00000000001407e0
[   37.571792] Stack:
[   37.573431]  ffff8800bd871f58 01ff88022241fef8 ffff880224c2c1c0 24a7ca3510f61eb3
[   37.575113]  24a7ca3510f61e9b ffff880224c2c1c0 ffff88022241fe38 ffffffffb5171ede
[   37.576784]  0000000000000000 ffff880224c2c1c0 0000000000000001 ffff880224c2c000
[   37.578472] Call Trace:
[   37.580080]  [<ffffffffb5171ede>] mnt_pin_kill+0x37/0x51
[   37.581703]  [<ffffffffb5162485>] cleanup_mnt+0x83/0xc1
[   37.583301]  [<ffffffffb51624f9>] __cleanup_mnt+0xd/0xf
[   37.584868]  [<ffffffffb5059d42>] task_work_run+0x79/0xa6
[   37.586456]  [<ffffffffb50403fe>] do_exit+0x5f6/0xc74
[   37.588028]  [<ffffffffb50dd538>] ? time_hardirqs_off+0x1b/0x2f
[   37.589626]  [<ffffffffb507b45d>] ? trace_hardirqs_off_caller+0x4c/0xb9
[   37.591229]  [<ffffffffb56ba78d>] ? retint_swapgs+0xe/0x13
[   37.592829]  [<ffffffffb5041bab>] do_group_exit+0x63/0xe0
[   37.594379]  [<ffffffffb5041c37>] SyS_exit_group+0xf/0xf
[   37.595919]  [<ffffffffb56b9bd2>] system_call_fastpath+0x12/0x17
[   37.597435] Code: b5 be 64 03 00 00 48 c7 c7 94 fc ad b5 c6 05 b1 68 b6 00 01 e8 c0 ab f0 ff c9 c3 55 48 89 e5 41 55 41 54 49 89 fc 53 48 83 ec 18
 <48> 8b 1f 48 85 db 48 c7 c7 a8 86 d1 b5 41 0f 94 c5 31 d2 41 0f
[   37.599302] RIP  [<ffffffffb5171d12>] atomic64_add_unless.constprop.3+0x10/0x7f
[   37.600963]  RSP <ffff88022241fdd8>
[   37.602657] ---[ end trace f3df00396480e702 ]---


Traceback 2 (seen once so far).
[   15.467644] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   15.706228] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   15.745685] general protection fault: 0000 [#1] PREEMPT SMP
[   15.745731] Modules linked in:
[   15.745753] CPU: 2 PID: 272 Comm: systemd-udevd Not tainted 3.17.0-rc7-next-20140930-dirty #31
[   15.745800] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
[   15.745839] task: ffff880222451ad0 ti: ffff880222474000 task.ti: ffff880222474000
[   15.745878] RIP: 0010:[<ffffffffb0161a1c>]  [<ffffffffb0161a1c>] mnt_add_count.isra.18+0x5/0x9
[   15.747524] RSP: 0018:ffff880222477dc8  EFLAGS: 00010286
[   15.749106] RAX: ffff880224c0d820 RBX: ffff88021b8cc9c0 RCX: 0000000000000028
[   15.750715] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88021b8cc9e0
[   15.752337] RBP: ffff880222477dd8 R08: dead000000200200 R09: 0000000000000000
[   15.753948] R10: ffffffffffffffed R11: ffffffffffffffec R12: ffff880222451ad0
[   15.755565] R13: ffff880222452218 R14: 0000000000000000 R15: ffff880222477ef8
[   15.757130] FS:  0000000000000000(0000) GS:ffff88022dd00000(0000) knlGS:0000000000000000
[   15.758757] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.760367] CR2: 00007fcd21224148 CR3: 0000000030c11000 CR4: 00000000001407e0
[   15.762000] Stack:
[   15.763605]  ffffffffb0161a3b ffff880224c0d800 ffff880222477e08 ffffffffb01629a9
[   15.765250]  ffff880224c0d820 ffff8802233ff180 ffff880222477e08 ffff880224c0d820
[   15.766888]  ffff880222477e28 ffffffffb0163e6f ffff880224c0d800 ffff88022302a880
[   15.768528] Call Trace:
[   15.770134]  [<ffffffffb0161a3b>] ? mntget+0x1b/0x21
[   15.771746]  [<ffffffffb01629a9>] namespace_unlock+0x6d/0xbc
[   15.773304]  [<ffffffffb0163e6f>] drop_collected_mounts+0x28/0x2c
[   15.774845]  [<ffffffffb0164f98>] put_mnt_ns+0x1c/0x30
[   15.776386]  [<ffffffffb005bf27>] free_nsproxy+0x17/0x65
[   15.777925]  [<ffffffffb005c06e>] switch_task_namespaces+0x60/0x69
[   15.779483]  [<ffffffffb005c082>] exit_task_namespaces+0xb/0xd
[   15.781013]  [<ffffffffb00403f9>] do_exit+0x5f1/0xc74
[   15.782585]  [<ffffffffb00dd538>] ? time_hardirqs_off+0x1b/0x2f
[   15.784135]  [<ffffffffb007b45d>] ? trace_hardirqs_off_caller+0x4c/0xb9
[   15.785679]  [<ffffffffb06ba78d>] ? retint_swapgs+0xe/0x13
[   15.787152]  [<ffffffffb0041bab>] do_group_exit+0x63/0xe0
[   15.788664]  [<ffffffffb0041c37>] SyS_exit_group+0xf/0xf
[   15.790122]  [<ffffffffb06b9bd2>] system_call_fastpath+0x12/0x17
[   15.791627] Code: 92 c4 b0 e8 fa 49 12 00 39 1d 71 c9 c1 01 7e 06 89 1d 69 c9 c1 01 48 c7 c7 d0 91 c4 b0 e8 5b 74 55 00 58 5b 5d c3 55 48 89 e5 5d
 <65> 01 37 c3 55 48 85 ff 48 89 e5 53 48 89 fb 74 0e 48 8b 7f 28
[   15.793422] RIP  [<ffffffffb0161a1c>] mnt_add_count.isra.18+0x5/0x9
[   15.795076]  RSP <ffff880222477dc8>
[   15.796766] ---[ end trace 80ef64c1c9a84aca ]---


--==_Exmh_1412096723_2351P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVCri0wdmEQWDXROgAQLuvw//TF3myGYbm1HKgDJCUjYFY9Z434KpjFlr
XhHjZkShTey7YPQA765G1Cn+gaXj67ennscpA/p7D/Y2i3v0nO1YjMEPn218U8Cf
bs0/ZrX044P5qYoOMRHiN/8F62fjlobMtJzl9rrsnqd/inyFAMVHooAwSd7KCo7W
QnlTu6tZrOZoCUBWpD8iQ780HIWzIC4E/egsEBScz5TkYk8bT1ZlSNjirrn8xftn
eUvkFvTchD4HDQYnSfTOVoqFYOToUlTAx75Z4jf877DO+eME33p0d5rvD9h3RIf9
vdElPXtP+oxc9ZXjRG/jeM0hc5uV6nDgirtPiuplPwk0p0Bug2o3kZy5+yH84VB1
tYtKzJpbozZKzIud9chp0ZPLxWobJkeOQRHGQ3qkziWhHp27SJ+4/rdbNpuLkNOO
PZIdLYYufu2w49+uB9bwuokMDMtq+Mh3l5lk3TWM7DCDTjsMZAij58Zt1dK/YX+W
IMuB55UfDhR8BEVOiRmU2OoPCkaTt/WrBQVmMxMnHogLZxCS07FEJlAqbiq3TkI7
CTcPlFkND2uboiCouVdPyg020/3hE6yBEPcR5mYar3lrIcTPtNBMrYdm/Yi01N5O
OXUegtBrLzt0sb7RYScac0I/ZDHxJJdLwlZyp+RbKJkXHNMuTy++0h37gFOgGwvw
lMO5K8BO0B0=
=oc82
-----END PGP SIGNATURE-----

--==_Exmh_1412096723_2351P--
