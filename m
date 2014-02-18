Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaBRQ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:26:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbaBRQ0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:26:33 -0500
Date: Tue, 18 Feb 2014 10:24:16 -0600
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
Message-ID: <20140218162407.GF9878@saruman.home>
Reply-To: <balbi@ti.com>
References: <87lhyemr3y.fsf@linaro.org>
 <1389981531-15539-1-git-send-email-joshc@codeaurora.org>
 <20140117182650.GZ8153@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Content-Disposition: inline
In-Reply-To: <20140117182650.GZ8153@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2014 at 12:26:50PM -0600, Josh Cartwright wrote:
> On Fri, Jan 17, 2014 at 11:58:51AM -0600, Josh Cartwright wrote:
> > Both the PM_RUNTIME and PM_SLEEP callbacks call into the common
> > msm_otg_{suspend,resume} routines, however these routines are only being
> > built when CONFIG_PM_SLEEP.  In addition, msm_otg_{suspend,resume} also
> > depends on msm_hsusb_config_vddcx(), which is only built when
> > CONFIG_PM_SLEEP.
> >=20
> > Fix the CONFIG_PM_RUNTIME, !CONFIG_PM_SLEEP case by changing the
> > preprocessor conditional, and moving msm_hsusb_config_vddcx().
> >=20
> > While we're here, eliminate the CONFIG_PM conditional for setting
> > up the dev_pm_ops.
> >=20
> > This address the following errors Russell King has hit doing randconfig
> > builds:
> >=20
> > drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_suspend':
> > drivers/usb/phy/phy-msm-usb.c:1691:2: error: implicit declaration of fu=
nction 'msm_otg_suspend'
> > drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_resume':
> > drivers/usb/phy/phy-msm-usb.c:1699:2: error: implicit declaration of fu=
nction 'msm_otg_resume'
> >=20
> > Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> > v1->v2: Change conditional to simply CONFIG_PM (thanks ccov and khilman=
!)
> >=20
> >  drivers/usb/phy/phy-msm-usb.c | 57 ++++++++++++++++++++---------------=
--------
> >  1 file changed, 26 insertions(+), 31 deletions(-)
> >=20
> > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-us=
b.c
> > index 8546c8d..5b169a7 100644
> > --- a/drivers/usb/phy/phy-msm-usb.c
> > +++ b/drivers/usb/phy/phy-msm-usb.c
> [..]
> > @@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
> >  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
> >  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
> > =20
> > -#ifdef CONFIG_PM_SLEEP
> > +#if CONFIG_PM
>=20
> *sigh*.  This, of course, should have been #ifdef CONFIG_PM.  Fixed
> v3 below.

sorry, please git send-email it properly.

--=20
balbi

--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTA4kwAAoJEIaOsuA1yqREia4P/jHXuxA4HFToqwpI/6W7kJ2o
wRWRS5iY3ORtJE/UXFcTi+jRu7X4+g6Q4mO6o7LEZRxcr12lUHWxCc/Hi5lvZ3tW
L700BfTbHflYZlx3A3bFKvx1by18TeAk0vT6APqQD5gI8Y6qmOFXSiDFj0ciTHmz
M4RwE6HKJzeZ1FZrr9AskIgXWRM+2JlYVOHgGifP3ZWbKsQPXyV7+oBfek/5D3gQ
IpjjwOVbv3cbWu7YSV4oCJaTNr3l8NAHF+fLFX1j5iiKmoMVYbQdF5bx1xV4a2Sn
6sUcBLrFNAK5YxZ2Pvd+FZ4f71OktsbzGZAYKtPr0nTf+7pJ1zsiSZ2Ur1rSW3Je
Tg0aOqf2UP//sYroVw1+Um9mV0klbsGUvJjYSDCMtPcU6tOQMZskQjArlnLQOzeP
QYYCr1StWTB5ozLiuj2Qf3UK6d2aHjTwVcg2XSB1cn4I+wCWJHfYyMUEKmKTJ+EW
9t0nXYKvFm0Em83g3KcvPz382KgtEm46eaJioSQkYqpYhEWiwGwcYgYL4uRBN13R
a3R46seNmp0pu1t1Ux4LH1vEOpoLvGEnWpJcMfEHn9I+r/il2bvnRNMVSzCNqb5I
glMdDbXOQAvREHYr13f51PpyPDUQwfKv3WKt98xsitmWXqEJxcFoJhCxxlS5ZNcv
w68E70QlhsnfDgc8lvUu
=Hf/d
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
