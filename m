Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaFLQxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:53:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45613 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbaFLQxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:53:40 -0400
Date: Thu, 12 Jun 2014 11:53:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Porter <matt.porter@linaro.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140612165317.GD21753@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com>
 <20140611043507.GA30126@saruman.home>
 <20140611032956.GC25082@shlinux1.ap.freescale.net>
 <20140611193627.GA19366@saruman.home>
 <20140612070211.GC18009@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
In-Reply-To: <20140612070211.GC18009@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 03:02:12PM +0800, Peter Chen wrote:
> On Wed, Jun 11, 2014 at 02:36:27PM -0500, Felipe Balbi wrote:
> > On Wed, Jun 11, 2014 at 11:29:57AM +0800, Peter Chen wrote:
> > > On Tue, Jun 10, 2014 at 11:35:07PM -0500, Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> > > > > > Let's take USB peripheral as an example, there is a device for
> > > > > > udc, and a device driver for usb gadget driver, at default, we =
want
> > > > > > the device to be bound to driver automatically, this is what
> > > > > > we have done now. But if there are more than one udcs and gadget
> > > > > > drivers (eg one B port for mass storage, another B port for usb=
 ethernet),
> > > > > > the user may want to have specific binding (eg, udc-0 -> mass s=
torage,
> > > > > > udc-1 -> usb ethernet), so the binding will be established
> > > > > > after rootfs has mounted. (This feature is implementing)
> > > > >=20
> > > > > Then there better be a way to describe this on the kernel command=
 line
> > > > > (i.e. module paramaters), right?  Which is a total mess, why not =
just
> > > > > not bind anything in this case and let the user pick what they wa=
nt?
> > > >=20
> > > > you can also blacklist all gadget drivers and manually probe them o=
r -
> > > > get this - you can refrain from using gadget drivers and use libusb=
g to
> > > > build the gadget drivers out of raw usb functions, then bind them t=
o the
> > > > UDC of your liking.
> > > >=20
> > >=20
> > > I am just worried if we change the behaviour of using gadget driver,
> > > can it be accepted by user? If you think it can be accepted if we can
> > > have some docs, we can implement manually binding for gadget driver
> > > from now on.
> >=20
> > user shouldn't have to deal with direct module insertion/removal (unless
> > he's a developer and actually *wants* to do that). Docs are already in
> > tree. The entire configfs interface has been documented, it's based on
> > those documents that Matt started writing libusbg.
> >=20
> > --=20
> > balbi
>=20
> Yes, gadget-configfs is a good direction.
>=20
> I would like to know your plan for other gadget drivers (g_mass_storage,
> g_webcam, etc)

they can be built dynamically too. We only provided a version of
g_mass_storage in order to avoid regressions. We can't simply remove
that driver from the kernel.

> All functions will be supported by configfs in future, and current
> driver will be deleted?

I don't think we will be able to delete legacy drivers, but they're all
supported through configfs. I guess only webcam is missing.

> - If yes, how to cover the user who still use the old file system?
> - If no, which binding way for udc and gadget driver will be used?

going forward, we want to stick with configfs.

--=20
balbi

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmdr9AAoJEIaOsuA1yqREbdcP/0mcP06tnfXYcKLQ/XNQJ8NC
usBJR0wvNYsTUKGmge4YJJeOw51iRodbk6WBotOUV5chpdjiUIdAAh004/iWjR0k
Up0+KN4uNVGUscuGDuOKPHf62PDOSvkg456TrOzxSLmMZj7LL6KRnKqiGSH4DH7M
v8MdgHAb+SuyNDhflc8b4hd72nVRkChczb4iqSviEy7w1OzqfDCFCEoYrRAh5YGe
cKppVk29gxqxLDY8N0dpysZr+U8cCi6dkir/M5jITtJIE91/X5JC8E9oAEJemSZO
gGjolSGU7gtrGKbhn2U80Nt1qwUj9nbC0aNmChxHovUqS08qKszx1qx/RS3SWqVi
OQ+L7TEpQe53slBeoF4rgzLA6UWXC5VtvZyoylWritTRIY/ovaaJaNkJfQP2l7d1
RH4NLRbUj8b+oEd+fOK/hhxZd667BovgyLtUh4kTBd/UT9sdIMrSAWXew+6CeRUX
5g26IamSM9I8+ZvvKPIhF+K8WM93w9SQ/QXYa5iz0NOo/EYR/8whQ5ysEWWNfy/0
r4JqrjFaFlPw1XynHTf0OFyYrE23rXEFTW560ZZq8g45eQgXWLKUQ8OUNqvThZ+7
sQpfj7H3SrKnWu4w+Yv+IYJ56Ud+0SUlD3yf1lOHna94YOQhjIFmB6m6CN/J2xRN
yl4OHXjqTSeyK6fTu/Ca
=YXmy
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
