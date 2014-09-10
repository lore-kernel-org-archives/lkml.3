Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaIJIby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:31:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaIJIbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:31:52 -0400
Date: Wed, 10 Sep 2014 10:31:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
Message-ID: <20140910083136.GP6758@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
 <20140908185115.GI6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7SdHTC2uUYj4Zouy"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7SdHTC2uUYj4Zouy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 01:53:50PM -0400, Vince Weaver wrote:
>=20
> OK so trying to use ftrace to track this issue, and this happens (on=20
> core2, 3.17-rc4)
>=20
> [  295.992012] PANIC: double fault, error_code: 0x0
> [  295.992012] CPU: 1 PID: 2916 Comm: trace-cmd Not tainted 3.17.0-rc4+ #=
82
> [  295.992012] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.20=
12, BIOS 080015  10/19/2012
> [  295.992012] task: ffff8800cb20a800 ti: ffff8800ca30c000 task.ti: ffff8=
800ca30c000
> [  295.992012] RIP: 0010:[<ffffffff81037b92>]  [<ffffffff81037b92>] perf_=
trace_x86_exceptions+0x2d/0xb7
> [  295.992012] RSP: 0018:ffff8800bfffff58  EFLAGS: 00010082
> [  295.992012] RAX: 0000000000000001 RBX: ffff880037c9f490 RCX: 000000000=
0000000
> [  295.992012] RDX: ffff8800c0000098 RSI: ffffe8ffffc81010 RDI: ffffffff8=
1a26600
> [  295.992012] RBP: ffff8800c0000058 R08: 0000000000044ea5 R09: ffffe8fff=
fc81010
> [  295.992012] R10: 0000000000000000 R11: ffff8800ca30fc48 R12: ffff8800c=
0000098
> [  295.992012] R13: ffffe8ffffc81010 R14: 0000000000000000 R15: ffffffff8=
1a26600
> [  295.992012] FS:  00007f4217f82700(0000) GS:ffff88011fc80000(0000) knlG=
S:0000000000000000
> [  295.992012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  295.992012] CR2: ffff8800bfffff48 CR3: 00000000ca0b9000 CR4: 000000000=
00407e0
> [  295.992012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  295.992012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000600
> [  295.992012] Stack:
> [  295.992012] PANIC: double fault, error_code: 0x0
>=20

Sasha reported something from his KVM based fuzzing, maybe that's the
same. But that x86_exceptions thing is interesting, lemme go look at
that first.

--7SdHTC2uUYj4Zouy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEAxoAAoJEHZH4aRLwOS63igP/1VqB1pl/M7YEIOoI5dZUrkf
t7sLKrr4a5vDlEDe5pUxYJw4ZpHSC3lgECA4ca15ac+bc4bp2wWiJc5m0ROG9tF+
2yTe01I3VEfXw+hsExJGZhYOu2F7d59N4AjDVP9duYZ7+YzU6vZg2nBDQ1oEAAU9
1xQcj9dRk7BVLhos3S6jTxHwriP8lgvMDlAtFXcC0Zh6xKIIoIvMUkyvqI44GG9v
AzoSoeOf8GFjGXRxdTONL0jbj4LJ4/xYpisVE6tr/K7EVaHS8Q4JJEkzKkRn1ezH
9nE+hHiklz+keldmfDaQ4jMmDxYPUyKzf3eiLRHd7apx+IDlFgjMmDWKPsG60WDW
VUj82FFRvMgk94zoFNRU/3TEocWU+Cn/AilIxM9tA+tT0VtduyPFl6OChDujDQaO
s1xcZwcO0dmPIAJ69sybFGVuUG/94odANx/C9keln8OV/XPY7CVHfEn8a+j8mp0W
6ZDkwtWfpCCYStU3RVMoa4sW9r9aU0BxKc8IEU4zW91tFo5MuQioZzPEhv/qwDSt
GLGq0p33YeEKhkQAWJRWAY3+HON4zes0RsCyazM2ucHIBHRnLVM0mcnCakYxVpEW
wMVevp9V/Zvg6OZ5cD0qnxAN2nOUEwM9ZHaMn0LllcQLylur3rnuICJx+NNuS2ho
Fks0Td0/6CMbROmjdtQL
=zu8p
-----END PGP SIGNATURE-----

--7SdHTC2uUYj4Zouy--
