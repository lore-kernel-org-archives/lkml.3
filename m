Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaFKTgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:36:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56221 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaFKTgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:36:49 -0400
Date: Wed, 11 Jun 2014 14:36:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Porter <matt.porter@linaro.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611193627.GA19366@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com>
 <20140611043507.GA30126@saruman.home>
 <20140611032956.GC25082@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20140611032956.GC25082@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 11:29:57AM +0800, Peter Chen wrote:
> On Tue, Jun 10, 2014 at 11:35:07PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> > > > Let's take USB peripheral as an example, there is a device for
> > > > udc, and a device driver for usb gadget driver, at default, we want
> > > > the device to be bound to driver automatically, this is what
> > > > we have done now. But if there are more than one udcs and gadget
> > > > drivers (eg one B port for mass storage, another B port for usb eth=
ernet),
> > > > the user may want to have specific binding (eg, udc-0 -> mass stora=
ge,
> > > > udc-1 -> usb ethernet), so the binding will be established
> > > > after rootfs has mounted. (This feature is implementing)
> > >=20
> > > Then there better be a way to describe this on the kernel command line
> > > (i.e. module paramaters), right?  Which is a total mess, why not just
> > > not bind anything in this case and let the user pick what they want?
> >=20
> > you can also blacklist all gadget drivers and manually probe them or -
> > get this - you can refrain from using gadget drivers and use libusbg to
> > build the gadget drivers out of raw usb functions, then bind them to the
> > UDC of your liking.
> >=20
>=20
> I am just worried if we change the behaviour of using gadget driver,
> can it be accepted by user? If you think it can be accepted if we can
> have some docs, we can implement manually binding for gadget driver
> from now on.

user shouldn't have to deal with direct module insertion/removal (unless
he's a developer and actually *wants* to do that). Docs are already in
tree. The entire configfs interface has been documented, it's based on
those documents that Matt started writing libusbg.

--=20
balbi

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmK+7AAoJEIaOsuA1yqREXr8P/3hdTGBTWJyPTNjxcPpL2WDe
xukrXQmyKHlfgWrLFZNvRogqDCeSBYB0xzwF4G0WPkdjdDFZ38JkqjNudfvewM/M
HdJWfWCHCOGF5nxKdAI7I/Dl/ResFCQ1SgNR/T9HVuLFO/d+c7yfdJR4fqWbKp3D
RQy6Pn/EZKrpZ4IXKd1/RbpIz2Lr+6yl3UABtGOuFME3NIhj5A5oWGD8JZ3zSiwD
IK+0tpvhaj3xN/6L4Xurmc7TxZaUIf3lbnmqZl4b4HAH3k8Whl+/kIVLeFrhQPSO
1sPCLEhdgz8KUUr5pudNvNshJO10+CcHqUIeCirBPJJuXieDIZuppQOV3gzc7r//
bipMX6FHxL2nJmU9DlsWyw4siXz/iXSYyLKFNnt05oREA7yHMjva4g3/x4EZGnEm
DZJJoTPw4DK1li3l02zQ6wiSA23xGByEOdM5kvNRpo2yjL9zZoZz2g+g21A2mW3E
UnoNWSZUTqo99/EIclfN4kxnwkO34grkZfWIh+vvsmmzxsuGsoBJ9Dw1/NymTBzZ
XRk+yLa596QlTHN31DysGELXH3g7oNnKaFrjHNXVw6KyBtD2kkjWKze0Qlh8TrzF
KAWObPBNkFdgnVGkJlqqbWj5wlm8xyMASBIm+cOqNMWfNPU004f5IqPqiPqyjUW3
2I2awsX3UYFZ6NkAbpke
=neq1
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
