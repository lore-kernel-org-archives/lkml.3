Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaE2H7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:59:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:46659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaE2H7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:59:17 -0400
Date: Thu, 29 May 2014 09:59:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140529075911.GB30445@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <538676A7.6090306@oracle.com>
 <53869C0A.3020400@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="geeFENrZXK6HHgAa"
Content-Disposition: inline
In-Reply-To: <53869C0A.3020400@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--geeFENrZXK6HHgAa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 10:31:38PM -0400, Sasha Levin wrote:
> I've just had this:
>=20
>=20
> [  591.111854] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGE=
ALLOC
> [  591.121057] Dumping ftrace buffer:
> [  591.121057]    (ftrace buffer empty)
> [  591.121057] Modules linked in:
> [  591.121057] CPU: 14 PID: 10272 Comm: trinity-c230 Tainted: G        W =
    3.15.0-rc7-next-20140528-sasha-00019-gd193e91-dirty #545
> [  591.121057] task: ffff8802df0d3000 ti: ffff8802df0fe000 task.ti: ffff8=
802df0fe000
> [  591.129130] RIP: perf_event_exit_task (kernel/events/core.c:7492 kerne=
l/events/core.c:7524)
> [  591.129130] RSP: 0000:ffff8802df0ffe28  EFLAGS: 00010246
> [  591.129130] RAX: 0000000000000000 RBX: ffff8802df0d3000 RCX: 000000000=
0000001
> [  591.129130] RDX: 0000000000000000 RSI: ffffffff97088100 RDI: 000000000=
0000282
> [  591.129130] RBP: ffff8802df0ffe98 R08: 0000000000000000 R09: 000000000=
0000000
> [  591.129130] R10: 0000000000000001 R11: 0000000000000000 R12: 6b6b6b6b6=
b6b6b6b
> [  591.129130] R13: 6b6b6b6b6b6b6b6b R14: ffff8806c9bfd550 R15: 000000000=
0000001
> [  591.129130] FS:  00007f4b26866700(0000) GS:ffff88036ae00000(0000) knlG=
S:0000000000000000
> [  591.129130] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  591.129130] CR2: 0000000001a3a9f8 CR3: 000000001702c000 CR4: 000000000=
00006a0
> [  591.129130] Stack:
> [  591.129130]  ffff8802df0ffe48 ffff8802df09cce0 ffff8802fdf99488 ffff88=
02fdf99290
> [  591.129130]  ffff8806c9bfd5a8 ffff8806c9bfd670 ffff8802df0ffe88 6b6b6b=
6b6b6b6b6b
> [  591.129130]  ffff8802df0ffe98 0000000000000001 0000000000000001 ffff88=
02df0d3000
> [  591.129130] Call Trace:
> [  591.129130] do_exit (kernel/exit.c:766)
> [  591.129130] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [  591.129130] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 =
kernel/locking/lockdep.c:2599)
> [  591.129130] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
> [  591.129130] do_group_exit (kernel/exit.c:884)
> [  591.129130] SyS_exit_group (kernel/exit.c:895)
> [  591.129130] tracesys (arch/x86/kernel/entry_64.S:542)
> [ 591.129130] Code: a0 02 00 00 49 89 95 a8 02 00 00 4c 8b 45 a0 4c 89 c7=
 e8 11 c2 2c 03 48 8b 45 a8 48 89 c7 e8 15 7c ff ff 4c 89 ef e8 bd 7b ff ff=
 <49> 8b 45 00 48 89 45 c8 4c 8b 6d c8 e8 cc 19 f6 ff 85 c0 74 0e
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:	a0 02 00 00 49 89 95 	movabs 0x2a8958949000002,%al
>    7:	a8 02
>    9:	00 00                	add    %al,(%rax)
>    b:	4c 8b 45 a0          	mov    -0x60(%rbp),%r8
>    f:	4c 89 c7             	mov    %r8,%rdi
>   12:	e8 11 c2 2c 03       	callq  0x32cc228
>   17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
>   1b:	48 89 c7             	mov    %rax,%rdi
>   1e:	e8 15 7c ff ff       	callq  0xffffffffffff7c38
>   23:	4c 89 ef             	mov    %r13,%rdi
>   26:	e8 bd 7b ff ff       	callq  0xffffffffffff7be8
>   2b:*	49 8b 45 00          	mov    0x0(%r13),%rax		<-- trapping instruct=
ion
>   2f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
>   33:	4c 8b 6d c8          	mov    -0x38(%rbp),%r13
>   37:	e8 cc 19 f6 ff       	callq  0xfffffffffff61a08
>   3c:	85 c0                	test   %eax,%eax
>   3e:	74 0e                	je     0x4e
> 	...
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:	49 8b 45 00          	mov    0x0(%r13),%rax
>    4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
>    8:	4c 8b 6d c8          	mov    -0x38(%rbp),%r13
>    c:	e8 cc 19 f6 ff       	callq  0xfffffffffff619dd
>   11:	85 c0                	test   %eax,%eax
>   13:	74 0e                	je     0x23
> 	...
> [  591.129130] RIP perf_event_exit_task (kernel/events/core.c:7492 kernel=
/events/core.c:7524)
> [  591.129130]  RSP <ffff8802df0ffe28>
>=20
>=20
> Seems similar enough.

Shiny, you got the code bits scripted ;-)

Yeah, looks about the same, one of the list elements (I checked, its not
the list head itself, or at least it wasn't when I managed to hit) was
freed while still on the list.

--geeFENrZXK6HHgAa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThujPAAoJEHZH4aRLwOS65XwQAICnnc/O8BxmBFd+H3tnor8u
z7gmmjVg8bM3jSgDDHpvbZcRMC+dEAuuP6Ha/Jpg4bcqn3jnZ9h02wwCnbU63DLB
G2ph42+sVVEqMQczWatEZmjbirxL3RXZpAoS5c1WV8Pf5sTcAeSUWU8T+1hRAGZg
U3o5wKWNKB05MX+ifrsIvXqSiQaWup7DYLUyP0T2qbld4Cy1fZuNRYqtL1Y/mC/b
9L/pR8FqYUXddL24f8QmoAVGS7Ef61OPHrXWcLbIP5pF3Ox903qazCFJOhPeh7EP
6SMo4WdZRIBfQroC9EapL/wCXNkOO9mKvylucVHBX1+DCWz9jRtaJqHXGReU9JZP
Zmlr0y97exyK44UZcrsW+LAdsFyRL2QDQCHKVfHvgM8qyzaCjKGsd8ZSxt/vAaSv
VFFFAAq8Joh+F9wOzO9MIOOsfGJQkpvNzdlpFWCpim0n6pQQxqnj2nrkqrTCRsS5
j0Xgvd8nsHrcdUIpjbRkS/VO6rVNlYBT/6prLBzFtV6Z5bmmR9wgUwlfoVinKf5u
Xn7tRxsVKdXAkg4IBu1K/dEV/TJhs+wCQf1VAFdDKeqAQObh1ITbhstMXRM4ejit
sHpwTF+g8rk3R9Rl3l5Z15reQDWVXIAgJruPtdicWKVMjlcL7aVyYO0qYJuiP9Pc
mj2R+viYMyxAqRDrrPUM
=pSTJ
-----END PGP SIGNATURE-----

--geeFENrZXK6HHgAa--
