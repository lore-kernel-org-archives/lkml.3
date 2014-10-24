Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaJXUSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:18:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60049 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaJXUSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:18:50 -0400
Date: Fri, 24 Oct 2014 15:18:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <airlied@linux.ie>, <robdclark@gmail.com>, <davidb@codeaurora.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
Message-ID: <20141024201827.GJ11455@saruman>
Reply-To: <balbi@ti.com>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
 <20141024201138.GL3729@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ArrI7P/b+va1vZ8"
Content-Disposition: inline
In-Reply-To: <20141024201138.GL3729@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7ArrI7P/b+va1vZ8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 24, 2014 at 09:11:38PM +0100, Mark Brown wrote:
> On Fri, Oct 24, 2014 at 02:15:11PM -0500, Felipe Balbi wrote:
> > If we don't stup that call out, we will have
> > build failures for any drivers using that function
> > when .config happens to have CONFIG_REGULATOR=3Dn.
> >=20
> > One such case below, found with randconfig
> >=20
> > drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c: In function =E2=80=98mdp4_kms_=
init=E2=80=99:
> > drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:2: error: implicit declarat=
ion \
>=20
> As previously and repeatedly reported the regulator usage in this driver
> appears extremely problematic, among these problems is that it almost
> certainly has no sensible reason to be using regulator_get_exclusive()
> or any variant of it.  Sadly every time it's been raised with the video
> people they've completely ignored the mail so here we are.
>=20
> Right now not having the stub seems to only be affecting buggy users
> (which given the use cases for _exclusive() isn't *that* surprising) so
> I'm more inclined to leave this there in the hope that the users get
> fixed or we can at least get some sort of dialogue with the relevant
> maintainers.

quite frankly, flawed or not, I still think it's wrong of regulator
framework to cause a build break during randconfig. Pretty much every
other call is stubbed out, why wouldn't this be ? Moreover, if nobody
cared to this day, why would this randconfig build break change their
minds ?

Not that I really care, it's just yet another build break I need to
ignore when build-testing. Whatever.

--=20
balbi

--7ArrI7P/b+va1vZ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSrQTAAoJEIaOsuA1yqREgBsQAJ/4+NhfNlLHLFtoTQBzYnRa
xee/2+fHUCp8xsqrU/U2oALQm19LPf806+w4uYNRnrCP+OzRwL/y/0behnKzdEo6
f/aleLyjatm2qB0QrzW7YVINqAPfHNeeUZQd8bsqVMKN0OMsQYgKzNlyz636YEML
2E+7J/uMgTio3+qxLFHguteg3Ss8F4jU8G7Y72X+Lj5czdwBKBbCOw1833DHneyG
adKLiiuvD+GECo2fBElIjlTUKJsJmCoN1B2Ez7NMyzLLjxJ06h5+oIDNQxjYFRD1
OoRnVzTD9de6eYZCiS1zZkNY3ULFAiyIj5npIfZIrHk74Wvrv6MVOe9jb/U9fZjm
KMgHu8vGx94NGLMT7VWcrEl6dPzpi8kTwSTuJHGnncYzsBqBRpOh0Cpp2X0BZ7g7
Q5JMpq0rWZuwLrIecpltoZANqbUKXydN5e7TkKhVaETB1bgImKyrCBPMQ/wsEAYz
Fl8PTe4uHZNPHMwuXa7E+CvCCw8oZC+LL8XqbkDSkyMVvoj+k4tbBbDHlKH8Onsv
t1V1bx036v/Quu7I1A+LwNIXMCJPn4p/3GTai2LjWIK8C4T4Y9crNtK6VgcaMUFF
LDgMR33Jt/yRysaM9cbVaXJQJDl0t69eYmBuSlI8aha0I5Q5mYC9BmLOjrQ9toZm
sVmmELkWsZlGYgbPiRI7
=8lal
-----END PGP SIGNATURE-----

--7ArrI7P/b+va1vZ8--
