Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaEUIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:25:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaEUIZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:25:26 -0400
Date: Wed, 21 May 2014 10:25:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        edumazet@google.com, viro@zeniv.linux.org.uk, jbaron@akamai.com,
        hughd@google.com, mgorman@suse.de
Subject: BUG at /usr/src/linux-2.6/mm/filemap.c:202 (was: perf: use after
 free in perf_remove_from_context)
Message-ID: <20140521082511.GU13658@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140515181102.GH11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0y1lerN6xYE2ROn"
Content-Disposition: inline
In-Reply-To: <20140515181102.GH11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o0y1lerN6xYE2ROn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 08:11:02PM +0200, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
> > Hi all,
> >=20
> > While fuzzing with trinity inside a KVM tools guest running the latest =
-next
> > kernel I've stumbled on the following spew. Maybe related to the very r=
ecent
> > change in freeing on task exit?
> >=20
>=20
> While fuzzing to reproduce; I hit this one, is it a known one or should
> I go poke the right people about it?
>=20
> ---
> [ 5823.689985] ------------[ cut here ]------------
> [ 5823.690004] WARNING: CPU: 3 PID: 2508 at /usr/src/linux-2.6/lib/list_d=
ebug.c:59 __list_del_entry+0xa1/0xd0()
> [ 5823.690004] list_del corruption. prev->next should be ffff880131111de0=
, but was 6b6b6b6b6b6b6b6b
> [ 5823.690004] Modules linked in:
> [ 5823.690004] CPU: 3 PID: 2508 Comm: trinity-main Not tainted 3.15.0-rc5=
-01700-g505011124ad0-dirty #1072
> [ 5823.690004] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/20=
10
> [ 5823.690004]  0000000000000009 ffff880432709ca8 ffffffff81681aa2 ffff88=
0432709cf0
> [ 5823.690004]  ffff880432709ce0 ffffffff8109807c ffff880131111de0 ffff88=
0131111dc8
> [ 5823.690004]  0000000000000286 ffff8800b9dd5618 ffff88023699b720 ffff88=
0432709d40
> [ 5823.690004] Call Trace:
> [ 5823.690004]  [<ffffffff81681aa2>] dump_stack+0x4e/0x7a
> [ 5823.690004]  [<ffffffff8109807c>] warn_slowpath_common+0x8c/0xc0
> [ 5823.690004]  [<ffffffff8109816c>] warn_slowpath_fmt+0x4c/0x50
> [ 5823.690004]  [<ffffffff810ec8bf>] ? do_raw_spin_lock+0x13f/0x160
> [ 5823.690004]  [<ffffffff8138c661>] __list_del_entry+0xa1/0xd0
> [ 5823.690004]  [<ffffffff8138c69d>] list_del+0xd/0x30
> [ 5823.690004]  [<ffffffff810dfa71>] remove_wait_queue+0x31/0x50
> [ 5823.690004]  [<ffffffff812152aa>] ep_unregister_pollwait.isra.9+0x6a/0=
xb0
> [ 5823.690004]  [<ffffffff81215268>] ? ep_unregister_pollwait.isra.9+0x28=
/0xb0
> [ 5823.690004]  [<ffffffff8121531f>] ep_remove+0x2f/0xe0
> [ 5823.690004]  [<ffffffff81215705>] eventpoll_release_file+0x65/0xa0
> [ 5823.690004]  [<ffffffff811cf259>] __fput+0x1d9/0x1e0
> [ 5823.690004]  [<ffffffff811cf2ae>] ____fput+0xe/0x10
> [ 5823.690004]  [<ffffffff810b91f4>] task_work_run+0xc4/0xe0
> [ 5823.690004]  [<ffffffff8109a544>] do_exit+0x2d4/0xa90
> [ 5823.690004]  [<ffffffff813825c4>] ? lockdep_sys_exit_thunk+0x35/0x67
> [ 5823.690004]  [<ffffffff8109ae2c>] do_group_exit+0x4c/0xc0
> [ 5823.690004]  [<ffffffff8109aeb7>] SyS_exit_group+0x17/0x20
> [ 5823.690004]  [<ffffffff8168a2c2>] system_call_fastpath+0x16/0x1b
> [ 5823.690004] ---[ end trace 515b7fa3169c0906 ]---

I just hit this one, which is somewhat similar:

---
[ 4003.295259] ------------[ cut here ]------------
[ 4003.297195] kernel BUG at /usr/src/linux-2.6/mm/filemap.c:202!
[ 4003.297195] invalid opcode: 0000 [#1] PREEMPT SMP=20
[ 4003.297195] Modules linked in:
[ 4003.297195] CPU: 0 PID: 9360 Comm: trinity-c92 Not tainted 3.15.0-rc5-01=
700-g505011124ad0-dirty #1081
[ 4003.297195] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[ 4003.297195] task: ffff88042a9db900 ti: ffff88042aa7a000 task.ti: ffff880=
42aa7a000
[ 4003.297195] RIP: 0010:[<ffffffff81174af1>]  [<ffffffff81174af1>] __delet=
e_from_page_cache+0x2a1/0x2b0
[ 4003.297195] RSP: 0018:ffff88042aa7bb30  EFLAGS: 00010046
[ 4003.297195] RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffff88019dc=
d46a0
[ 4003.297195] RDX: 0000000000000146 RSI: ffffffff81a651f7 RDI: ffffffff81a=
2e091
[ 4003.297195] RBP: ffff88042aa7bb78 R08: 000000000000004e R09: ffff8801c4e=
fd138
[ 4003.297195] R10: 0000000000000012 R11: ffff88042aa7bb48 R12: ffffea00082=
8c280
[ 4003.297195] R13: ffff8801bc9a0890 R14: 0000000000000000 R15: ffff8801bc9=
a0898
[ 4003.297195] FS:  00007f984ad54700(0000) GS:ffff880237c00000(0000) knlGS:=
0000000000000000
[ 4003.297195] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4003.297195] CR2: 00007f9847813000 CR3: 0000000001c0e000 CR4: 00000000000=
007f0
[ 4003.297195] Stack:
[ 4003.297195]  ffff8801bc9a08a8 ffff8801bc9a08a8 ffff8801c4efd138 ffff8801=
c4efd1d0
[ 4003.297195]  ffffea000828c280 ffff8801bc9a08a8 0000000000000000 ffffffff=
ffffffff
[ 4003.297195]  000000000000004e ffff88042aa7bba0 ffffffff81174c98 ffffea00=
0828c280
[ 4003.297195] Call Trace:
[ 4003.297195]  [<ffffffff81174c98>] delete_from_page_cache+0x48/0x80
[ 4003.297195]  [<ffffffff81182d6b>] truncate_inode_page+0x5b/0x90
[ 4003.297195]  [<ffffffff8118d06a>] shmem_undo_range+0x2fa/0x6e0
[ 4003.297195]  [<ffffffff8118d464>] shmem_truncate_range+0x14/0x30
[ 4003.297195]  [<ffffffff8118d67d>] shmem_evict_inode+0xed/0x150
[ 4003.297195]  [<ffffffff811ea377>] evict+0xa7/0x170
[ 4003.297195]  [<ffffffff811eaaa5>] iput+0x105/0x190
[ 4003.297195]  [<ffffffff811e51c8>] dentry_kill+0x268/0x2e0
[ 4003.297195]  [<ffffffff811e54e9>] dput+0x69/0x110
[ 4003.297195]  [<ffffffff811cf66c>] __fput+0x16c/0x1e0
[ 4003.297195]  [<ffffffff811cf72e>] ____fput+0xe/0x10
[ 4003.297195]  [<ffffffff810b91e7>] task_work_run+0xa7/0xe0
[ 4003.297195]  [<ffffffff8109a554>] do_exit+0x2d4/0xa90
[ 4003.297195]  [<ffffffff8168b351>] ? retint_swapgs+0xe/0x13
[ 4003.297195]  [<ffffffff8109ae3c>] do_group_exit+0x4c/0xc0
[ 4003.297195]  [<ffffffff8109aec7>] SyS_exit_group+0x17/0x20
[ 4003.297195]  [<ffffffff8168a742>] system_call_fastpath+0x16/0x1b
[ 4003.297195] Code: 45 d0 75 29 4c 89 30 e9 b0 fe ff ff 66 0f 1f 44 00 00 =
48 8b 75 c8 4c 89 ff e8 0c 71 20 00 84 c0 0f 85 96 fe ff ff e9 79 fe ff ff =
<0f> 0b e8 fe a7 50 00 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55=20
[ 4003.297195] RIP  [<ffffffff81174af1>] __delete_from_page_cache+0x2a1/0x2=
b0
[ 4003.297195]  RSP <ffff88042aa7bb30>
[ 4003.297195] ---[ end trace 2530b701678d4601 ]---

--o0y1lerN6xYE2ROn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfGLnAAoJEHZH4aRLwOS66eAP/0mYOvrByb9ZLGxDh5Nuqg6I
aVpgSZnJk6jACBA7qgiYunw2I7zZtczBQEe4SmoVE3u1EIDvpUHPFz/u0KyZg8ia
LErcsRotJ3Ox/AJBaUGFaEbhfYF02dJ/UNVZZCNmSzc8FwBeJLbXgUg4ifJHu4dL
atKksBbzAcqP5MvPbJt51VSjEq/2B8HQ0XnsRI5XD/3RnS6C+jLizcvfeFybTxgD
t7Lqn/UfWn+Y2HbjpCmZDJayM1m8zi3L0oEebAwGHtq2gj5YcPWoEiz3ODndTZo4
yth6jYzmkE6NBSrjb7tcmETP59DL1PZBeyGim07tG5Z+/OZR4bU/gMzM+xgcHch0
EZlHZOaudAXF1yL0CBTaMfbCTdvL07b+pe224c21pLYbtvdIWTNRBwDWdXSuAZYu
Qchto+eFnHPSLrl/VcLLyP6cSBQVUf0d0n4xOT5l274J8KG49YlXUolbzoSZ5GE3
yx4Rcy0oHi6n2ke5V75WMfzP9kvf8EcbUDmH+NX3lrZv7Hnqdc7DBBLigwm0unXP
mCaaU5w0q1I6ntTl64kD6QnkaPypxEo5OzSyQ6IODQDCngzPc20Ko3N+YWtZOK4y
TxNQ/qBz3lBD887Kmpj3OxjTV9yn/J8KJ3rIEhV6AVjGGw2kBptqB5JPOPba2pAB
yw8IP0+WKKbRv2JiJHyd
=FJNf
-----END PGP SIGNATURE-----

--o0y1lerN6xYE2ROn--
