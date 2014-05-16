Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbaEPPfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:35:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaEPPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:35:16 -0400
Date: Fri, 16 May 2014 17:34:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        hpa@linux.intel.com, tytso@mit.edu, price@mit.edu,
        hannes@stressinduktion.org
Subject: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
Message-ID: <20140516153455.GV11096@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qzBiUkG7YMMDZbZI"
Content-Disposition: inline
In-Reply-To: <5370EBE9.6@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qzBiUkG7YMMDZbZI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


While fuzzing to reproduce my issue I hit the below, its triggered loads
of times and then the machine wedged (needed a power cycle), I can
provide the full console log if people care.

Anybody seen that one before?

---
[  861.777414] ------------[ cut here ]------------
[  861.777416] kernel BUG at /usr/src/linux-2.6/drivers/char/random.c:986!
[  861.777419] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  861.777421] Modules linked in:
[  861.777424] CPU: 1 PID: 9851 Comm: trinity-c321 Not tainted 3.15.0-rc5-0=
1700-g505011124ad0-dirty #1076
[  861.777425] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[  861.777426] task: ffff88022f68a600 ti: ffff88022f716000 task.ti: ffff880=
22f716000
[  861.777433] RIP: 0010:[<ffffffff81429ce4>]  [<ffffffff81429ce4>] account=
+0x164/0x170
[  861.777434] RSP: 0000:ffff88022f717e48  EFLAGS: 00010202
[  861.777435] RAX: ffffffff81c90788 RBX: 0000000000000991 RCX: 00000000000=
00000
[  861.777436] RDX: 0000000000000000 RSI: 0000000000000991 RDI: 00000000000=
02000
[  861.777437] RBP: ffff88022f717e70 R08: 0000000000000000 R09: 00000000000=
00000
[  861.777438] R10: 00000000000046c0 R11: 000000c8a18b27e1 R12: ffffffff81c=
90300
[  861.777439] R13: 0000000000000000 R14: ffffffff8142aff6 R15: ffffffff81a=
58605
[  861.777441] FS:  00007fba327ff700(0000) GS:ffff880237c20000(0000) knlGS:=
0000000000000000
[  861.777442] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  861.777443] CR2: 0000000000000010 CR3: 000000022f703000 CR4: 00000000000=
007e0
[  861.777444] Stack:
[  861.777446]  0000000000000991 0000000000007b44 0000000000000000 ffffffff=
8142aff6
[  861.777448]  ffffffff81a58605 ffff88022f717ed0 ffffffff8142ae82 00000000=
00000000
[  861.777450]  ffffffff81c90300 0000000000020000 ffff880233291240 ffff8804=
35788690
[  861.777451] Call Trace:
[  861.777454]  [<ffffffff8142aff6>] ? urandom_read+0x46/0x120
[  861.777455]  [<ffffffff8142ae82>] extract_entropy_user+0x52/0x180
[  861.777457]  [<ffffffff8142aff6>] urandom_read+0x46/0x120
[  861.777462]  [<ffffffff811cdf3b>] vfs_read+0xab/0x180
[  861.777464]  [<ffffffff811ce1b2>] SyS_read+0x52/0xb0
[  861.777466]  [<ffffffff8168c939>] ia32_do_call+0x13/0x13
[  861.777489] Code: c9 81 e8 a0 5e cb ff ba 02 00 02 00 be 1d 00 00 00 48 =
c7 c7 c0 e5 c6 82 e8 9a 64 db ff 48 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 =
<0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5=20
[  861.777491] RIP  [<ffffffff81429ce4>] account+0x164/0x170
[  861.777492]  RSP <ffff88022f717e48>
[  861.778140] ---[ end trace e70cc3dc70339c62 ]---
[  861.779282] ------------[ cut here ]------------

--qzBiUkG7YMMDZbZI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdjAfAAoJEHZH4aRLwOS6qBIP/0k+GJ1x9BkZdqb2HFrc4XP4
Vhsa2Hohbj2bIqgU6eNUKVbNKVxb/i2N5tcip6FU7a7ptVAOwJQ1UwUvnGAHdpuf
tYlEkYZPNOJ/3Z9Z+YsFF+2TxE5CYgT2fnsMnuUPqurJmajdfje+JMtK3DMFBmsP
wDVqFsfHCF9dkARo2YRDFuf4pP9vGzRVyLbhaqwVJ+T48vMho5jv15SFppAZp4o5
r01IvknRUNTxSk0IaKqDMztRHhlZlvRIZQooQ0DaJliLbCi2wPMP+x1u52/PWd2E
EJXb/6NCoSmncq0h88l6iPBdM5DriZVE84Ba+sOWZRxtWVe04r4wwU4ba6xbGswR
/rMgDfDxiIrm7y3agch+Z8T+VfxTMODQQ+uQ7URSICgNBELqq/EORW4VV2OnErUs
k4bP0LA7yGZ/vm+LMMsz+NOxgUxh8ZXPEb15ZxHNHFDn4Brzzusw9bAy0bbsFjlK
GPHO0FJbB6dxOuCejNse32hKF9dHCwMQrsmkR8YC4+oLUgqctZoYqiYkTn9+Vwzd
ShsJXTUILUBoovixgJKAszro5680s/cR7QxJgXelGh8ANobUoUMXa86vZjBctJ+A
cX8O2raZhAgaGLoUL++UO5OqHwl+4s60ybVh2ke6AZqJhvS1NxGMeP7S28a9S5f8
xcETmVNe3rLTBY4yVC2z
=Czc+
-----END PGP SIGNATURE-----

--qzBiUkG7YMMDZbZI--
