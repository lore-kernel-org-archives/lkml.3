Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbaG1QjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:39:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:59853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1QjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:39:21 -0400
Date: Mon, 28 Jul 2014 18:39:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josef Bacik <jbacik@fb.com>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] x86: don't check numa topology when setting up
 core siblings
Message-ID: <20140728163909.GR19379@twins.programming.kicks-ass.net>
References: <1406564919-19283-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OP15NvPAkMzpGMnr"
Content-Disposition: inline
In-Reply-To: <1406564919-19283-1-git-send-email-jbacik@fb.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OP15NvPAkMzpGMnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 12:28:39PM -0400, Josef Bacik wrote:
> We have these processors with this Cluster on die feature which shares nu=
ma
> nodes between cores on different sockets.

Uhm, what?! I know AMD has chips that have two nodes per package, but
what you say doesn't make sense.

> When booting up we were getting this
> error with COD enabled (this is a 4 socket 12 core per CPU box)
>=20
>  smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
>  ------------[ cut here ]------------
>  WARNING: at arch/x86/kernel/smpboot.c:324 topology_sane.isra.2+0x6f/0x82=
()
>  sched: CPU #6's mc-sibling CPU #0 is not on the same node! [node: 1 !=3D=
 0]. Ignoring dependency.
>  smpboot: Booting Node   1, Processors  #6
>  Modules linked in:
>  CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.10.39-31_fbk12_01013_ga2de9b=
f #1
>  Hardware name: Quanta Leopard-DDR3/Leopard-DDR3, BIOS F06_3A03.08 05/24/=
2014
>   ffffffff810971d4 ffff8802748d3e48 0000000000000009 ffff8802748d3df8
>   ffffffff815bba59 ffff8802748d3e38 ffffffff8103b02b ffff8802748d3e28
>   0000000000000001 000000000000b010 0000000000012580 0000000000000000
>  Call Trace:
>   [<ffffffff810971d4>] ? print_modules+0x54/0xa0
>   [<ffffffff815bba59>] dump_stack+0x19/0x1b
>   [<ffffffff8103b02b>] warn_slowpath_common+0x6b/0xa0
>   [<ffffffff8103b101>] warn_slowpath_fmt+0x41/0x50
>   [<ffffffff815ada56>] topology_sane.isra.2+0x6f/0x82
>   [<ffffffff815ade23>] set_cpu_sibling_map+0x380/0x42c
>   [<ffffffff815adfe7>] start_secondary+0x118/0x19a
>  ---[ end trace 755dbfb52f761180 ]---
>   #7 #8 #9 #10 #11 OK
>=20
> and then the /proc/cpuinfo would show "cores: 6" instead of "cores: 12" b=
ecause
> the sibling map doesn't get set right.=20

Yeah, looks like your topology setup is wrecked alright.

> This patch fixes this.=20

No, as you say, this patch just makes the warning go away, you still
have a royally fucked topology setup.

> Now I realize
> this is probably not the correct fix but I'm an FS guy and I don't unders=
tand
> this stuff.

:-)

> Looking at the cpuflags with COD on and off there appears to be no
> difference.  The only difference I can spot is with it on we have 4 numa =
nodes
> and with it off we have 2, but that seems like a flakey check at best to =
add.
> I'm open to suggestions on how to fix this properly.  Thanks,

Got a link that explains this COD nonsense?

Google gets me something about Intel SSSC, but nothing that explains
your BIOS? knob.

I suspect your BIOS is buggy and doesn't properly modify the CPUID
topology data.


--OP15NvPAkMzpGMnr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1nytAAoJEHZH4aRLwOS6gEcP/2hsiq5+438dOYedajzRwLBv
+oELK+MvzEdXXvF1OoBaP/VNG53/wW7keFrICDbAfyxgjPToHSJXZLOA8fNz5ftJ
GTUcCsmT/r2HKNt4BzrZSm5Oc8uRkrcDCTtxlJ1kPQ+T64rXBjTdRXhCsNPEgp/O
N5Bv7vy84IUgUVPstOusXLeBmd5npMSui0oM1tdh8NCrtByhVFwY9imVhgqXzhyq
NEfpokz530d3otzKVgDL+lftfBq2bgnJWwqInL2R+idva2q9mB+jCPnHoauK/aT3
QNMbSzz3TCfen4g3mdolY25hqTk4YXmIPN+JfbKjPXDdzNnBhbkw+x3CwNXuyy/r
a9m4oNxG/HBYsKSCHvtz7EIsa/S/0QSEPw3+oKIIsco8mCAoq/AiRcqCk7RXCNhc
ZywPiZrwAkxgKExyU47WRcYINsucFAOoReHfUYg1tMHrQ35mafqCU4kUQovH6Ala
LKyMSyXdc1jrDhOUgCM201Wq56tw+7B5GHCLiZ1lRwjqJLMe1eyEWwu+pL+qWDmf
ufhu4tciNuCPwAoXYpevSl2SyUq+eV7C6OEskgrUmcFSu/JX5RPGMHlo9jqkg383
Uno5jcbifuMPxw6UaReMm9l4KEt6i7Zu0BK/ZNJmIZ4GEZixrvm+HCvcNU4uqy01
6g3ddyLcxPnQhyIzf3LY
=w9Ig
-----END PGP SIGNATURE-----

--OP15NvPAkMzpGMnr--
