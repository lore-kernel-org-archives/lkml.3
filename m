Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbbAET5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:57:52 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61515 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbAET5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:57:50 -0500
Date: Sat, 3 Jan 2015 21:00:53 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
Cc: Anson Huang <b20788@freescale.com>, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rui.zhang@intel.com
Subject: Re: [PATCH] Thermal: imx: add clk disable/enable for suspend/resume
Message-ID: <20150104010051.GA26438@developer>
References: <1420468153-19142-1-git-send-email-b20788@freescale.com>
 <CADTbHxpExF7Qzz9-HCVWWbU24ymBV1wLt4ON_6avY_oLkknFaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <CADTbHxpExF7Qzz9-HCVWWbU24ymBV1wLt4ON_6avY_oLkknFaQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Jan 05, 2015 at 10:34:11PM +0530, Pankaj Jangra wrote:
> Hi Anson,
>=20
> On Mon, Jan 5, 2015 at 7:59 PM, Anson Huang <b20788@freescale.com> wrote:
>=20
> > Thermal sensor's clk is from pll3_usb_otg, per hardware
> > design requirement, need to make sure pll3_usb_otg is disabled
> > before STOP mode is entered, otherwise, all PFDs under it may
> > enter incorrect state, this patch disables pll3_usb_otg before
> > suspend and enables it after resume.
> >
> > Signed-off-by: Anson Huang <b20788@freescale.com>
> >
> > +++ b/drivers/thermal/imx_thermal.c
> > @@ -600,6 +600,8 @@ static int imx_thermal_suspend(struct device *dev)
> >         regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP=
);
> >         regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
> >         data->mode =3D THERMAL_DEVICE_DISABLED;
> > +       if (!IS_ERR(data->thermal_clk))
> >
> I think you do not need to check for the error condition here. Because
> during the probe of driver, this condition is already checked and if the
> clock get is failed,
> it will fail the driver probing itself.
>=20

Agreed here, no need for this extra check.

> +               clk_disable_unprepare(data->thermal_clk);
>=20
>=20
> >         return 0;
> >  }
> > @@ -609,6 +611,8 @@ static int imx_thermal_resume(struct device *dev)
> >         struct imx_thermal_data *data =3D dev_get_drvdata(dev);
> >         struct regmap *map =3D data->tempmon;
> >
> > +       if (!IS_ERR(data->thermal_clk))
> >
> Same as above.
>=20
> > +               clk_prepare_enable(data->thermal_clk);
> >         /* Enabled thermal sensor after resume */
> >         regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
> >         regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP=
);
> > --
> >
>=20
> Else changes looks good to me.
>=20
> -- Pankaj Jangra
>=20
> > 1.9.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqJC6AAoJEMLUO4d9pOJW0UoIAIQl8dL45l3dijE6jZaQPpqt
4V2M9iYDzsE4cBg49Fmk+Y3nSDO6Vjn5eleOxgKIQNNnAdNuCZxWJyOXwQrOvsr1
x4UPyI+9n/iMoQPtmnL5kMBOTNmymeoctW4m6w9M06gInIXk8dksi8YwThylFle3
587BF2cFFo9RY6J2dnd2k2+1t2HTVV44kT7OtWkMbmIrIxqSma0VRdLhtAOoa+sg
GYYf13vS9CQZIvM+GpuooMIphwBfYnFTxtvUM25o8HygztOw1DPtCQRsNflaSDgX
bZEQZ6h0UM++ltAvl4DM+EhnOVWDvHFke2RKoxnI7rp5umU9s8zJoOsbLZ/EJ3I=
=WRjH
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
