Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaEOSLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:11:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:60679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaEOSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:11:10 -0400
Date: Thu, 15 May 2014 20:11:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        edumazet@google.com, viro@zeniv.linux.org.uk, jbaron@akamai.com
Subject: eventpoll __list_del_entry corruption (was: perf: use after free in
 perf_remove_from_context)
Message-ID: <20140515181102.GH11096@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e4tCsK4+RPJB2X0k"
Content-Disposition: inline
In-Reply-To: <5370EBE9.6@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e4tCsK4+RPJB2X0k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
> Hi all,
>=20
> While fuzzing with trinity inside a KVM tools guest running the latest -n=
ext
> kernel I've stumbled on the following spew. Maybe related to the very rec=
ent
> change in freeing on task exit?
>=20

While fuzzing to reproduce; I hit this one, is it a known one or should
I go poke the right people about it?

---
[ 5823.689985] ------------[ cut here ]------------
[ 5823.690004] WARNING: CPU: 3 PID: 2508 at /usr/src/linux-2.6/lib/list_deb=
ug.c:59 __list_del_entry+0xa1/0xd0()
[ 5823.690004] list_del corruption. prev->next should be ffff880131111de0, =
but was 6b6b6b6b6b6b6b6b
[ 5823.690004] Modules linked in:
[ 5823.690004] CPU: 3 PID: 2508 Comm: trinity-main Not tainted 3.15.0-rc5-0=
1700-g505011124ad0-dirty #1072
[ 5823.690004] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[ 5823.690004]  0000000000000009 ffff880432709ca8 ffffffff81681aa2 ffff8804=
32709cf0
[ 5823.690004]  ffff880432709ce0 ffffffff8109807c ffff880131111de0 ffff8801=
31111dc8
[ 5823.690004]  0000000000000286 ffff8800b9dd5618 ffff88023699b720 ffff8804=
32709d40
[ 5823.690004] Call Trace:
[ 5823.690004]  [<ffffffff81681aa2>] dump_stack+0x4e/0x7a
[ 5823.690004]  [<ffffffff8109807c>] warn_slowpath_common+0x8c/0xc0
[ 5823.690004]  [<ffffffff8109816c>] warn_slowpath_fmt+0x4c/0x50
[ 5823.690004]  [<ffffffff810ec8bf>] ? do_raw_spin_lock+0x13f/0x160
[ 5823.690004]  [<ffffffff8138c661>] __list_del_entry+0xa1/0xd0
[ 5823.690004]  [<ffffffff8138c69d>] list_del+0xd/0x30
[ 5823.690004]  [<ffffffff810dfa71>] remove_wait_queue+0x31/0x50
[ 5823.690004]  [<ffffffff812152aa>] ep_unregister_pollwait.isra.9+0x6a/0xb0
[ 5823.690004]  [<ffffffff81215268>] ? ep_unregister_pollwait.isra.9+0x28/0=
xb0
[ 5823.690004]  [<ffffffff8121531f>] ep_remove+0x2f/0xe0
[ 5823.690004]  [<ffffffff81215705>] eventpoll_release_file+0x65/0xa0
[ 5823.690004]  [<ffffffff811cf259>] __fput+0x1d9/0x1e0
[ 5823.690004]  [<ffffffff811cf2ae>] ____fput+0xe/0x10
[ 5823.690004]  [<ffffffff810b91f4>] task_work_run+0xc4/0xe0
[ 5823.690004]  [<ffffffff8109a544>] do_exit+0x2d4/0xa90
[ 5823.690004]  [<ffffffff813825c4>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 5823.690004]  [<ffffffff8109ae2c>] do_group_exit+0x4c/0xc0
[ 5823.690004]  [<ffffffff8109aeb7>] SyS_exit_group+0x17/0x20
[ 5823.690004]  [<ffffffff8168a2c2>] system_call_fastpath+0x16/0x1b
[ 5823.690004] ---[ end trace 515b7fa3169c0906 ]---

--e4tCsK4+RPJB2X0k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdQMrAAoJEHZH4aRLwOS6HbsQAJX3ZbIcCR/2e2Rr2jAZJNmO
7GODKU6CFOKa1aE0TjZnse63ld7cCEKNeFhGg/Fz+wJqYX0hQi3PaeeTB3UGPYL3
+EHs/U+sdAsxf71GOBgAgsJB680j99XuBtzv1NlWfdFZt64aLGRqoY3Lf09rTJIw
edgbMwQp6mWvlxFhEp3XlAupXvLncoZUeCbxRSDABnD/Jp9YcgW/f7hyaQpDlXZU
gOSM7w8FY1YaDuwk17oeI6nYido14V1P2fg3ea82ujtx9iMd+vZ1c2rvwA4e0ZCj
WUakGtYXQxlQ04eINUvOj8OSY62nfku2dDbPDkxaKdI/SV3RY0qO0x5dqqiu8rkG
VKgifiPDoDptqdaBNwoQKIU0fDdHQXMSwsbMltprOFbi8oxhH0eFguor3YGdzG2a
qOW2uJtDnXgwhB8N0XioKZh2KxZ0N13JTSebVmHBIl0Lqfysz4/51vDpL1q3NSGV
EZ+nKV8bU4BWOE/ea9V5XpJ5ekY/u8m2AdpoQJ/kFkYWjFuIMmi7Gz71Rq4H6T3o
HrLzGixphX8XIIMHPWrPB/4zNcIGa/bfs2WvxqucS6MuU3AYMIb8ySAykOR2DADX
kiO3dN5dbH5KsXFO7r3JChkegvUlQ4jGrcnYU176BScZIcKErR5phyJkhAeaZYzV
HdZQmdfieIv3nX07E7Iu
=0Wf7
-----END PGP SIGNATURE-----

--e4tCsK4+RPJB2X0k--
