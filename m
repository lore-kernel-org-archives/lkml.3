Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3LPXKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:10:42 -0500
Received: from ozlabs.org ([203.10.76.45]:36620 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3LPXKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:10:41 -0500
Date: Tue, 17 Dec 2013 10:10:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <balbi@ti.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        WingMan Kwok <w-kwok2@ti.com>, Roger Quadros <rogerq@ti.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-Id: <20131217101032.1f4d2ba671e6359fce0514cb@canb.auug.org.au>
In-Reply-To: <20131216194113.GA5258@saruman.home>
References: <20131216154020.9d7f9dacf60e41b775d44223@canb.auug.org.au>
	<20131216194113.GA5258@saruman.home>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_10_10_32_+1100_0X+CKrZsN9Yr21+P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_10_10_32_+1100_0X+CKrZsN9Yr21+P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

On Mon, 16 Dec 2013 13:41:13 -0600 Felipe Balbi <balbi@ti.com> wrote:
>
> On Mon, Dec 16, 2013 at 03:40:20PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the usb-gadget tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/usb/phy/phy-keystone.c: In function 'keystone_usbphy_probe':
> > drivers/usb/phy/phy-keystone.c:96:4: warning: passing argument 3 of 'us=
b_phy_gen_create_phy' makes pointer from integer without a cast [enabled by=
 default]
> >     USB_PHY_TYPE_USB2, 0, false);
> >     ^
> > In file included from drivers/usb/phy/phy-keystone.c:25:0:
> > drivers/usb/phy/phy-generic.h:18:5: note: expected 'struct usb_phy_gen_=
xceiv_platform_data *' but argument is of type 'int'
> >  int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xcei=
v *nop,
> >      ^
> > drivers/usb/phy/phy-keystone.c:96:4: error: too many arguments to funct=
ion 'usb_phy_gen_create_phy'
> >     USB_PHY_TYPE_USB2, 0, false);
> >     ^
> > In file included from drivers/usb/phy/phy-keystone.c:25:0:
> > drivers/usb/phy/phy-generic.h:18:5: note: declared here
> >  int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xcei=
v *nop,
> >      ^
> >=20
> > Caused by commit 25acdd08fd71 ("usb: phy: add Keystone usb phy driver")
> > interacting with commit bd27fa44e138 ("usb: phy: add Keystone usb phy
> > driver") which was merged before v3.13-rc1 and is included in the
> > usb-gadget tree.
>=20
> I cannot see how those commits would cause the error above. I have
> recompiled my tree with allmodconfig (x86 and ARM) config and
> omap2plus_defconfig (adding COMPILE_TEST and enabling KEYSTONE PHY) and
> cannot see this error.
>=20
> Maybe someone applied a drivers/usb/phy/ patch ahead of me ?

That would be your patch (af9f51c5512f "usb: phy: generic: fix how we find
out about our resources") that went into v3.13-rc4 ...

Can you send me a suitable merge fixup, please?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Dec_2013_10_10_32_+1100_0X+CKrZsN9Yr21+P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSr4htAAoJEMDTa8Ir7ZwVXAAP/2rAqWSkIyoLFyZHT5sllv6s
LW1CRWGGkWPNYh4G8D10jaNmo3eCzxwGgShwnx7tFSXwkx30Vo25+Dq7ra12ePW6
7KsNWiOJbLlFsikjSFAbRXRG/e4bW447qx8gk+fcbti4ATYitCPHJtVJFj55m842
KL6olnCqt2ktKnihl48CRKxbjVIao8+BbBNEFzLUV1dBiUxddQZLqvGCkYgfJgIx
nxFgKSqyMaWPjM+IPTEB9QCQJUxct1VO2GUqA0szfl4h1jZ9Rt6FHdmqCdcM4dp4
P1ka+NyLW9kHsMToVTTLzsfnyVVjFDZ+DPwrRcrwKVmZnRuweLaiy1L/3X5Z4QmQ
aweWL0/kKqW/4xfLpjsS9PfNZQI+B9Rl+vwCrwMHf27StrVqYnri16M8XA4FpTRs
BIwVjhYjLFG2oNk6oJBiQVdAWD/702x68y16/xzfBR93/sBtp61UKsgzEfS9twr0
2YtWbYqmsFNAwixXqkTIv+BiNHnDkXr0zUSa9CysKKybS0OPRIGfdjmon3aHvQct
BnBULXYDbKGeMKLFIOota+9qTOj+yWTziCnJ71lEt/P7ASUPjdepZvx8pPjEKxn1
b5MUmWDhBhVTc8d/XXns8rsRMXA1SnognwAZKP1H23PWuUQM6Z0XqPZFpZ0cRqsM
u1umEwlyfagt4kSwBzJd
=MPqW
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_10_10_32_+1100_0X+CKrZsN9Yr21+P--
