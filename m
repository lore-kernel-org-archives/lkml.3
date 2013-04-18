Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759Ab3DRNGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:06:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45099 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab3DRNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:06:42 -0400
Date: Thu, 18 Apr 2013 16:06:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] driver: serial: omap: add prepare/complete callback
 for "no_console_suspend" case
Message-ID: <20130418130605.GC23120@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
 <1366198467-6757-4-git-send-email-sourav.poddar@ti.com>
 <20130418035801.GB18349@arwen.pp.htv.fi>
 <516FE214.6010008@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <516FE214.6010008@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 18, 2013 at 05:37:48PM +0530, Sourav Poddar wrote:
> Hi Felipe,
> On Thursday 18 April 2013 09:28 AM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Apr 17, 2013 at 05:04:24PM +0530, Sourav Poddar wrote:
> >>@@ -1632,6 +1650,8 @@ static const struct dev_pm_ops serial_omap_dev_pm=
_ops =3D {
> >>  	SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
> >>  	SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
> >>  				serial_omap_runtime_resume, NULL)
> >>+	.prepare        =3D serial_omap_prepare,
> >>+	.complete       =3D serial_omap_complete,
> >if CONFIG_PM_SLEEP isn't defined, this will break compilation.
> >
> True.
>=20
> Then, will it not be  a better idea to add a similar macro[1] in
> include/linux/pm.h for
> prepare/complete callback as it is present for suspend/resume ?.
>=20
> [1]:
> #ifdef CONFIG_PM_SLEEP
> #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
>         .suspend =3D suspend_fn, \
>         .resume =3D resume_fn, \
>         .freeze =3D suspend_fn, \
>         .thaw =3D resume_fn, \
>         .poweroff =3D suspend_fn, \
>         .restore =3D resume_fn,
> #else
> #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
> #endif

might be :-)

--=20
balbi

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRb++9AAoJEIaOsuA1yqREgNwQAKuUl9/lwD2aFQsx8cvwWJVt
NUpZf8yCsgmIeMj+ZdcyI2HAxgUqSY2g6HxCfaYGHzDvCu6Rp/S6XMP9yxY888Wo
NU7ed672g4+LJIqM2DStrUDwbo1Sunxng3M4DwQOJWRpVs4DXJ8gx3/gzVFFAqCA
9a/FCm7YAfl9H7Brbr1jxNIYtc1KSzKD/kF2grUaUCTqzwsa1iJB/B2FD4sFRShz
zFpSF4IMRyJanPZEOIPwN6nD18+Ao+Yi6z+ylDk5AbyX16+iLu0fNFL+SpUk5wg0
W9gJg+JNLGoNJHQXWkHrYyFeU0xqB96Y+S6LrLapIcu9euiBBVmI4t7Rf41qsF5N
gavAmCVuFLdlFoQ4U311EmB85n9jyzXfdCrwmlk3zw1wh8CAMpEzpG3cqjRi7tnB
dTB8ZlCKOMS1yKN3Q87UFXxkL292NLCpomUPt6ZpkVSsTLdgehOZW6xnx6HgF1zo
zEEnOEwVoRsxHR9zZYAsEG/8CZ+V0z2ulxVS2ycXY625EOlenXZrbLeiWCL6H7qs
asKNIJTf/iLkZ5Yr/VR47otycmKxy2MQULPR/JzRi9Dkedb0YPBzHr6jnkIKavPj
5TMFZj8393dF93P8AaDaQvOcjKpIn8AgoWqdPRgQMiFZ78N5LMAYSKS9vdr45ys0
IP6TB66hALVo1AeMWn3y
=0QMA
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
