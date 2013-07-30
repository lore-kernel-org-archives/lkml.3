Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3G3Eeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:34:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36819 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3G3Eeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:34:36 -0400
Date: Tue, 30 Jul 2013 14:34:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>
Subject: linux-next: build failure after merge of the usb-gadget tree
Message-Id: <20130730143427.9b8560de8d74ed73f0ad561b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Jul_2013_14_34_27_+1000_1RG=xd40h16DTNjC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Jul_2013_14_34_27_+1000_1RG=xd40h16DTNjC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

After merging the usb-gadget tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/usb/phy/of.c:32:24: error: redefinition of 'of_usb_get_phy_mode'
 enum usb_phy_interface of_usb_get_phy_mode(struct device_node *np)
                        ^
In file included from drivers/usb/phy/of.c:13:0:
include/linux/usb/of.h:33:38: note: previous definition of 'of_usb_get_phy_=
mode' was here
 static inline enum usb_phy_interface of_usb_get_phy_mode(struct device_nod=
e *np)
                                      ^

Caused by commit 052a11d13bde ("usb: phy: make PHY driver selection
possible by controller drivers").  The static inline declaration in
include/linux/usb/of.h is exposed if at least one of CONFIG_OF or
CONFIG_USB_PHY is not set, but drivers/usb/phy/of.c is now built if
CONFIG_OF and CONFIG_USB_SUPPORT is set (it used to require
CONFIG_USB_PHY to be set - see drivers/usb/Makefile).  This build has
CONFIG_OF set but CONFIG_USB_PHY not set.

I have used the usb-gadget tree from next-20130729 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__30_Jul_2013_14_34_27_+1000_1RG=xd40h16DTNjC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR90JXAAoJEECxmPOUX5FEHSAP/j8IOJNCuDb+kprarPlpcxzi
Pg6xwJ0iOgw/IGnlZ/h+kRwTLBH27ONWGR1wsQDILtJ/fanZTvjGjqMKbpwLCM5t
RJ6DajAr3kX73D82xFiihLDXAYf1sGNLOT+LaWPwqHeRI3BQZyGGKcVLeszPx5IG
e5WllD2LtpYEjRN7QDYVzXuzpwxrrfU7N9jAhTbOenFeGsTsuj8Gx0ifn/dvN2fo
QYFeZZwc2ELUfPMC8ygR4/SRnNFuKW/wSAxzJaP/Sf/jplaIMUbDCIHS79+YqLmd
b6IXEVuc9kBZMbnMOzm7Naiz6ufLoByg+CcgIrgiIJkwoCXv97BXi0niGLRawQqb
i4ZUOUtHFZmsJ5SLIIbo6virawAZiGC4i4epXdLXWy6/PYG5fUjmERpPyUVOerH8
ZIdHMFVuwBcX/H+A4E2DyWnmy2nkN6OJr4scTYScWcvYdWmXCF0w06MygjuMn6ym
LO0BL2dQTZW+wrh231+tWYak+GN+1Q+z6IJDn4jdkWM6meJiaLOAhZ5lYM0wr0Y7
UgPFulAd6bjLrFJvIerWd4k9mQ+hsoJf8n6kzstqIfk8zVbllVslA3qbXMuxQ0xR
L0W3QkRpJNZWKhcL4OJ9hzn98QVBW1Xd/LvOkQdbQWtC50Z6AciPN6fcZEeXtXBC
KwgDi3k5fMAsaKAdmA4r
=lKx8
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Jul_2013_14_34_27_+1000_1RG=xd40h16DTNjC--
