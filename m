Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3LIToH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:44:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40790 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab3LITlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:41:20 -0500
Date: Mon, 9 Dec 2013 13:40:32 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131209194032.GC28441@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
 <20131209041152.GC20608@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20131209041152.GC20608@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Sun, Dec 08, 2013 at 10:11:52PM -0600, Felipe Balbi wrote:
> On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> > Hi Felipe,
> >=20
> > After merging the usb-gadget tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/built-in.o: In function `otg_set_state':
> > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> >=20
> > CONFIG_USB is 'm' in this build.
> >=20
> > I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb: phy:
> > Add OTG FSM configuration option")?
> >=20
> > I have used the usb-gadget tree from next-20131206 for today.
>=20
> I see what caused it, will fix it up with a patch which should probably
> be backported a few kernels back. Thanks for letting me know.

Do you still have the .config which caused that build error ? I couldn't
reproduce with CONFIG_USB=3Dm && CONFIG_USB_OTG=3Dy.

In any case, I believe this will help:

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index fed7f68..03cc86c 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -51,6 +51,7 @@ config USB_DYNAMIC_MINORS
=20
 config USB_OTG
 	bool "OTG support"
+	depends on USB && USB_GADGET
 	depends on PM_RUNTIME
 	default n
 	help


It makes no sense to allow OTG without having both host and gadget
support.

cheers

--=20
balbi

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSphywAAoJEIaOsuA1yqREl9IP/2Ev+vgCskCbqWChAM7XyBOH
jdpRLOf7R33Wjpkyf7u54aaAM2IDGpGDWsRNXGQdIQQrY/95gUjZGqxBKZbim1SC
WyX8YYVOedaYkxDuTtCL1C9n6dFSwREXqmS5U5kMkbPw4Wxi4IGGDwcCeWoC0vKm
PSUQQkr6lpKhnOMKCLfSF0Ecc7lBadqJoj5Jp+vDcG3NOS6t3P2lLFQvmvYbkFRf
45x+v4Jq5ZzO+HiKWwFMmZQmVxLa3EFhHlmhD1MKRQodQKo9+SKwx1Jeo7/W7a4N
upe1YXjMWkg7nf8sqpmE/NjO76KVWs4rKDjioIkYDqgozArthbCs3zIOCYtDPosL
EqOxSpRHjs1Jx4KZTTI6SMsVXltV1tzKRaej8CHCXEODTRI4iZwmz+wANi6/5ANo
UQMmdFklEttwM8bxpiMTTafVYlo8I+FAJPBLr3HeIUKlf0PfCLKu0liBALpTZMsQ
Hj2ZqTLUu/HmbRqdnk+YCIww3+aMDmvXmUj1umK4y82JVnQSsMPJ+0bTdNW0U1Mv
TZ/ZczdmemXyD5fUyv84GMa7IZOlTOy0GeF9LL3gWMhcfZVolPUX1A6K9eD+9Bhr
Cbyhs29JmlQw4LO1n+VYSqaMt2SiO6Ml/ZZVSipqFDLUz/cqlHtLg7UwgHDuMEu7
JZK99Ui3Oya+7qhIVnGX
=weZd
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
