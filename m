Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaILUVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:21:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40708 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaILUU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:20:57 -0400
Date: Fri, 12 Sep 2014 15:20:08 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pramod Gurav <pramod.gurav.etc@gmail.com>
CC: Andy Gross <agross@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 2/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20140912202008.GB25500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org>
 <1410550088-8754-3-git-send-email-agross@codeaurora.org>
 <CAMf-jSm2fPPstFD2h4-gG=MCDty34f-O0ooizDEKyQUd3+CxGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <CAMf-jSm2fPPstFD2h4-gG=MCDty34f-O0ooizDEKyQUd3+CxGQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 13, 2014 at 01:44:25AM +0530, Pramod Gurav wrote:
> Andy,
> Couple of minor comments.
>=20
> On Sat, Sep 13, 2014 at 12:58 AM, Andy Gross <agross@codeaurora.org> wrot=
e:
>=20
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >
> > DWC3 glue layer is hardware layer around Synopsys DesignWare
> > USB3 core. Its purpose is to supply Synopsys IP with required
> > clocks, voltages and interface it with the rest of the SoC.
> >
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> > ---
> >  drivers/usb/dwc3/Kconfig     |    8 +++
> >  drivers/usb/dwc3/Makefile    |    1 +
> >  drivers/usb/dwc3/dwc3-qcom.c |  131
> > ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 140 insertions(+)
> >  create mode 100644 drivers/usb/dwc3/dwc3-qcom.c
> >
> >
> <..>
>=20
>=20
> > +#include <linux/platform_device.h>
> > +
> > +struct dwc3_qcom {
> > +       struct device           *dev;
> > +
> >
> Extra new line here.

that's not an issue however.

> > +       struct clk              *core_clk;
> > +       struct clk              *iface_clk;
> > +       struct clk              *sleep_clk;
> > +};
> > +
> > +static int dwc3_qcom_probe(struct platform_device *pdev)
> > +{
> > +       struct device_node *node =3D pdev->dev.of_node;
> > +       struct dwc3_qcom *qdwc;
> > +       int ret =3D 0;
> >
> Initialization not required.

I'll fix this one as I'm already applying this patch.

> > +
> > +       qdwc =3D devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
> > +       if (!qdwc)
> > +               return -ENOMEM;
> > +
> > +       platform_set_drvdata(pdev, qdwc);
> > +
> > +       qdwc->dev =3D &pdev->dev;
> > +
> > +       qdwc->core_clk =3D devm_clk_get(qdwc->dev, "core");
> > +       if (IS_ERR(qdwc->core_clk)) {
> > +               dev_err(qdwc->dev, "failed to get core clock\n");
> > +               return PTR_ERR(qdwc->core_clk);
> > +       }
> > +
> > +       qdwc->iface_clk =3D devm_clk_get(qdwc->dev, "iface");
> > +       if (IS_ERR(qdwc->iface_clk)) {
> > +               dev_dbg(qdwc->dev, "failed to get optional iface clock\=
n");
> > +               qdwc->iface_clk =3D NULL;
> > +       }
> > +
> > +       qdwc->sleep_clk =3D devm_clk_get(qdwc->dev, "sleep");
> > +       if (IS_ERR(qdwc->sleep_clk)) {
> > +               dev_dbg(qdwc->dev, "failed to get optional sleep clock\=
n");
> > +               qdwc->sleep_clk =3D NULL;
> > +       }
> > +
> > +       ret =3D clk_prepare_enable(qdwc->core_clk);
> > +       if (ret) {
> > +               dev_err(qdwc->dev, "failed to enable core clock\n");
> > +               goto err_core;
> > +       }
> > +
> > +       ret =3D clk_prepare_enable(qdwc->iface_clk);
> >
> Should not we check if  qdwc->iface_clk is valid?

read the sources luke.

> > +err_clks:
> > +       clk_disable_unprepare(qdwc->sleep_clk);
> >
> IS_ERR check before above statement not needed as we have continued with
> probe even after failure og devm_clk_get?

read more carefully, there's a detail which you're missing.

--=20
balbi

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUE1V4AAoJEIaOsuA1yqREZgcP/RATVo+/gbfR2YHIk4KRXgKm
TtKHXP5NWvlIyo8Io+PTEikWt599P74N6j8TNSLMJcSXnvdim31rauKEhWiBP5JA
ivybNgNYBtRaLMttpGwd2k1YGk5V3Egp7/n/ra7XeaU/2T8XqjPl1H0yPyKVgK1j
YdxTfZBtkPgoJebgskYI0U2LjNmQwjy2mtNQjm7wie3ZOHNaJWKPreNHEGTyGzj0
ynZtKLhko//iDB+vAoymxzaKe06MhZ8qlGM94dp0hGBXHra4YMBj7hH8AHc6GU6C
aTEr+RekFf5rqyvZQfjDdYh5iL+BSX21lrtNca92kjD8aTcTD9RqpQQzTPDb1qju
Zm0v/RoRUuOGSBdbl/f1EzdSpi+wZHXrRGemfmYkgU65WykMJ697uKODW8IM8r7I
r00TJlvOpN6uwwTs560XpP2bLtDYZ2Zu+KouGSf8Pagye7OVToTnaIJm7e4cle6i
TQJNE4jbcVque/y8exxFv/trEsU+TADo6sDgKsjzd6/1MJtWsRpXVrcLsu/r8TBT
eqGNC9s8QUva4o+lwZP5eeJ9h3IpiqmgoO4Oi+yopNjsGTqsTfsJDRufbgFIezgs
uihzE4BD3ThTLrXxo8oN4MYW2LZLkFivV2Cu6TX/z/LYfp3BVsZQjqrzudgnXmuO
flL7M04cc5xSNEEwGrMq
=cXdE
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
