Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3LPXi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:38:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39937 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LPXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:38:56 -0500
Date: Mon, 16 Dec 2013 17:38:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, WingMan Kwok <w-kwok2@ti.com>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131216233815.GB29284@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131216154020.9d7f9dacf60e41b775d44223@canb.auug.org.au>
 <20131216194113.GA5258@saruman.home>
 <20131217101032.1f4d2ba671e6359fce0514cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <20131217101032.1f4d2ba671e6359fce0514cb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 10:10:32AM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> On Mon, 16 Dec 2013 13:41:13 -0600 Felipe Balbi <balbi@ti.com> wrote:
> >
> > On Mon, Dec 16, 2013 at 03:40:20PM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the usb-gadget tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > drivers/usb/phy/phy-keystone.c: In function 'keystone_usbphy_probe':
> > > drivers/usb/phy/phy-keystone.c:96:4: warning: passing argument 3 of '=
usb_phy_gen_create_phy' makes pointer from integer without a cast [enabled =
by default]
> > >     USB_PHY_TYPE_USB2, 0, false);
> > >     ^
> > > In file included from drivers/usb/phy/phy-keystone.c:25:0:
> > > drivers/usb/phy/phy-generic.h:18:5: note: expected 'struct usb_phy_ge=
n_xceiv_platform_data *' but argument is of type 'int'
> > >  int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xc=
eiv *nop,
> > >      ^
> > > drivers/usb/phy/phy-keystone.c:96:4: error: too many arguments to fun=
ction 'usb_phy_gen_create_phy'
> > >     USB_PHY_TYPE_USB2, 0, false);
> > >     ^
> > > In file included from drivers/usb/phy/phy-keystone.c:25:0:
> > > drivers/usb/phy/phy-generic.h:18:5: note: declared here
> > >  int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xc=
eiv *nop,
> > >      ^
> > >=20
> > > Caused by commit 25acdd08fd71 ("usb: phy: add Keystone usb phy driver=
")
> > > interacting with commit bd27fa44e138 ("usb: phy: add Keystone usb phy
> > > driver") which was merged before v3.13-rc1 and is included in the
> > > usb-gadget tree.
> >=20
> > I cannot see how those commits would cause the error above. I have
> > recompiled my tree with allmodconfig (x86 and ARM) config and
> > omap2plus_defconfig (adding COMPILE_TEST and enabling KEYSTONE PHY) and
> > cannot see this error.
> >=20
> > Maybe someone applied a drivers/usb/phy/ patch ahead of me ?
>=20
> That would be your patch (af9f51c5512f "usb: phy: generic: fix how we find
> out about our resources") that went into v3.13-rc4 ...
>=20
> Can you send me a suitable merge fixup, please?

It's long, sorry, basically what I did was this:

-      ret =3D usb_phy_gen_create_phy(dev, &k_phy->usb_phy_gen,
-                      USB_PHY_TYPE_USB2, 0, false);
+      ret =3D usb_phy_gen_create_phy(dev, &k_phy->usb_phy_gen, NULL);

full commit:

commit 7df5cc5f4558955dcba46c328e68df5351f3c958
Merge: 319e2e3 f8800d4
Author: Felipe Balbi <balbi@ti.com>
Date:   Mon Dec 16 17:36:33 2013 -0600

    Merge branch 'next' into tmp-merge
   =20
    * next: (60 commits)
      usb: gadget: f_fs: fix sparse warning
      usb: gadget: FunctionFS: add configfs support
      usb: gadget: FunctionFS: Remove compatibility layer
      usb: gadget: g_ffs: convert to new interface of f_fs
      usb: gadget: FunctionFS: convert to new function interface with backw=
ard compatibility
      usb: gadget: FunctionFS: add devices management code
      usb: gadget: FunctionFS: create utility file
      usb: gadget: FunctionFS: Remove VLAIS usage from gadget code
      usb: gadget: rndis: merge u_rndis.ko with usb_f_rndis.ko
      usb: gadget: f_rndis: remove compatibility layer
      usb: gadget: g_ffs: convert to new interface of f_rndis
      usb: gadget: f_subset: remove compatibility layer
      usb: gadget: g_ffs: convert to new interface of f_subset
      usb: gadget: f_ecm: remove compatibility layer
      usb: gadget: g_ffs: convert to new interface of f_ecm
      usb: gadget: g_ffs: remove a reduntant gfs_ether_setup variable
      usb: gadget: configfs: allow setting function instance's name
      usb: gadget: s3c-hsotg: add flush TX FIFO when kill all requests
      usb: gadget: s3c-hsotg: fix maxpacket size in s3c_hsotg_irq_enumdone
      usb: phy: initialize the notifier when add a new phy
      ...
   =20
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --cc drivers/usb/phy/phy-keystone.c
index 0000000,a04fb94..533db12
mode 000000,100644..100644
--- a/drivers/usb/phy/phy-keystone.c
+++ b/drivers/usb/phy/phy-keystone.c
@@@ -1,0 -1,142 +1,141 @@@
+ /*
+  * phy-keystone - USB PHY, talking to dwc3 controller in Keystone.
+  *
+  * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+  * This program is free software; you can redistribute it and/or modify
+  * it under the terms of the GNU General Public License as published by
+  * the Free Software Foundation; either version 2 of the License, or
+  * (at your option) any later version.
+  *
+  * Author: WingMan Kwok <w-kwok2@ti.com>
+  *
+  * This program is distributed in the hope that it will be useful,
+  * but WITHOUT ANY WARRANTY; without even the implied warranty of
+  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  * GNU General Public License for more details.
+  *
+  */
+=20
+ #include <linux/module.h>
+ #include <linux/platform_device.h>
+ #include <linux/usb/usb_phy_gen_xceiv.h>
+ #include <linux/io.h>
+ #include <linux/of.h>
+=20
+ #include "phy-generic.h"
+=20
+ /* USB PHY control register offsets */
+ #define USB_PHY_CTL_UTMI		0x0000
+ #define USB_PHY_CTL_PIPE		0x0004
+ #define USB_PHY_CTL_PARAM_1		0x0008
+ #define USB_PHY_CTL_PARAM_2		0x000c
+ #define USB_PHY_CTL_CLOCK		0x0010
+ #define USB_PHY_CTL_PLL			0x0014
+=20
+ #define PHY_REF_SSP_EN			BIT(29)
+=20
+ struct keystone_usbphy {
+ 	struct usb_phy_gen_xceiv	usb_phy_gen;
+ 	void __iomem			*phy_ctrl;
+ };
+=20
+ static inline u32 keystone_usbphy_readl(void __iomem *base, u32 offset)
+ {
+ 	return readl(base + offset);
+ }
+=20
+ static inline void keystone_usbphy_writel(void __iomem *base,
+ 					  u32 offset, u32 value)
+ {
+ 	writel(value, base + offset);
+ }
+=20
+ static int keystone_usbphy_init(struct usb_phy *phy)
+ {
+ 	struct keystone_usbphy *k_phy =3D dev_get_drvdata(phy->dev);
+ 	u32 val;
+=20
+ 	val  =3D keystone_usbphy_readl(k_phy->phy_ctrl, USB_PHY_CTL_CLOCK);
+ 	keystone_usbphy_writel(k_phy->phy_ctrl, USB_PHY_CTL_CLOCK,
+ 				val | PHY_REF_SSP_EN);
+ 	return 0;
+ }
+=20
+ static void keystone_usbphy_shutdown(struct usb_phy *phy)
+ {
+ 	struct keystone_usbphy *k_phy =3D dev_get_drvdata(phy->dev);
+ 	u32 val;
+=20
+ 	val  =3D keystone_usbphy_readl(k_phy->phy_ctrl, USB_PHY_CTL_CLOCK);
+ 	keystone_usbphy_writel(k_phy->phy_ctrl, USB_PHY_CTL_CLOCK,
+ 				val &=3D ~PHY_REF_SSP_EN);
+ }
+=20
+ static int keystone_usbphy_probe(struct platform_device *pdev)
+ {
+ 	struct device		*dev =3D &pdev->dev;
+ 	struct keystone_usbphy	*k_phy;
+ 	struct resource		*res;
+ 	int ret;
+=20
+ 	k_phy =3D devm_kzalloc(dev, sizeof(*k_phy), GFP_KERNEL);
+ 	if (!k_phy)
+ 		return -ENOMEM;
+=20
+ 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+ 	if (!res) {
+ 		dev_err(dev, "missing usb phy resource\n");
+ 		return -EINVAL;
+ 	}
+=20
+ 	k_phy->phy_ctrl =3D devm_ioremap_resource(dev, res);
+ 	if (IS_ERR(k_phy->phy_ctrl))
+ 		return PTR_ERR(k_phy->phy_ctrl);
+=20
 -	ret =3D usb_phy_gen_create_phy(dev, &k_phy->usb_phy_gen,
 -			USB_PHY_TYPE_USB2, 0, false);
++	ret =3D usb_phy_gen_create_phy(dev, &k_phy->usb_phy_gen, NULL);
+ 	if (ret)
+ 		return ret;
+=20
+ 	k_phy->usb_phy_gen.phy.init =3D keystone_usbphy_init;
+ 	k_phy->usb_phy_gen.phy.shutdown =3D keystone_usbphy_shutdown;
+=20
+ 	platform_set_drvdata(pdev, k_phy);
+=20
+ 	ret =3D usb_add_phy_dev(&k_phy->usb_phy_gen.phy);
+ 	if (ret)
+ 		return ret;
+=20
+ 	return 0;
+ }
+=20
+ static int keystone_usbphy_remove(struct platform_device *pdev)
+ {
+ 	struct keystone_usbphy *k_phy =3D platform_get_drvdata(pdev);
+=20
+ 	usb_remove_phy(&k_phy->usb_phy_gen.phy);
+=20
+ 	return 0;
+ }
+=20
+ static const struct of_device_id keystone_usbphy_ids[] =3D {
+ 	{ .compatible =3D "ti,keystone-usbphy" },
+ 	{ }
+ };
+ MODULE_DEVICE_TABLE(of, keystone_usbphy_ids);
+=20
+ static struct platform_driver keystone_usbphy_driver =3D {
+ 	.probe          =3D keystone_usbphy_probe,
+ 	.remove         =3D keystone_usbphy_remove,
+ 	.driver         =3D {
+ 		.name   =3D "keystone-usbphy",
+ 		.owner  =3D THIS_MODULE,
+ 		.of_match_table =3D of_match_ptr(keystone_usbphy_ids),
+ 	},
+ };
+=20
+ module_platform_driver(keystone_usbphy_driver);
+=20
+ MODULE_ALIAS("platform:keystone-usbphy");
+ MODULE_AUTHOR("Texas Instruments Inc.");
+ MODULE_DESCRIPTION("Keystone USB phy driver");
+ MODULE_LICENSE("GPL v2");
diff --cc drivers/usb/phy/phy-mxs-usb.c
index 545844b,fa44c0f..b42897b
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@@ -160,11 -167,9 +167,9 @@@ static int mxs_phy_probe(struct platfor
  	mxs_phy->phy.notify_disconnect	=3D mxs_phy_on_disconnect;
  	mxs_phy->phy.type		=3D USB_PHY_TYPE_USB2;
 =20
- 	ATOMIC_INIT_NOTIFIER_HEAD(&mxs_phy->phy.notifier);
-=20
  	mxs_phy->clk =3D clk;
 =20
 -	platform_set_drvdata(pdev, &mxs_phy->phy);
 +	platform_set_drvdata(pdev, mxs_phy);
 =20
  	ret =3D usb_add_phy_dev(&mxs_phy->phy);
  	if (ret)

--=20
balbi

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr47nAAoJEIaOsuA1yqRExGIQAKBGvINqtE7lJ+DTnuoZR80S
o88aWxab0eq0jBUM4BBISjgq05vrtxV/yFQS/sNb3UQhIW+67bxpV7NaL6AeGUcu
egk7jxLfDJ61et+FjcrFP9EqgEZJeBHy410Iykw7+Ns6SfqtKdiS7LfdPlRDPY2N
1Bn3HSTV8krmIk6NNn0gnr20nXYvwekJ5Sxerx+1sN6qZne4nmZjFHAl3k/KEgXU
zRcOjsctdKNljz6AF08CGBCTaa7rk8s6Zkbx1glHagjfcAJX4pb7STiCAf4zjpU+
QbD0MjsAV8gOrXUca3MKB+/jYYaE9tf4a8yhUBk2FbT+dwBAdeAHrbPtGXqoRhp5
hPhm70c3wHQ7fZoXmQEsr8AudRpREyWuLRw1/YRtZH7r4a86CCWpOZVKIIiCh9GT
TUzlWYz8JDCrxeGJE9h+LUbwKYYTisPcHZ9Qywom4c2ahbV1/e/V/BtrSshbsHWw
hxc64h3APqUVD7Gosu7sdLh8cstxIBQRmbmmwA1BV/xKcx4vgbSM3ZNwXUX4BiCE
WdCP7PsRls21S3VdfvvDB6qKycbXUIBYduyXnnyasDuCgW/YO5/mPBEMSTK86h0e
l2x3ANAQojvurTUTSpy2+tGw+Z3mny89BohS9Y5XKyCKIjV+//kuO+JR1aU0sq1M
L24+io5mEY4t1Iw4b0d9
=ir4U
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
