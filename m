Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3LPTly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:41:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47698 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab3LPTlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:41:52 -0500
Date: Mon, 16 Dec 2013 13:41:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, WingMan Kwok <w-kwok2@ti.com>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131216194113.GA5258@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131216154020.9d7f9dacf60e41b775d44223@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20131216154020.9d7f9dacf60e41b775d44223@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 16, 2013 at 03:40:20PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> After merging the usb-gadget tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/usb/phy/phy-keystone.c: In function 'keystone_usbphy_probe':
> drivers/usb/phy/phy-keystone.c:96:4: warning: passing argument 3 of 'usb_=
phy_gen_create_phy' makes pointer from integer without a cast [enabled by d=
efault]
>     USB_PHY_TYPE_USB2, 0, false);
>     ^
> In file included from drivers/usb/phy/phy-keystone.c:25:0:
> drivers/usb/phy/phy-generic.h:18:5: note: expected 'struct usb_phy_gen_xc=
eiv_platform_data *' but argument is of type 'int'
>  int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv =
*nop,
>      ^
> drivers/usb/phy/phy-keystone.c:96:4: error: too many arguments to functio=
n 'usb_phy_gen_create_phy'
>     USB_PHY_TYPE_USB2, 0, false);
>     ^
> In file included from drivers/usb/phy/phy-keystone.c:25:0:
> drivers/usb/phy/phy-generic.h:18:5: note: declared here
>  int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv =
*nop,
>      ^
>=20
> Caused by commit 25acdd08fd71 ("usb: phy: add Keystone usb phy driver")
> interacting with commit bd27fa44e138 ("usb: phy: add Keystone usb phy
> driver") which was merged before v3.13-rc1 and is included in the
> usb-gadget tree.

I cannot see how those commits would cause the error above. I have
recompiled my tree with allmodconfig (x86 and ARM) config and
omap2plus_defconfig (adding COMPILE_TEST and enabling KEYSTONE PHY) and
cannot see this error.

Maybe someone applied a drivers/usb/phy/ patch ahead of me ?

--=20
balbi

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr1dZAAoJEIaOsuA1yqREqNMP/RBOb7yh9o4qpuEcRPEARUJM
i+OrIoMCw1Ws+MhajveJGt2H0uyrv7/zOEzP6bU7+Aah2iJNgCXNAaYmuFQDgtaz
YWncNNU4eVH69mggZaOzXLtwgNvAOYJQ3v3mPN6vYZsXejlU9fdBifFSh/kDCXSq
s95kejLkOjzaNhknb34TGQhDWBMFNprCQqNzdxfJKJgiLSG7pMlejjOeDraz6Z+w
AbFrR4GgLQL77ICx950+si/SgWBiGxxp67Qd49+CMvOYxmbA7SRxWAhu3Rrk8fZ3
u9hC0koioRq9mgqJ91q+u/dQtiiKSjfpLTaMK/v09M7YfobEneJk9kibnv+WWmPD
w2UxIyNeW0bR18oEz5nrzfxPBymrYxdFERjtv2JKQS0ZGLCgEfgqhDaubSeG73/Q
DNTcYyi/oEv1UwJuxepT2GWeTnK3jGuokVoA9b05w13wUQow7gtdCrHO8qJEBDnx
t3OHGJjVnjfcGMgJ4LwmBQcEdDdacxQ+zSTtD/HjDoGeB+BUq74J1/fxpTnscDcH
AyRRFwa/D2jBHTPbpfvOdSNX6I87Ro/JThRgdVLZlP0MtPL9WpkeOV16UEJf1Qmw
PoTE5B4Ou/NwmNWzE4EHJO6m+HPjk9tEUuqlt0YsPJ6G8YGysKjvHJkayNQ6r8lP
f5AMTMMwzQsVLQ5hxnic
=SR2K
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
