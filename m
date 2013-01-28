Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3A1NQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:16:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3A1NQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:16:40 -0500
Date: Mon, 28 Jan 2013 14:16:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
Message-ID: <20130128131622.GA1783@avionic-0098.mockup.avionic-design.de>
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch>
 <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch>
 <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de>
 <51063AB5.2060108@ti.com>
 <51064687.5090605@epfl.ch>
 <20130128095754.GA23134@avionic-0098.adnet.avionic-design.de>
 <510659A3.7070906@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <510659A3.7070906@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:YGripHckq90BQMnsIeDlynUDorYztPf7B3Jq9WSEO+r
 VVQt1Wi5zKegE4B6e8aPFTnX6ILUDl9VoHnAX/X9gwXBlVFbTE
 /Srjx3GODTVTGO90CuoCadNGASM+eTIbrVRF3bRfaC9dErjOc4
 nyITzAu2TDWDID9w7XX2JebOsErB5oWWZ0LUJAtPhpLHDb56sU
 hCBKASYlul1xXMEBm+ufn/Wyzin811bQRj0rWuJa3wFGqhVjP/
 /krI7NgwLa8SSh9l9suZvtz/61nO2mbeQH04X1op5O28P0suvE
 hkkHF6VzP90eI0B8Js8OI7XHofaLSR1E8MDFgJ0RDVFH5M3Ce0
 YVJgHgFfRGYeu7qpdrjd2r7kKG059fzln+oygmafRwIUsLqzyz
 OL0M0Yf6bZTu+2iOuEcUjI988wrIrcp9vA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 11:57:39AM +0100, Florian Vaussard wrote:
> Le 28/01/2013 10:57, Thierry Reding a =C3=A9crit :
> >On Mon, Jan 28, 2013 at 10:36:07AM +0100, Florian Vaussard wrote:
> >>Hello,
> >>
> >>Le 28/01/2013 09:45, Peter Ujfalusi a =C3=A9crit :
> >>>hi Thierry,
> >>>
> >>>On 01/26/2013 06:40 AM, Thierry Reding wrote:
> >[...]
> >>>>>+{
> >>>>>+	return pwm->chip->can_sleep;
> >>>>>+}
> >>>>>+EXPORT_SYMBOL_GPL(pwm_cansleep);
> >>>>
> >>>>Would it make sense to check for NULL pointers here? I guess that
> >>>>passing NULL into the function could be considered a programming error
> >>>>and an oops would be okay, but in that case there's no point in making
> >>>>the function return an int. Also see my next comment.
> >>>
> >>>While it is unlikely to happen it is better to be safe, something like=
 this
> >>>will do:
> >>>
> >>>return pwm ? pwm->chip->can_sleep : 0;
> >>>
> >>
> >>Ok. And what about:
> >>
> >>BUG_ON(pwm =3D=3D NULL);
> >>return pwm->chip->can_sleep;
> >
> >I don't think we need that. In case pwm =3D=3D NULL, dereferencing it wi=
ll
> >oops anyway. So either we make it safe and return an error code, or we
> >let it oops without explicit BUG_ON().
> >
>=20
> Calling this function with a NULL pointer is a programming error, so there
> is no error codes for such errors.

You could return -EINVAL if pwm =3D=3D NULL.

> I propose to return bool, and let it oops if such case happens.

My point was that it will oops even if you don't use BUG_ON() so there
isn't so much point in using it explicitly.

Thierry

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBnomAAoJEN0jrNd/PrOhjSwP/3mkZ2hcCdvoWIsotAFpKheD
GiC9vhXwgfcNKefZvbE9x8k55iRGnfeJwW5/vf3wJvuvVsb8EJeBBj5yj5UiBl0K
KO5KuloAuQ3qfKoVyRkTstsK1tg7SJml0EL/SFCS/k4R997z9llU8dN4ZUgS/R4/
/2Hc0ja+HCbQBF3CXl4ILqGymg2cbXjmnsbyRzm8tGZEg2QKvb0xzOvnAD5yysXc
luJMWJJYBoG5HI+qSvVrRWrhmPiJNaEjfAONu3E9HiyJXSxHOmy5BIi6jPmDi5Td
dxNeX77qhCmRm6X966cCnG0DO7iywPPgp8xYAI+p4jeRvSv7b+GUd859Lhh8hbhL
EfGelGQmzFoelZYf1XQ1V3EOpPMjGvp4/hY/Pv3d6e4K+r94xiNcIdB2FndhEsQ/
YkD5zYdLS4rhiIkOC+wt/PVbMWTgzkkdNWahHs+z4VhqMyhnu1YPLZd2aOKoZ7he
5cB7aCWC7HoMxS1tJqxJz3vqPcB4JaZdRZN98hvLid48z/THfW3xUyLvPqU5SMgy
ooXrp8rOixu2DC980fbw3p0ltr0A+hNU6nVh5HSrbFhLr3JBhGrK/KwmIRyAwzYM
ayVDI8CKVlqbjcnpA4wX8AazWGhKaQpnGZ8eJbzA0sJSTuxmF/OYbYI3U5s+yof2
zgcU9OhTW4V7iEIl/cmT
=t3/6
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
