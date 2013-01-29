Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3A2KRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:17:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2KRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:17:32 -0500
Date: Tue, 29 Jan 2013 11:17:09 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
Message-ID: <20130129101709.GC16746@avionic-0098.mockup.avionic-design.de>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
 <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com>
 <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de>
 <51078580.2000808@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <51078580.2000808@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4imGOziJ3q5RnIQVF/NtM/JyGFDy8C/Ok/A+A0oSiJ6
 VTL7On+97a3BZgXcgYO+tD2j8KrKLD+UFTHvT3JNBl/sUL/ojb
 yGrjodED6t7MC9SA3IR3RRBi+xlPJJJKi5t2IbeixB1zzlGgE4
 Dv4uh6zy2DCvCYaz6ryUPjjm+o/tRm+NJB3O0FdkfDTHLh+HPZ
 SZr7ggMNW3iuSTQZOtVxrANHa3VNiLfqlt+f9BVzRZ95570+Ul
 qrftAeppRvJNey6ytq7IeOUuuUIearYHQOHANvgO8xWoOCoEbd
 9BAQL2kyxdPZCnrVY42FFw1PaS1I4K7VUucbnzxig9tST7f9MT
 kMZYeGdx02vg1+rqe0TKOO2sMnQwJ0vooY5ZcLQpuKcFB9ft1S
 Ufv0CemRmkpjCk4gXeP5qWBS7Cxg4dF/spUlwSINkPHqRvBefW
 Iwygb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 09:17:04AM +0100, Peter Ujfalusi wrote:
> On 01/28/2013 10:01 PM, Thierry Reding wrote:
> > On Tue, Jan 22, 2013 at 02:39:53PM +0100, Peter Ujfalusi wrote:
> >> It is expected that board files would have:
> >> static unsigned int bl_levels[] =3D { 0, 50, 100, 150, 200, 250, };
> >>
> >> static struct platform_pwm_backlight_data bl_data =3D {
> >> 	.levels =3D bl_levels,
> >> 	.max_brightness =3D ARRAY_SIZE(bl_levels),
> >> 	.dft_brightness =3D 4,
> >> 	.pwm_period_ns =3D 7812500,
> >> };
> >>
> >> In this case the max_brightness would be out of range in the levels ar=
ray.
> >> Decrement the received max_brightness in every case (DT or non DT) whe=
n the
> >> levels has been provided.
> >=20
> > What's wrong with specifying .max_brightness =3D ARRAY_SIZE(bl_levels) =
- 1
> > instead?
>=20
> There is nothing wrong with that either but IMHO it is more natural for b=
oard
> files to use just ARRAY_SIZE(bl_levels). In this way the handling of
> data->max_brightness among non DT and DT booted kernel is more uniform in=
 the
> driver itself.

The .max_brightness field is defined to be the maximum value that you
can set the brightness to. If you use .levels and set .max_brightness to
ARRAY_SIZE() then that's no longer true because the maximum value for
the brightness will actually be ARRAY_SIZE() - 1.

The reason why in the DT case we decrement .max_brightness is that it is
used as a temporary variable to keep the number of levels, which
corresponds to ARRAY_SIZE() in your example, and adjust it later on to
match the definition. That's an implementation detail.

Platform data content should be encoded properly without knowledge of
the internal implementation.

> Right now all board files are using only the .max_brightness to specify t=
he
> maximum value, I could not find any users of .levels in the kernel.

Yes. But this is the legacy mode which should be considered deprecated.
The reason why the concept of brightness-levels was introduced back when
the DT bindings were created was that pretty much no hardware in
existence actually works that way. This was a topic of discussion at the
time when I first proposed these changes, see for example:

	http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg09472.h=
tml

Thierry

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRB6GlAAoJEN0jrNd/PrOhyIEP/j9x2MUN4CUNRm8rbvjvTKVy
2M+9bOlfcnKCaQEQA0+mYwa6Jlg8NhurvRqj3JZo8nt7Nm+kN91NwNcyN1kKqxew
2QBxlwg0ZjXVUuX6ZAlZPSLCFpeWyCxQOLILnXdEkQ+29ioVDb3GrXpWues7n5A3
MIhV36EdW7yMrBf2TBAUAD5jL4TERCtwa9WQ1sF24GkIpC6CuQgO+iMZIEMFchbk
PtKbA3wGs3LAxCAOrZCstQl86A6uU9b92J/3rBSoygOAJrTDxoHPUIomPxCXDPxy
q8WfE+bLJLtdBvrL1DdpanAfXTGGgRx8mRyfkiGSEYorP7gdJ1iDFakCp/IfqaBi
RRnFA6XNczgWUy4GakSfY8s4sotj5OXYxRhiIwkIbhI8oyjXTiONH4erGw+Mlomb
RWdnmaJzbVB5ceiDYtfi0OQv1VWaaJGrdi1Fp8Tprpanns29InpilSIH41mbH43v
IoEWWI1YGQQZytGdWku0WYJ0wasEII5XfPp7r4wqW30XNE90g1sRXH5Da+cEy+lG
MYWmtSDYUzOHURBC/usaKET/qU9QFUhd8YQg4YV0rnfpjr9TPfbzTkpHQAtFgaG6
NqhSuMzuwBq19KBuYZ6qFm3beTNCIRnX3N99a0HHqLb1D0PfaIAcNSRIiKGHDsp7
bcpuw5KUioVrQ2dCCfRZ
=jnXk
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
