Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3CNQMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:12:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44787 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab3CNQMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:12:13 -0400
Date: Thu, 14 Mar 2013 18:12:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: limit OMAP related USB options to OMAP2PLUS
 platforms
Message-ID: <20130314161204.GE3001@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1361992119-2465-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227195046.GA2300@arwen.pp.htv.fi>
 <512E653F.1090706@windriver.com>
 <5141EA01.3060905@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <5141EA01.3060905@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 14, 2013 at 11:17:21AM -0400, Paul Gortmaker wrote:
> >>> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> >>> index 65217a5..40b8463 100644
> >>> --- a/drivers/usb/phy/Kconfig
> >>> +++ b/drivers/usb/phy/Kconfig
> >>> @@ -17,6 +17,7 @@ config OMAP_USB2
> >>> =20
> >>>  config OMAP_USB3
> >>>  	tristate "OMAP USB3 PHY Driver"
> >>> +	depends on ARCH_OMAP2PLUS
> >>>  	select USB_OTG_UTILS
> >>>  	select OMAP_CONTROL_USB
> >>>  	help
> >>> @@ -27,6 +28,7 @@ config OMAP_USB3
> >>> =20
> >>>  config OMAP_CONTROL_USB
> >>>  	tristate "OMAP CONTROL USB Driver"
> >>> +	depends on ARCH_OMAP2PLUS
> >>
> >> I rather not add dependencies here and fix the selections of
> >> OMAP_CONTROL_USB.
> >=20
> > I am not sure I understand what you mean, or why you wouldn't
> > want sane dependencies in place like those given above.  Perhaps
> > you can send an alternate patch so there is no ambiguity?
>=20
> Hi Felipe,
>=20
> I'm still seeing the OMAP settings in x86 builds on mainline
> from today, and since I'd not got a reply to the above, I'm
> still wondering what alternative you have in mind vs. my
> above patch.  We can't be having the arch specific settings
> leaking out to the other arch where they make no sense[1].

why not ? It forces people to write portable drivers, it forces people
to avoid including the wrong headers and allows maintainers and patch
authors to easily compile test their drivers.

On top of all that, it lets me better use linux-next as a big build
testing before I send a pull request to Greg.

When you're going to build a product, you will come up with a proper
=2Econfig anyway. Because of a bunch of these misused 'depends on' and
'select' statements that right now ARM multiplatform builds don't even
compile cleanly if you enable all ARM-related drivers.

Until all of those are cleaned up, the best way is to force people to
write drivers which compile in all architectures and make sure Kconfig
doesn't add any ARCH dependency.

--=20
balbi

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQfbUAAoJEIaOsuA1yqREj7QP/3zvSjCIE8qqjEWtQGiGpP9e
DgYFQKISKV7essQFHdXqO3HIjwm3hOIxFiIwg3eY1sJkSOFy7g0wuBLSjYkdfj91
EIz1v3cBQv/vU8gVYXI8PxpSAfZRv5F9Xjl+roB6haVEyoPqG+XW8z7iBxx/fi/i
ORa8m2XypQ9Mq5Hh9IHvwZB6K0xsa6G7+vjAUZ+G7zsaIYWRFvbwPK33dfiF6sJo
j88qDjPeY7+ebWXo9eR9A7pr0NXDdqEN7uWBrz1vNb3Wd6QK4OoiYpq0Fq4VP5lV
gIfxk4SPpBXUVzTu7ebFlW/EXq9UMuLx6WHFrKD25HTufzMTvrEnXKZjerbSRHLT
X1SqaeebyIRfHnaZA78/lQjS03TY4y0OZzFgaHkIepXJgTEUeHflg815h9dvGi2H
bAig3cZbzGoBStF1WCbxIi/R4MKmbx5UHESdAs64RbMVHmbQKr8GbotLJR7f6d4S
W5Ferv072WxLzY6HzWHFNJbOKrwDg/pO+nVM2dPKr8EWVktvwuxCZNJAhB5MM9/i
3sD3UDoP69T92yB+yFbqrasDqM2LSHs5AVYC0IVmPNdI+LrII9DSEpWpKbDQbL/p
Jn68T6B+7mkLe0Fyak6rzg7/rKForj8TRIGu/RkcrE61i2N5e1gn65PYL3J3VvjN
9iUCxlv0wq8wgaUOpYLB
=Fbfj
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--
