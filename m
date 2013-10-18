Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3JRIZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:25:06 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52158 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3JRIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:24:59 -0400
Date: Fri, 18 Oct 2013 10:22:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@linaro.org
Subject: Re: linux-next: Tree for Oct 17
Message-ID: <20131018082236.GA25694@ulmo.nvidia.com>
References: <20131018003847.GH2443@sirena.org.uk>
 <20131018074526.GA30578@quad.lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20131018074526.GA30578@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 12:45:26AM -0700, Olof Johansson wrote:
> On Fri, Oct 18, 2013 at 01:38:47AM +0100, Mark Brown wrote:
> > Hi all,
> >=20
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> >=20
> >         git://gitorious.org/thierryreding/linux-next.git >=20
> > A next-20131017 tag is also provided for convenience.
> >=20
> > One new conflict today but otherwise uneventful.  x86_64 allmodconfigs
> > build after each merge but no other build tests were done.
>=20
> Hi,
>=20
> I'm seeing a fairly large fallout on boot testing. See
> http://lists.linaro.org/pipermail/kernel-build-reports/2013-October/00071=
9.html
> for full list (I need to start providing longer backlogs for failures, th=
e top
> of the oopses is lost in the email).
>=20
> For example, on dove (SolidRun Cubox) I see:
>=20
> [    0.707248] Unable to handle kernel NULL pointer dereference at virtua=
l address 00000054
> [    0.715297] pgd =3D c0004000
> [    0.717984] [00000054] *pgd=3D00000000
> [    0.721548] Internal error: Oops: 5 [#1] ARM
> [    0.725794] Modules linked in:
> [    0.728841] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc5-next-20=
131017 #1
> [    0.736114] task: ef035c00 ti: ef036000 task.ti: ef036000
> [    0.741497] PC is at kfree+0x54/0xc4
> [    0.745063] LR is at ata_host_register+0x3c/0x290
> [    0.749741] pc : [<c008ad28>]    lr : [<c023e168>]    psr: 40000193
> [    0.749741] sp : ef037da8  ip : 00000034  fp : 00000000
> [    0.761159] r10: 00000000  r9 : ef061810  r8 : c0519fc8
> [    0.766353] r7 : c0519fc8  r6 : a0000113  r5 : ffffffff  r4 : ef1c9dd0
> [    0.772850] r3 : c0fc8fe0  r2 : c07c9000  r1 : 40000000  r0 : 00000000
> [    0.779349] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segm=
ent kernel
> [    0.786708] Control: 10c5387d  Table: 00004019  DAC: 00000015
> [    0.792428] Process swapper (pid: 1, stack limit =3D 0xef036248)
> [    0.798234] Stack: (0xef037da8 to 0xef038000)
> [    0.957218] [<c008ad28>] (kfree+0x54/0xc4) from [<c023e168>] (ata_host=
_register+0x3c/0x290)
> [    0.965542] [<c023e168>] (ata_host_register+0x3c/0x290) from [<c023e49=
8>] (ata_host_activate+0xdc/0x118)
> [    0.974992] [<c023e498>] (ata_host_activate+0xdc/0x118) from [<c025113=
0>] (mv_platform_probe+0x2dc/0x36c)
> [    0.984527] [<c0251130>] (mv_platform_probe+0x2dc/0x36c) from [<c021b6=
c4>] (platform_drv_probe+0x18/0x48)
> [    0.994051] [<c021b6c4>] (platform_drv_probe+0x18/0x48) from [<c0219e8=
8>] (really_probe+0x74/0x1fc)
> [    1.003062] [<c0219e88>] (really_probe+0x74/0x1fc) from [<c021a0fc>] (=
__driver_attach+0x98/0x9c)
> [    1.011804] [<c021a0fc>] (__driver_attach+0x98/0x9c) from [<c02186cc>]=
 (bus_for_each_dev+0x60/0x94)
> [    1.020808] [<c02186cc>] (bus_for_each_dev+0x60/0x94) from [<c0219728>=
] (bus_add_driver+0x148/0x1f0)
> [    1.029898] [<c0219728>] (bus_add_driver+0x148/0x1f0) from [<c021a700>=
] (driver_register+0x78/0xf8)
> [    1.038911] [<c021a700>] (driver_register+0x78/0xf8) from [<c04e2ed0>]=
 (mv_init+0x30/0x50)
> [    1.047144] [<c04e2ed0>] (mv_init+0x30/0x50) from [<c000877c>] (do_one=
_initcall+0x100/0x14c)
> [    1.055557] [<c000877c>] (do_one_initcall+0x100/0x14c) from [<c04cead4=
>] (kernel_init_freeable+0x120/0x1c0)
> [    1.065259] [<c04cead4>] (kernel_init_freeable+0x120/0x1c0) from [<c03=
8fe30>] (kernel_init+0x8/0x158)
> [    1.074441] [<c038fe30>] (kernel_init+0x8/0x158) from [<c000e0b8>] (re=
t_from_fork+0x14/0x3c)
> [    1.082841] Code: e0823283 e3110902 1593301c e593001c (e5904054)
>=20
>=20
> I bisected it down to commit 55acc602faae7c10e53acdca0c70f4936c2539c6, wh=
ich
> is really weird. That is:
>=20
> commit 55acc602faae7c10e53acdca0c70f4936c2539c6
> Merge: e32face ba6857b
> Author:     Mark Brown <broonie@linaro.org>
> AuthorDate: Thu Oct 17 23:55:55 2013 +0100
> Commit:     Mark Brown <broonie@linaro.org>
> CommitDate: Thu Oct 17 23:55:55 2013 +0100
>=20
>     Merge remote-tracking branch 'driver-core/driver-core-next'
>    =20
>     Conflicts:
>         include/linux/netdevice.h
>=20
>=20
> But there isn't anything controversial in the merge commit.
>=20
> I tried checking out either side of that merge, and they both boot
> fine. I redid the merge myself, and I get no delta compared to your
> merge and I still get the same failure.
>=20
> I've got more failures than dove, I'll try bisecting a few of the others
> in the morning (it's late here), hopefully they will help indicate what's
> actually going wrong. I'm guessing something just happens to move around
> enough to expose a different problem once the two branches are merged.

Looking at that oops it seems like host is actually NULL when kfree() is
called in ata_host_register(). That seems to only happen when freeing up
any of the unused ports, which is strange in itself because Cubox seems
to only register a single one. Also if host is indeed NULL, then things
should go haywire much sooner.

Looks like you won't easily find out what's going on here unless you get
into it somewhat deeper and perhaps trace what exactly fails and why the
NULL pointer is even there in the first place.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYO/MAAoJEN0jrNd/PrOhG4gQAI7CYAgF33ClhA/feXohRZp2
aYz0pyggcGkr3N4vY8TKiiUuPhElU6LfNgio7aK79LSxipca52X6aCSMFFoavcgD
viN0lybCiZpOwvxHV9dD0ePFdLW2zA/cYYWaMimfqIvHHG9O2E6UYNy3WM2cj322
hps1uoRbS0gMCfOSIhRwB0gckWKFaYN3s3Wour863BIqVxxmzzirz1u4ET4LBtw6
RhhgpKTuZ9t61kr6rgKxbbk2joInVGUXuOc7cuPnrWyYNCuYg2Yz6F8G5iOSeMgn
qPlUGNBqq8Md/rfwKqOFBxoYb+l7eQfDhn9s1beZTNiwk72Grg6UKr7e7jTetE8N
4791EQ3R7ypbXT6fKoddjOo7GP7Wdot0dF/edvFfICS3Azt/9q5FZwN+Qse0UjW6
D3O+inD9lBsv5CktKJa3dsGyidzxStUEGAgpIqjj26G+dM3UnpfBzrRqOy85uo7Y
Ao2gXz1n/XtNmi7ZhPWJBB1KY5MN9WQ5bq3lOTwo74oPJ5X7eafwc7W2MtSRGAgA
cVEWH+IwdsFbhBowG/EfZmdNDkEywrZwJ9kMnha7dpILyodPWRNmFXjuG7n8jmFO
tk0I6489/KpJk+GehhjMJ3cznvKZgiJEWT5pXLKvNrqraZiqfWIMLqyqOoqWxOaU
wwgf/3mrNH0UdyylDZzQ
=Cejq
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
