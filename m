Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482Ab3LIEHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:07:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52512 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab3LIEHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:07:52 -0500
Date: Sun, 8 Dec 2013 22:07:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: phy-generic: Add GPIO based ChipSelect
Message-ID: <20131209040705.GB20608@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1385967919-13258-2-git-send-email-chris.ruehl@gtsys.com.hk>
 <20131206202453.GF21086@saruman.home>
 <52A520BA.1000603@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <52A520BA.1000603@gtsys.com.hk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 09, 2013 at 09:45:30AM +0800, Chris Ruehl wrote:
> On Saturday, December 07, 2013 04:24 AM, Felipe Balbi wrote:
> >Hi,
> >
> >On Mon, Dec 02, 2013 at 03:05:17PM +0800, Chris Ruehl wrote:
> >>@@ -231,27 +249,40 @@ static int usb_phy_gen_xceiv_probe(struct platfor=
m_device *pdev)
> >>  		return -ENOMEM;
> >>
> >>  	nop->reset_active_low =3D true;	/* default behaviour */
> >>+	nop->cs_active_low =3D true;
> >>
> >>  	if (dev->of_node) {
> >>  		struct device_node *node =3D dev->of_node;
> >>  		enum of_gpio_flags flags;
> >>+		enum of_gpio_flags csflags;
> >>
> >>  		if (of_property_read_u32(node, "clock-frequency",&clk_rate))
> >>  			clk_rate =3D 0;
> >>
> >>  		needs_vcc =3D of_property_read_bool(node, "vcc-supply");
> >>+
> >>  		nop->gpio_reset =3D of_get_named_gpio_flags(node, "reset-gpios",
> >>  								0,&flags);
> >>+
> >
> >two unrelated changes
> >
> >>  		if (nop->gpio_reset =3D=3D -EPROBE_DEFER)
> >>  			return -EPROBE_DEFER;
> >>
> >>  		nop->reset_active_low =3D flags&  OF_GPIO_ACTIVE_LOW;
> >>
> >>+		nop->gpio_chipselect =3D of_get_named_gpio_flags(node, "cs-gpios",
> >>+								0,&csflags);
> >>+		if (gpio_is_valid(nop->gpio_chipselect))
> >>+			nop->cs_active_low =3D csflags&  OF_GPIO_ACTIVE_LOW;
> >>+
> >>  	} else if (pdata) {
> >>  		type =3D pdata->type;
> >>  		clk_rate =3D pdata->clk_rate;
> >>  		needs_vcc =3D pdata->needs_vcc;
> >>  		nop->gpio_reset =3D pdata->gpio_reset;
> >>+		nop->gpio_chipselect =3D pdata->gpio_chipselect;
> >>+	} else {
> >>+		nop->gpio_reset =3D -1;
> >
> >This line is already going upstream, please remove it, i'll handle the
> >conflict later.
> >
>=20
> Beause the rest of the patch set is not ready to make it in the
> upstream, I will checkout latest linux-next and send the patch again
> as a single patch.

no, please *never* base any patches off of linux-next. That tree gets
recreated every day and can never be considered stable. Aim at using a
tag from Linus instead (v3.13-rc3, for example). It's a much better
development point than linux-next.

In case patch doesn't apply cleanly, different maintainers will have
their choice of rebasing it themselves or asking author to rebase on a
specific branch.

By default, however, use a tag from Linus.

cheers

--=20
balbi

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpUHpAAoJEIaOsuA1yqREQpsQAJnUoyzlWXvoB/OWdL/k4yzq
nAetity0Fworx06NI5BRiMY4ma9RiRmcZsvdtUao60hn1Ruk1tKfSyz2pZYBxt7v
ztbS9rMuA/MRhU2X7C6gaTzsbX2a93zP7pa9VQ1ou5RmsQVOAD5FwIUTbJiwGgGZ
1aO9J+tnSS9I9H6HABlu09B87VtPDnXcFm7LJrEIBZKrXpW6+i4KAZ7bxTrqNpOC
dn0IRdgoF7H3i8ERLtQEbcl2qDZUAE/YE3E6x3uuNZCpNiplCfXYOt96AG+d/Fyh
MDzcAHHlVCyPSHk+k3zNuBpA98P0aZUbjVUo6feZn2svHWpsK8TNReZMYAIkTwW8
zP+ODJop/ozurtrQl/Tl4pq3KfK1bONi+R7N1x47opWhoih4PaZqbjg1fJ9zgszj
MQozb+GSE3x2t7+mL1y9f7BS9pSSzdNucw+lgz6RDI1QG7RhHxt1cjFtGMMnaJxO
TSbDvv6qszpTMQaYnFIAEwc1Cxub7X1h7x4MVnLn0aMEeuWBpNTMl7vzg27KD33J
x8tsAt4aRia7QL6UvNvIcybRh2/Bd13n3WQSJXS85ObNJxu4pLEaBi9CcFmx8Ntp
lfcHWGCPRgPM4kv0BpyENBx9aTrQrCE7xN98BUQSlwMY4cOGJenTn/5YTsLUd2ow
8dOHKqgzNjOSiPo+t9gJ
=lWCy
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
