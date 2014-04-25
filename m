Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaDYULl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:11:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50588 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaDYULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:11:39 -0400
Date: Fri, 25 Apr 2014 15:10:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        <devicetree@vger.kernel.org>, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 03/18] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140425201042.GK29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
 <5392399.GiPjM0CIZ0@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GSmKOs+wxh1Tqap7"
Content-Disposition: inline
In-Reply-To: <5392399.GiPjM0CIZ0@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GSmKOs+wxh1Tqap7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 25, 2014 at 10:01:51PM +0200, Arnd Bergmann wrote:
> On Friday 25 April 2014 16:07:01 Gregory CLEMENT wrote:
> > @@ -148,6 +149,9 @@ static int xhci_plat_probe(struct platform_device *=
pdev)
> >         if (ret)
> >                 return ret;
> > =20
> > +       if (of_device_is_compatible(pdev->dev.of_node, "marvell,armada-=
380-xhci"))
> > +               xhci_mvebu_mbus_init_quirk(pdev);
> > +
> >         /* Initialize dma_mask and coherent_dma_mask to 32-bits */
> >         ret =3D dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> >         if (ret)
>=20
> I think you're doing it the wrong way around: You have a specialized

no, it's the correct way around.

> version of the generic xhci-plat driver. The normal way to handle this
> is to have a loadable module that contains all the Armada specific
> code and that registers a platform_driver. In the probe() function of

no, that'll cause too much duplication of boilerplate code. I asked him
to write it as a quirk because then we won't end up with and xhci
platform_driver for each of the ARM licensees when all they have are
small quirks here and there.

Imagine if you had one PCI driver for each possible XHCI PCI controller
out there.

It's pointless maintainenance burden.

> that driver, you can do the platform specific setup and then call
> the generic xhci_plat_probe() function, which of course has to
> be provided using EXPORT_SYMBOL_GPL.

yeah, that sucks. Exposing a probe() function like that. I rather have
probe() actually *probe* for the HW differences.

--=20
balbi

--GSmKOs+wxh1Tqap7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWsFCAAoJEIaOsuA1yqREGSMQAKxgO/ItTx0EA0UGOeaaQWfS
IJ9Ifx/7ZwE0S5SMtnkB8XWQfSQnQarfaOPwXTvJYUGQLBIX3nwHcRY6VFrFZm8m
D6OMNycd7B0OedwtdfTIuco7MW2OyyEAqbPZtVd6eJhWAz+l15xQhekkjdJXisMY
rZ/aUE9YNvE0utDvXJOjSK2xUNeH9sEKGB2vjEKcVEh3/zW38yfc9w6g6rW7lBrt
XCf75Kpo5TmsS2VA5EUl8k598mPwQqEtFhIFHdU/LRtM9skIalwRDbCzwE732uKq
IsXJxiPHU1F9IeSM6Nu65/wgj9tF2oTAj2tZCuZfyNKAbjCoz4iJsPfP4lWH/2ko
5GaIt9ajymRxPysiYtf4suUksS3vqCSRTuo+e7UQeJtA06MQGpH5rBNtrmIun+8p
QBdkeCU6lUlHGp+en26Qrwlgg2/93B8uWjNStPK1afeXqvqvCziwi+mKWp/yWx+K
B46zw4Ac0wwN66Ce68Kly8hpE1aKc3bMW9+HSsyULKicYzJWhQHnTjkVuE4JTjq7
xHuFEBPBv/HaTfq3B/edo4T4BAQ0YT47eybP570876RBszH6oETJK4XGuDnkqIio
Xdj69wY8WqVn1DK3VJ5PMjGOAvknVtiecn2XWBlof4Mft15tO2o8TUMFXF8xb8az
cwDHI2D7o1JgKbtz25cM
=I0M9
-----END PGP SIGNATURE-----

--GSmKOs+wxh1Tqap7--
