Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657AbaKNVJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:09:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40140 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaKNVJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:09:13 -0500
Date: Fri, 14 Nov 2014 15:07:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 6/8] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Message-ID: <20141114210709.GD16388@saruman>
Reply-To: <balbi@ti.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
 <1415726020-19238-7-git-send-email-dinguyen@opensource.altera.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844EBD12@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844EBD12@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 09:01:49PM +0000, Paul Zimmerman wrote:
> > From: dinguyen@opensource.altera.com [mailto:dinguyen@opensource.altera=
=2Ecom]
> > Sent: Tuesday, November 11, 2014 9:14 AM
> >=20
> > From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >=20
> > Since the dwc2 hcd driver is currently not looking for a clock node dur=
ing
> > init, we should not completely fail if there isn't a clock provided.
> > By assigning clk =3D NULL, this allows the driver, when configured for =
dual-role
> > mode, to be able to continue loading the host portion of the driver when
> > a clock node is not specified.
> >=20
> > Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> > ---
> > v7: Reworked to use clk=3DNULL and remove the need to is IS_ERR(clk)
> > v6: none
> > v5: reworked to not access gadget functions from the hcd.
> > ---
> >  drivers/usb/dwc2/gadget.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > index 37c7916..367689b 100644
> > --- a/drivers/usb/dwc2/gadget.c
> > +++ b/drivers/usb/dwc2/gadget.c
> > @@ -3431,6 +3431,7 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, in=
t irq)
> >=20
> >  	hsotg->clk =3D devm_clk_get(dev, "otg");
> >  	if (IS_ERR(hsotg->clk)) {
> > +		hsotg->clk =3D NULL;
> >  		dev_err(dev, "cannot get otg clock\n");
> >  		return PTR_ERR(hsotg->clk);
> >  	}
>=20
> Whoops, you just broke the return value, since you NULL out
> hsotg->clk and then call PTR_ERR() on it.

yeah, the idea was to remove the early return too :-)

--=20
balbi

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZm79AAoJEIaOsuA1yqREgmcQAJw2sHg9y6v3rKMPSRdCcO+6
GLUPECqxR+O7eysu1QHlrsyXeYAytOTOhheqt6M5RY1yrNkbMnFjAmmgCrQE+DBG
/wdP9jkGHDLUBDZjXMQUlbC4qAH/sXfqS/v3jM3cHbvJbYIiHvh3I1TLXbas3PgX
9222MjrTnO5q5ZJzpymrN1kul2d8PnFIewRbFNipRavs2EZKsNpI5ETV2dePrIPB
Vi9BU0jemfAmMiPjCJkE+U2thU6aWBKVsuSpml0X8pDcfbka0g4SET0LEFLPDu1g
TNhnWanq5hc1GmJ6NJyTBdq0K6la+x24dVbIUM+z6MWCZfD0111u+IvpY8OZ3Gn8
ufRFsfG4J9yM2JLXeqPah7n5Rdf+I8VpmjxBjQQPF6xOeNI4hti70OSXa8woNDGh
MjLeJKT1WRxtwPurp1urHwYo50A7pM+kxS8KDD/glOC+KYLSHgsuwzJU2BwdyZXd
Iij92apDf1sDVj1NEbayraG1kXQtQqvM9VVYg/ZjxnHXKZV6C4lsW7qcM7Tx3qL+
JQCjLPwHCrcw7wxZxmdNd0omXp5BX/s9v9HVmLFADxcgk/9fONZ9V5ERCKE+pAP7
5vamAzmOhDv5O1WNp7icxY8hp3RUu4nWq7wtYBwv8kwmBcxPDSIJdwUfR2PoEbof
spYDIyQRHziJ6n2zCl37
=Ao0E
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
