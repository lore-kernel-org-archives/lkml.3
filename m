Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3JYPRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:17:24 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56050 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3JYPRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:17:23 -0400
Date: Fri, 25 Oct 2013 17:17:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 24
Message-ID: <20131025151717.GA3782@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
 <20131025083525.GF19622@ulmo.nvidia.com>
 <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
 <20131025133512.GA1551@ulmo.nvidia.com>
 <CAOesGMh=VLEuFgZuwrJnPsbxnr1Y528CVUdq313Ey5SVUb-jsw@mail.gmail.com>
 <20131025141707.GA27461@ulmo.nvidia.com>
 <20131025150228.GA5501@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20131025150228.GA5501@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 08:02:28AM -0700, Guenter Roeck wrote:
> On Fri, Oct 25, 2013 at 04:17:08PM +0200, Thierry Reding wrote:
> > On Fri, Oct 25, 2013 at 06:43:53AM -0700, Olof Johansson wrote:
> > > On Fri, Oct 25, 2013 at 6:35 AM, Thierry Reding
> > > <thierry.reding@gmail.com> wrote:
> > > > On Fri, Oct 25, 2013 at 06:16:02AM -0700, Olof Johansson wrote:
> > > >> On Fri, Oct 25, 2013 at 1:35 AM, Thierry Reding
> > > >> <thierry.reding@gmail.com> wrote:
> > > >> > On Thu, Oct 24, 2013 at 10:02:22PM -0700, Guenter Roeck wrote:
> > > >> >> On 10/24/2013 09:31 AM, Thierry Reding wrote:
> > > >> >> >Hi all,
> > > >> >> >
> > > >> >> >I've uploaded today's linux-next tree to the master branch of =
the
> > > >> >> >repository below:
> > > >> >> >
> > > >> >> >         git://gitorious.org/thierryreding/linux-next.git
> > > >> >> >
> > > >> >> >A next-20131024 tag is also provided for convenience.
> > > >> >> >
> > > >> >> >Quite a few new conflicts. Some of them non-trivial. I've fixe=
d another
> > > >> >> >set of build failures, so 32-bit and 64-bit allmodconfigs buil=
d fine on
> > > >> >> >x86. ARM and x86 default configurations also build fine. Power=
PC is in
> > > >> >> >pretty bad shape, mostly due to some OF header rework going on.
> > > >> >> >
> > > >> >>
> > > >> >> Hmm ... I see
> > > >> >>
> > > >> >> Building arm:defconfig ... failed
> > > >> >> --------------
> > > >> >> Error log:
> > > >> >> drivers/built-in.o: In function `mmc_gpio_request_cd':
> > > >> >> clkdev.c:(.text+0x74cf8): undefined reference to `devm_gpio_req=
uest_one'
> > > >> >> make: *** [vmlinux] Error 1
> > > >> >>
> > > >> >> Otherwise pretty much the same as yesterday, with a build log of
> > > >> >>       total: 110 pass: 88 skipped: 4 fail: 18
> > > >> >>
> > > >> >> This is with "v3.12-rc5-7941-g765f88c".
> > > >> >
> > > >> > Yeah, I saw the devm_gpio_request_one() errors too. They happene=
d for 3
> > > >> > boards on ARM I think. Must have forgotten to update the summary=
 email.
> > > >> > I'll see if I can come up with a patch to fix the GPIO related b=
uild
> > > >> > failures, or at least report it to LinusW or Alexandre.
> > > >>
> > > >> Hmm.
> > > >>
> > > >> Please don't apply fixes like these directly to your tree, keep the
> > > >> broken parts (or drop the tree that introduced it). It makes the
> > > >> process of getting the fixes in where they really have to go much =
more
> > > >> error prone, since there's no way to track whether they have lande=
d in
> > > >> the right place yet or not.
> > > >
> > > > I've found that fixing one build error often subsequent build failu=
res,
> > > > which would go unnoticed if I dropped the trees or let the breakage
> > > > unfixed.
> > >=20
> > > Yeah, that's what happened with the GPIO subsystem on this release --
> > > there are two build errors but your fix resolves one of them such at
> > > the other one is exposed. It makes it confusing to bisect down to root
> > > cause. I'd almost rather have your tree just being broken, but patches
> > > submitted and sent in to the maintainer in question if you want to get
> > > it fixed ASAP.
> >=20
> > I guess I could probably just push the final merge commit as a tree, but
> > it would require me to very strongly resist my compulsive urge not to
> > push something that doesn't even build.
> >=20
> "Doesn't even build" is relative, though. After all, there still _are_
> 18 build failures out of 106 in my test builds alone. Where do you draw
> the line ? arm failures are bad, who cares about blackfin ?

Well, I've been doing x86, ARM and PowerPC builds and of those only 3
are failing and I didn't fix them because I didn't really know how to.
But you're right, I guess one has to draw the line somewhere, and if
people prefer the tree to just be broken rather than with odd fixes on
top, then that's the way it going to be.

For now I've settled on pushing a branch which has only the fixes that
are required to make the trees work happily together and a separate tag
which has the patches that unbreak subsystem trees.

The reason I usually want linux-next to build is because I know that
various people rely on it for their daily work, so my reasoning was that
if I fix it before they even start using it, then they get to spend
their time with something more useful and only one person ends up fixing
the build issues instead of everyone.

Thierry

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaot9AAoJEN0jrNd/PrOhXxUP+wYINo/D+RMaaVYZmPHvzSLD
DRA/jA0ygYQFYsgCyOMY9DwbVls9DHRmb8sAiEnC7+mmIq3M8Lu162oCuP+IVas4
fgJDjGoFTxJy64L6gMmMT1uH0Uj13y2rxe0VLUtXSao7cOcfW7goTbLW23XEqXvK
xqDk/H/nS48YyQ3e5pyVdRnjvEAdx+EoDIquUlx5xmAZHovRnCeAq7wtGHFKopPF
kFvSwqAiJ30b5x9W9n7GEfRzHypQU17ns93p2KFN428Jq4BGQt8x+3iGUOcA9ElY
6ECuqExuRXjQ1CSnqdJ632YaHJo34J2uWGYDnWtC9f0ROywbnrF0ftnPevmtM8Ie
7XnYR6eCBbSq4O27KzEQSoOaNW9bNx0Rz9J/cWfegDl6F3WHZwN37Cfev5PLLC2t
H665AOCj5U+shVt/SLZn+UL51PUGGffN6jdWuJFeEZCJH4tNiuBzOewTsTSOATBQ
4U9zGwXoLUGYpXtaw4E0Mr4laOT+JheUWTjljRabS5a5keP2qYMU+qgPY9UgNnS6
hVk6IK4KPF48jlQrwTAN8KjfdOsMEqzbxZLtvY87M1Ttex4uXO2hdIVMl6vVRcmF
V1mZZEgqb1YsfloFvjAZqNL4dibi/kpwyaWbQLXmdjjsyqrD11OgPGyKg1ZZJyno
mWLtc/eY0E9OiGiHB+0Q
=ItAo
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
