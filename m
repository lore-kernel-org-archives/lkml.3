Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab3DCMPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:15:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34169 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab3DCMPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:15:30 -0400
Date: Wed, 3 Apr 2013 15:15:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: Florian Fainelli <florian@openwrt.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
Message-ID: <20130403121503.GY25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1304021359130.1314-100000@iolanthe.rowland.org>
 <515C1C61.50301@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6749iDyxihQ87e9v"
Content-Disposition: inline
In-Reply-To: <515C1C61.50301@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6749iDyxihQ87e9v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 02:11:13PM +0200, Florian Fainelli wrote:
> Le 04/02/13 20:06, Alan Stern a =E9crit :
> >On Tue, 2 Apr 2013, Florian Fainelli wrote:
> >
> >>This patch removes the depends on USB from all config symbols in
> >>drivers/usb/host/Kconfig and replace that with an if USB / endif block
> >>as suggested by Alan Stern. Some source ... Kconfig lines have been
> >>shuffled around to permit a better regroupment of the Kconfig files
> >>depending on "config USB" item. No functionnal change is introduced.
> >
> >This looks almost right.  The only problem I see is in
> >drivers/usb/core/Kconfig.  The USB_OTG_WHITELIST and
> >USB_OTG_BLACKLIST_HUB symbols don't have to depend on USB or USB_OTG,
> >because they can be set if EXPERT is enabled.
> >
> >To avoid these issues, I think the best approach is to move all the
> >USB_OTG* entries over to drivers/usb/otg/Kconfig, where by rights they
> >should have been all along.
> >
> >Felipe, do you agree?
>=20
> Make sense, I will make this a sixth patch to this serie if this
> sounds right with you?

Pleae don't. Look at my 'next' branch. I deleted drivers/usb/otg/
completely. OTG should be part of usbcore and I have plans of adding
generic (and optional) OTG hooks in there.

--=20
balbi

--6749iDyxihQ87e9v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXB1HAAoJEIaOsuA1yqREuyYP/0oAoc5e7zFZ+0ui56+bpo72
T/2JUSEhilrIo7MZqNhA2pQSTuMRoi7bb96/GFucjWtOWl0nVkThtzdr1gdfJyi9
BiR7pQFcZRSkMVcVxQdnGu/1kU3av3PzEHkKx0+DbnMBr3gVuAN6oa7yxOrXms29
q+RKO/YDaV8zGPak60V1RsghKNyQvjLKkXPjxLLkwxHPMq0n5QSeuSIh846uyitE
PnTY5YnYZxipjMEdcsRiAxJVqp5XB/Cyf9geMCj8B/JUt9BYwyNxrNskRNrqAfvw
kBrTAHayNo4FdFQfXob4GJxi7RPAWni3p+hJK4uk3Bw5pztPU/CHeylpnC4ASlyN
HTb+XexN6DSJBcaXNV48BLWNHNlKQwGmZfVt1qedyR5hgxxBv4zd2urMlPsgTXzf
5x0ski6G6n2BOfD5nb5LVKR1vOzibtjRUhWBk4v9tqh/mxt0fhxRh/2j/AKXTRog
3z3I+F6ShlF6Pp5gYd5WgPVZZ70miohg4x+sMJXy1DzDREgrezwDd+5MoC/an1Oz
S+tIMmP0/USWpmkLZxpYddOL3QL5n/K4xrS6iCg5DNJppW0ZFge02QesAEVmzYiX
Q3JhKaz/fm71cUUzAphiut3n+BlLamio+p4tw+dsr/NG35QDRFXj6iZ6ZaammQ38
aqcrpr0EGH8VFs9y4yQW
=Zm95
-----END PGP SIGNATURE-----

--6749iDyxihQ87e9v--
