Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3JYORP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:17:15 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51914 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3JYORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:17:11 -0400
Date: Fri, 25 Oct 2013 16:17:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 24
Message-ID: <20131025141707.GA27461@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
 <20131025083525.GF19622@ulmo.nvidia.com>
 <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
 <20131025133512.GA1551@ulmo.nvidia.com>
 <CAOesGMh=VLEuFgZuwrJnPsbxnr1Y528CVUdq313Ey5SVUb-jsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <CAOesGMh=VLEuFgZuwrJnPsbxnr1Y528CVUdq313Ey5SVUb-jsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 06:43:53AM -0700, Olof Johansson wrote:
> On Fri, Oct 25, 2013 at 6:35 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Fri, Oct 25, 2013 at 06:16:02AM -0700, Olof Johansson wrote:
> >> On Fri, Oct 25, 2013 at 1:35 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > On Thu, Oct 24, 2013 at 10:02:22PM -0700, Guenter Roeck wrote:
> >> >> On 10/24/2013 09:31 AM, Thierry Reding wrote:
> >> >> >Hi all,
> >> >> >
> >> >> >I've uploaded today's linux-next tree to the master branch of the
> >> >> >repository below:
> >> >> >
> >> >> >         git://gitorious.org/thierryreding/linux-next.git
> >> >> >
> >> >> >A next-20131024 tag is also provided for convenience.
> >> >> >
> >> >> >Quite a few new conflicts. Some of them non-trivial. I've fixed an=
other
> >> >> >set of build failures, so 32-bit and 64-bit allmodconfigs build fi=
ne on
> >> >> >x86. ARM and x86 default configurations also build fine. PowerPC i=
s in
> >> >> >pretty bad shape, mostly due to some OF header rework going on.
> >> >> >
> >> >>
> >> >> Hmm ... I see
> >> >>
> >> >> Building arm:defconfig ... failed
> >> >> --------------
> >> >> Error log:
> >> >> drivers/built-in.o: In function `mmc_gpio_request_cd':
> >> >> clkdev.c:(.text+0x74cf8): undefined reference to `devm_gpio_request=
_one'
> >> >> make: *** [vmlinux] Error 1
> >> >>
> >> >> Otherwise pretty much the same as yesterday, with a build log of
> >> >>       total: 110 pass: 88 skipped: 4 fail: 18
> >> >>
> >> >> This is with "v3.12-rc5-7941-g765f88c".
> >> >
> >> > Yeah, I saw the devm_gpio_request_one() errors too. They happened fo=
r 3
> >> > boards on ARM I think. Must have forgotten to update the summary ema=
il.
> >> > I'll see if I can come up with a patch to fix the GPIO related build
> >> > failures, or at least report it to LinusW or Alexandre.
> >>
> >> Hmm.
> >>
> >> Please don't apply fixes like these directly to your tree, keep the
> >> broken parts (or drop the tree that introduced it). It makes the
> >> process of getting the fixes in where they really have to go much more
> >> error prone, since there's no way to track whether they have landed in
> >> the right place yet or not.
> >
> > I've found that fixing one build error often subsequent build failures,
> > which would go unnoticed if I dropped the trees or let the breakage
> > unfixed.
>=20
> Yeah, that's what happened with the GPIO subsystem on this release --
> there are two build errors but your fix resolves one of them such at
> the other one is exposed. It makes it confusing to bisect down to root
> cause. I'd almost rather have your tree just being broken, but patches
> submitted and sent in to the maintainer in question if you want to get
> it fixed ASAP.

I guess I could probably just push the final merge commit as a tree, but
it would require me to very strongly resist my compulsive urge not to
push something that doesn't even build.

I suppose if we could write that down into some kind of rule I could go
look at it until the compulsiveness wears down... =3D)

> In particular, the gpio fix in the tree right now has no description, etc.

Yes, I know. FWIW I fixed that up properly in today's tree, which I'm
almost ready to push out.

Thierry

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSan1jAAoJEN0jrNd/PrOhqEwQAJDHlMYZLkDz87vb6IrulKw6
IJpIN73ekc++aErQ24o2qZSM9YCSK43LmdGjMab++HTxTpYV7entEJMuDcJbRsGS
yKYTj1chzuadWz1LU4H+GVO5Om/cBugWn33r6Je01ZMB+3Yp6WecZPYaKU1/9tfo
pROztpNnZIRoDT/g+W5EUDCAyU4AZgcaK7P8OJGYIMccMHRUzgvyDSuiL+kLIbGi
EwaCezUE1RTxddo7W4cn5wKnAtaYd2PF54kuuMC3i6gM4M4ahUVX66POLW/pweyB
XtbiWSakRYbGqOmz/uzKHaDLcnE1yvNAx5lxg8ZVYXmbqQhnMu/956msvy5ZPjJ8
08vv0svNG6hWRao50gA6/f/SizeeqILadezLhWIw/r6vSdZERlyTQKJYbGgP/TJm
sV++t7prdE0JFoJwkQVhXLI2h/9H1FAJpWjLKdSjCtVpHvW08qFm0KzJoCU6e0Du
UWcUSF6SsqypKev6vEWNMW8QoU43wAq2MNu+nMV/WBjBjdG0hE+ZhEcxtDoapeOM
SAKkekRX8ZfQcIQh/eoJA4cRiFU0oFnZAxyvjpuSV92s6vLLtFTZkftw5nsvjoSx
qfVcI3jv70ye66pjnkga+BBtiCxDHsIIybsvI9J1Jy7OBqqKQHAtgV2xVIoNGt3n
xUGC8OHkaUcVIWF7IUiZ
=I+3l
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
