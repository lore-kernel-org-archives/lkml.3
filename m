Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3G3Ftt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:49:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51800 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3G3Ftr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:49:47 -0400
Date: Tue, 30 Jul 2013 08:49:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20130730054933.GB9155@radagast>
Reply-To: <balbi@ti.com>
References: <20130730143427.9b8560de8d74ed73f0ad561b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20130730143427.9b8560de8d74ed73f0ad561b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 30, 2013 at 02:34:27PM +1000, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> After merging the usb-gadget tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/usb/phy/of.c:32:24: error: redefinition of 'of_usb_get_phy_mode'
>  enum usb_phy_interface of_usb_get_phy_mode(struct device_node *np)
>                         ^
> In file included from drivers/usb/phy/of.c:13:0:
> include/linux/usb/of.h:33:38: note: previous definition of 'of_usb_get_ph=
y_mode' was here
>  static inline enum usb_phy_interface of_usb_get_phy_mode(struct device_n=
ode *np)
>                                       ^
>=20
> Caused by commit 052a11d13bde ("usb: phy: make PHY driver selection
> possible by controller drivers").  The static inline declaration in
> include/linux/usb/of.h is exposed if at least one of CONFIG_OF or
> CONFIG_USB_PHY is not set, but drivers/usb/phy/of.c is now built if
> CONFIG_OF and CONFIG_USB_SUPPORT is set (it used to require
> CONFIG_USB_PHY to be set - see drivers/usb/Makefile).  This build has
> CONFIG_OF set but CONFIG_USB_PHY not set.
>=20
> I have used the usb-gadget tree from next-20130729 for today.

looks like I didn't get that in my randconfigs, I'll go fix that up

Thanks

--=20
balbi

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR91PsAAoJEIaOsuA1yqREO6kQAKhD5/Jf/3HS7PL2sGGo5BZz
Vj4zlSiPCobvnubtLGfO4qN+hPR9fAgQMsKbck+d4PzKA2qMnzVNSKIeGoPS/wzX
0zxkTWeHc3GGe1od52PaOu1PHGq/bcyCY9eUXZuX//G/LKl/bLhBs+Wxuz3eC5Q8
qLn+PUm2Sr1D42yZ62RhfYtBlUkDjtzWZyYCsV6E7jTfSFqifn0JqY2PUx1TLXLQ
IZtIaPWKYq374LBe+lA7JajyRWejTRwtW3dc747+K6z1ueorjCE8LmKi2vUN614w
HlupJnfCAhpCepVqP46j1lZlBRR6c29dOquRz6TJy3fho8xBWcZc+6oDg7SGKF4n
M3XH7JIWp6tuxc78Xv45YnzBStUKqmqxLbGsX+nIee+QvrU6l57kh+IYNgVoqbZP
N9Qmq5SmQMgfeyOkhkLCUN8hxlpHxwTLmuRwcz9XqQ9FPW0YvyG9Gw3il64V9Fqj
UJWuWpQoPinEy1+ibP+ve9O3QBi2ZhsRrBnEdeOQCpa6TlEhwX/iWG0U9Wq+u3OX
0D1zNxSmWhkokKhwXUFbS/0yg6bgmP1ay3SqLvwZ6+GcnGTUX5VkUa9qGF2l9I8h
elge8ggAQVR3lfrJTdWdoocL1VPQHAt3ZjDJg4uCcems22LeYLrMH7mMz0zWZ9d9
vuhSLvbNSjgka/SsAmtw
=0mju
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
