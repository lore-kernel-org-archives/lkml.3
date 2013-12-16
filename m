Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3LPJOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:14:38 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:48873 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab3LPJOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:14:33 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lockup on Sun Fire V240 under load
Date: Mon, 16 Dec 2013 10:14:12 +0100
Message-ID: <46248540.hTgr7HZVB3@caliban.sf-tec.de>
User-Agent: KMail/4.11.4 (Linux/3.12.2-1.gd85f6ec-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <32994976.A7tuLDhD29@devpool02>
References: <32994976.A7tuLDhD29@devpool02>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1965569.nzJELHxfyE"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1965569.nzJELHxfyE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

> I recompiled both binutils and gcc in parallel (independent of each other).
> Only minutes after I started this the machine locked up. The machine has
> 8GiB of RAM and was otherwise idle.

This time it was trying to generate a new OpenSSL cert (qmail-genrsacert from 
Gentoo):

[209482.600816] BUG: NMI Watchdog detected LOCKUP on CPU1, ip 0042f748, registers:
[209482.696963] CPU: 1 PID: 4612 Comm: qmail-genrsacer Not tainted 3.12.5 #1
[209482.786173] task: fffff8033a019980 ti: fffff8033c4c4000 task.ti: fffff8033c4c4000
[209482.885679] TSTATE: 0000009911e01605 TPC: 000000000042f748 TNPC: 000000000042f3c0 Y: 00000000    Not tainted
[209483.016074] TPC: <__delay+0x28/0x60>
[209483.064099] g0: fffff8033c9c9458 g1: 000000000042f3c0 g2: 0000000000000002 g3: 000000000001869e
[209483.179617] g4: fffff8033a019980 g5: fffff8133c59a000 g6: fffff8033c4c4000 g7: 0000000000000000
[209483.295135] o0: 0000000000000006 o1: fffff8033c4c4400 o2: 000000000043d6fc o3: 0000000000000000
[209483.410651] o4: 0000000000000000 o5: 00000000f7e58000 sp: fffff8033c4c70f1 ret_pc: 000000000042f744
[209483.530745] RPC: <__delay+0x24/0x60>
[209483.578778] l0: 000002494a37a682 l1: 00000000009ce348 l2: 000000000043d6f8 l3: 0000000000000400
[209483.694301] l4: 000000000000000e l5: 0000000000000001 l6: 0000000000000000 l7: 0000000000000008
[209483.809820] i0: 0000000000000018 i1: 0000000000000000 i2: 0000000000000001 i3: 0000000000000000
[209483.925338] i4: 0000000000000000 i5: 0000000000000003 i6: fffff8033c4c71a1 i7: 000000000043d704
[209484.040864] I7: <cheetah_xcall_deliver+0x184/0x2a0>
[209484.106041] Call Trace:
[209484.139211]  [000000000043d704] cheetah_xcall_deliver+0x184/0x2a0
[209484.220418]  [000000000043d410] xcall_deliver+0x110/0x140
[209484.292478]  [00000000004960fc] check_preempt_wakeup+0x11c/0x1e0
[209484.372534]  [000000000048db74] check_preempt_curr+0x94/0xc0
[209484.448023]  [0000000000490548] wake_up_new_task+0x108/0x1a0
[209484.523512]  [00000000004608e8] do_fork+0xa8/0x220
[209484.587557]  [000000000042ca88] sparc_do_fork+0x28/0x60
[209484.657328]  [0000000000406174] linux_sparc_syscall32+0x34/0x40
[209484.736242] CPU: 1 PID: 4612 Comm: qmail-genrsacer Not tainted 3.12.5 #1
[209484.825451] Call Trace:
[209484.858628]  [0000000000878c28] perfctr_irq+0x2a8/0x360
[209484.928392]  [00000000004209f4] tl0_irq15+0x14/0x20
[209484.993583]  [000000000042f748] __delay+0x28/0x60
[209485.056489]  [000000000043d704] cheetah_xcall_deliver+0x184/0x2a0
[209485.137693]  [000000000043d410] xcall_deliver+0x110/0x140
[209485.209750]  [00000000004960fc] check_preempt_wakeup+0x11c/0x1e0
[209485.289809]  [000000000048db74] check_preempt_curr+0x94/0xc0
[209485.365297]  [0000000000490548] wake_up_new_task+0x108/0x1a0
[209485.440782]  [00000000004608e8] do_fork+0xa8/0x220
[209485.504831]  [000000000042ca88] sparc_do_fork+0x28/0x60
[209485.574601]  [0000000000406174] linux_sparc_syscall32+0x34/0x40
[209485.653565] BUG: soft lockup - CPU#1 stuck for 33s! [qmail-genrsacer:4612]
[209485.745119] Modules linked in: ipv6 openpromfs libcrc32c multipath linear raid456 async_pq async_xor xor async_memcpy async_raid6_recov async_tx raid6_pq dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log usb_storage sg
[209486.004746] CPU: 1 PID: 4612 Comm: qmail-genrsacer Not tainted 3.12.5 #1
[209486.093959] task: fffff8033a019980 ti: fffff8033c4c4000 task.ti: fffff8033c4c4000
[209486.193469] TSTATE: 0000004480001607 TPC: 0000000000878c7c TNPC: 0000000000878c80 Y: 00000000    Not tainted
[209486.323858] TPC: <perfctr_irq+0x2fc/0x360>
[209486.378749] g0: 0000000000003f40 g1: 0000000000000000 g2: 0000000100000000 g3: 00000000feff0000
[209486.494271] g4: fffff8033a019980 g5: fffff8133c59a000 g6: fffff8033c4c4000 g7: 0000000000000720
[209486.609787] o0: 000000000092ec00 o1: fffff8033c4c7ea0 o2: 000000000042f748 o3: 000000000092b400
[209486.725304] o4: 0000000000000008 o5: fffff8033c4c7f40 sp: fffff8133fe97741 ret_pc: 0000000000878c54
[209486.845399] RPC: <perfctr_irq+0x2d4/0x360>
[209486.900292] l0: fffff8033c4c6ee1 l1: 000000000092ec00 l2: 0000000000000000 l3: fffff81339bca000
[209487.015813] l4: fffff8033a019980 l5: 0000000000000000 l6: 0000000000000008 l7: 00000000f7d5c000
[209487.131332] i0: 000000000000000f i1: fffff8033c4c7850 i2: fffff8033c4c7900 i3: 0000000000000000
[209487.246848] i4: 000000000000004f i5: 0000000000000002 i6: fffff8033c4c6f91 i7: 00000000004209f4
[209487.362367] I7: <tl0_irq15+0x14/0x20>
[209487.411537] Call Trace:
[209487.444708]  [00000000004209f4] tl0_irq15+0x14/0x20
[209487.509905]  [000000000042f748] __delay+0x28/0x60
[209487.572809]  [000000000043d704] cheetah_xcall_deliver+0x184/0x2a0
[209487.654013]  [000000000043d410] xcall_deliver+0x110/0x140
[209487.726070]  [00000000004960fc] check_preempt_wakeup+0x11c/0x1e0
[209487.806130]  [000000000048db74] check_preempt_curr+0x94/0xc0
[209487.881616]  [0000000000490548] wake_up_new_task+0x108/0x1a0
[209487.957102]  [00000000004608e8] do_fork+0xa8/0x220
[209488.021151]  [000000000042ca88] sparc_do_fork+0x28/0x60
[209488.090920]  [0000000000406174] linux_sparc_syscall32+0x34/0x40

--nextPart1965569.nzJELHxfyE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlKuxG4ACgkQXKSJPmm5/E58uQCcC+c/1IphO3JoCuT7lWFMHzI7
peEAn1+NJuiSZ7dhtXAlei5wCZrRW4zW
=PBSB
-----END PGP SIGNATURE-----

--nextPart1965569.nzJELHxfyE--

