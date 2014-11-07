Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaKGTAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:00:09 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:32856 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaKGTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:00:06 -0500
Date: Fri, 7 Nov 2014 14:59:51 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: exynos: use correct offset for TMU_CONTROL
 register on Exynos5260
Message-ID: <20141107185949.GA27266@developer>
References: <1594947.1Ri7fFnV5h@amdc1032>
 <17456984.pRSEMqiSfL@amdc1032>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <17456984.pRSEMqiSfL@amdc1032>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bartlomiej,

On Mon, Oct 20, 2014 at 02:41:07PM +0200, Bartlomiej Zolnierkiewicz wrote:
>=20
> Hi,
>=20
> Eduardo, could you please merge this patch?
>=20

I queued this in my -fixes branch. It should appear also in linux-next.

Can you please refresh your patch series
https://lkml.org/lkml/2014/9/18/305

based on my tree? Looks like something may be missing, as could not get
all patches applied cleanly.

Thanks

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>=20
> On Thursday, September 11, 2014 03:00:49 PM Bartlomiej Zolnierkiewicz wro=
te:
> > In exynos5260_tmu_registers tmu_ctrl entry is erroneously
> > assigned twice.  The second assignment (to EXYNOS_TMU_REG_CONTROL1
> > define which represents 0x24 value) overrides the first one
> > (to EXYNOS_TMU_REG_CONTROL define which represents 0x20 value)
> > which results in the wrong (according to the Exynos5260 SoC
> > documentation that I have) offset being used for TMU_CONTROL
> > register.  Fix it by removing the wrong assignment and then
> > remove no longer used EXYNOS_TMU_REG_CONTROL1 define.
> >=20
> > Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > Cc: Lukasz Majewski <l.majewski@samsung.com>
> > Cc: Eduardo Valentin <edubezval@gmail.com>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu_data.c |    1 -
> >  drivers/thermal/samsung/exynos_tmu_data.h |    1 -
> >  2 files changed, 2 deletions(-)
> >=20
> > Index: b/drivers/thermal/samsung/exynos_tmu_data.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- a/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:41:12.567=
347442 +0200
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:43:00.211=
350284 +0200
> > @@ -273,7 +273,6 @@ struct exynos_tmu_init_data const exynos
> >  static const struct exynos_tmu_registers exynos5260_tmu_registers =3D {
> >  	.triminfo_data =3D EXYNOS_TMU_REG_TRIMINFO,
> >  	.tmu_ctrl =3D EXYNOS_TMU_REG_CONTROL,
> > -	.tmu_ctrl =3D EXYNOS_TMU_REG_CONTROL1,
> >  	.therm_trip_mode_shift =3D EXYNOS_TMU_TRIP_MODE_SHIFT,
> >  	.therm_trip_mode_mask =3D EXYNOS_TMU_TRIP_MODE_MASK,
> >  	.therm_trip_en_shift =3D EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> > Index: b/drivers/thermal/samsung/exynos_tmu_data.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- a/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:41:12.243=
347433 +0200
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:43:36.167=
351233 +0200
> > @@ -83,7 +83,6 @@
> >  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> > =20
> >  /* Exynos5260 specific */
> > -#define EXYNOS_TMU_REG_CONTROL1			0x24
> >  #define EXYNOS5260_TMU_REG_INTEN		0xC0
> >  #define EXYNOS5260_TMU_REG_INTSTAT		0xC4
> >  #define EXYNOS5260_TMU_REG_INTCLEAR		0xC8

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXRaeAAoJEMLUO4d9pOJW/AgIAJUePDVsqlCXHkboVJ0SFE04
ZB04qQdWYaRIoDI/4pXB34X4eo2C/+wlF1hN2egLhiZTvyy7ykfSmvD4tcEP3hWz
yzEKuGcAAQVIvKnZAFVbRtAQN/OLEHIlKsLPANbfGbWfF8VpWE3pAN/GKsog3xwh
jV251sDYf6kam1pHceby5TXqbALq4PugLdPFym+oYR2BbGPmiPdwa+TSIR2Wn2Kh
uhZKsQoocJ7ZVQsVRW41XtRZ+UyYJ+3yyKRD+8SQUBkmcmlkrA12l7MA5b/zhm7K
9I+eo2e6viipmYRLgBkhSI6TpxrEmXXNmrCNTtAxxh0dDx+9VG6T9Mf/yv0i5Mg=
=MrCn
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
