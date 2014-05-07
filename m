Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaEGIu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:50:56 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61256 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaEGIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:50:53 -0400
Date: Wed, 7 May 2014 10:49:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>, linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: spear: fix check on pwmchip_add() return value
Message-ID: <20140507084900.GE6362@ulmo>
References: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
 <CAOh2x=mWqa=p2d1kRjf0_37DiioJZOJm3Ewv2xpMrNjPy69rvA@mail.gmail.com>
 <20140507082410.GC6362@ulmo>
 <CAKohpomkrR715dhyZZQwu_-S6LHsYBOj9YsX9HR6PCMKkMdrVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ep0oHQY+/Gbo/zt0"
Content-Disposition: inline
In-Reply-To: <CAKohpomkrR715dhyZZQwu_-S6LHsYBOj9YsX9HR6PCMKkMdrVw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 02:02:24PM +0530, Viresh Kumar wrote:
> On 7 May 2014 13:54, Thierry Reding <thierry.reding@gmail.com> wrote:
> > So the current code would run clk_unprepare() on success, but not on
> > failure. Does that cause any harm?
>=20
> Yeah, that would make the device unusable  as clk_enable will always fail.

Hmm... so ever since this driver was merged in 3.8 it was completely
broken and nobody noticed? Interesting.

> > Is the device still usable after this?
>=20
> Yes, this will fix the bug.
>=20
> > I'm asking because I'm not sure if this is linux-next material
> > or should be a fix for 3.15 (and possibly backported to stable).
>=20
> IMO, it should be sent for stable: v3.8+

Since this was obviously broken since 3.8 and nobody noticed I wonder if
there's really an urgent need for this in stable.

Thierry

--ep0oHQY+/Gbo/zt0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTafN8AAoJEN0jrNd/PrOhR1UP/iaYKosA2sQqoiLAcFLbm/v6
aaV0ZGwMVfc7oRimFrxG3TU4xWftvTZ0QlxG4S4dZZQtRBdKVL0mLjCCLGwqkGgp
oIxfir8XY8IZ1nMluFwhObyEbzwy72/Ukb6h9sPoxuiVolPEEFizXZrV0UxCC7or
yZZTfHhnhV57qk7OrvP1m4pqbk/NbQy9I0yXYz/V38JyhG61q7pwwu4U7+rg0mH0
nZv0LsZXVRKRjfVyI5LJ3uzEFVRAZqnCt8D9mpSDAM+oua1jI3F7hgXJEoltgVkU
jl/TOp7jqG4s3DBGLMLzAxb3xMHcXmx7rBCvakaHkfyaJQWsR69V+ThD317umvx9
JeTkkaI9lfWt/REG0RAn8cLELiOXqVbBkGb6x5Uua1xswKjtgqwYkks41yIUZNW5
5gqglPqJrXD0lstZ0Bc0NCee9n3aa7FdGQJyzBZLI4EF1raRb/E5r27C4t58gOaw
E+LovqbBdiNrk+Q4Ux9gxNKcEo9hYf2s3kJ/eUUHf4S8M6XllvmWnb48w7QZyAc6
8dBAxT2TgQvoTBxco6uX/Wf02kkGWOQ4DQIWn0MslmSSrneSUlQlnm1GV0TZcYgi
da3IRoj112qOj3CS+16b0WFpygfLkcDRIdIrqpZJXr5q7UtKOyeKrk2lSVXpbVXv
CYL5Jeatjn6bs8E3Qpi4
=yYEN
-----END PGP SIGNATURE-----

--ep0oHQY+/Gbo/zt0--
