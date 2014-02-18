Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbaBRQoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:44:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44218 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaBRQoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:44:00 -0500
Date: Tue, 18 Feb 2014 10:42:08 -0600
From: Felipe Balbi <balbi@ti.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christopher Covington <cov@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] usb: phy: msm: fix compilation errors when
 !CONFIG_PM_SLEEP
Message-ID: <20140218164208.GK9878@saruman.home>
Reply-To: <balbi@ti.com>
References: <87lhyemr3y.fsf@linaro.org>
 <1389981531-15539-1-git-send-email-joshc@codeaurora.org>
 <20140117182650.GZ8153@joshc.qualcomm.com>
 <20140218162407.GF9878@saruman.home>
 <20140218163321.GE31116@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iwjEIfU64POCkTAH"
Content-Disposition: inline
In-Reply-To: <20140218163321.GE31116@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iwjEIfU64POCkTAH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 10:33:21AM -0600, Josh Cartwright wrote:
> On Tue, Feb 18, 2014 at 10:24:16AM -0600, Felipe Balbi wrote:
> > On Fri, Jan 17, 2014 at 12:26:50PM -0600, Josh Cartwright wrote:
> > > On Fri, Jan 17, 2014 at 11:58:51AM -0600, Josh Cartwright wrote:
> > > > Both the PM_RUNTIME and PM_SLEEP callbacks call into the common
> > > > msm_otg_{suspend,resume} routines, however these routines are only =
being
> > > > built when CONFIG_PM_SLEEP.  In addition, msm_otg_{suspend,resume} =
also
> > > > depends on msm_hsusb_config_vddcx(), which is only built when
> > > > CONFIG_PM_SLEEP.
> > > >=20
> > > > Fix the CONFIG_PM_RUNTIME, !CONFIG_PM_SLEEP case by changing the
> > > > preprocessor conditional, and moving msm_hsusb_config_vddcx().
> > > >=20
> > > > While we're here, eliminate the CONFIG_PM conditional for setting
> > > > up the dev_pm_ops.
> > > >=20
> > > > This address the following errors Russell King has hit doing randco=
nfig
> > > > builds:
> > > >=20
> > > > drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_suspend=
':
> > > > drivers/usb/phy/phy-msm-usb.c:1691:2: error: implicit declaration o=
f function 'msm_otg_suspend'
> > > > drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_resume':
> > > > drivers/usb/phy/phy-msm-usb.c:1699:2: error: implicit declaration o=
f function 'msm_otg_resume'
> > > >=20
> > > > Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > > > ---
> > > > v1->v2: Change conditional to simply CONFIG_PM (thanks ccov and khi=
lman!)
> > > >=20
> > > >  drivers/usb/phy/phy-msm-usb.c | 57 ++++++++++++++++++++-----------=
------------
> > > >  1 file changed, 26 insertions(+), 31 deletions(-)
> > > >=20
> > > > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-ms=
m-usb.c
> > > > index 8546c8d..5b169a7 100644
> > > > --- a/drivers/usb/phy/phy-msm-usb.c
> > > > +++ b/drivers/usb/phy/phy-msm-usb.c
> > > [..]
> > > > @@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
> > > >  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
> > > >  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
> > > > =20
> > > > -#ifdef CONFIG_PM_SLEEP
> > > > +#if CONFIG_PM
> > >=20
> > > *sigh*.  This, of course, should have been #ifdef CONFIG_PM.  Fixed
> > > v3 below.
> >=20
> > sorry, please git send-email it properly.
>=20
> No problem, will do.  FWIW, it's applicable with git am --scissors.

ahaa, I didn't know about that option. Thanks :-)

--=20
balbi

--iwjEIfU64POCkTAH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTA41gAAoJEIaOsuA1yqREUkwP/jLGmitKIfE0WGLEM978/Ny9
jhJqNNStMpBSPOolxSEI2iUUCV1fj8HLMu153RTPH657kN++kyYt/GEZwRZyxODq
/VjWvCvqTyN9fkjkMi/ZkWpGrtBSxDUVeMNh9bZt26JcX5SwmnVQfW7ydGRO9oJ/
u3BL5B+dPZQHPoxc6qpT7Z29fzh66eMhPE1xZVpXk31L/z8TZ6rGoLDGd0/j1H67
KqdmWuOBD1QvYNQz6oybX95BBDj5Grk56gCuDWu3OLnyoBpuFc/bqVrpXbZJlN2X
3jftyaf9bmOw42SYc8F2V7bXYjCEo9+Mm4+76h66VLoA9vlpQk3dahfpx8VwnbbR
ElTQUT/39QqT/IfZZbCnuFO5pzYalDPWz+VCnkLuSM9MbzcvY7N8pYsB6E/NuvVH
ClKWhLfOyFphraXzbpCyvQzw8omWyDRkdn0YruJltSj86ycbEk3auGwQyP+9HhHd
Kbg8oE8AV2Mn2iYVwBQNL6GYfTftlygUxWsOGD2HaquK+gQgwF2oJNCzoD8dyctA
OwkxOgy2mbUyzH9EzvT0uUWv/ST818CSWi1yRGTwCp34AjRCeeg4r2Nldk9EEtmD
Gh7H/aZDjpbd73zD/98Li9rYfREdwFkcOcdO3v6UjGGXXhQgT0pUuAYQJu97RGUM
xFNREdOdOl7bXv8mPctt
=dOLP
-----END PGP SIGNATURE-----

--iwjEIfU64POCkTAH--
