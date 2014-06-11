Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaFKEfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:35:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbaFKEf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:35:29 -0400
Date: Tue, 10 Jun 2014 23:35:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Peter Chen <peter.chen@freescale.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matt Porter <matt.porter@linaro.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611043507.GA30126@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20140611041000.GB15184@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> > Let's take USB peripheral as an example, there is a device for
> > udc, and a device driver for usb gadget driver, at default, we want
> > the device to be bound to driver automatically, this is what
> > we have done now. But if there are more than one udcs and gadget
> > drivers (eg one B port for mass storage, another B port for usb etherne=
t),
> > the user may want to have specific binding (eg, udc-0 -> mass storage,
> > udc-1 -> usb ethernet), so the binding will be established
> > after rootfs has mounted. (This feature is implementing)
>=20
> Then there better be a way to describe this on the kernel command line
> (i.e. module paramaters), right?  Which is a total mess, why not just
> not bind anything in this case and let the user pick what they want?

you can also blacklist all gadget drivers and manually probe them or -
get this - you can refrain from using gadget drivers and use libusbg to
build the gadget drivers out of raw usb functions, then bind them to the
UDC of your liking.

--=20
balbi

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTl9x7AAoJEIaOsuA1yqRE190P/2k0kU9aLAtsBSmvlRVaPe89
SgUk/HTG5QuW9CGQJiEqkQuZ130Mf/7Qj/VLwnswp0ZxycU64iNBFI142dcHHQE5
rzM+wQRQWBo2PV8G1ZqOiDoEv78e03UClOEN2SEsY41U02n2sOFwDKNhi85Ky4cg
vJexmiB26yKlHCSZPMIa0m4O5BBEZf5XbAtSty+8bv3qu/jlEb2og5bMduGbFu6J
BC4+gau5VzYwJOkYMJS1R5s6/hUs/NZ61CLnWkycZkJwv2KAw6hCavDB1DowBzuR
CCRb+K6W8dNuqoRpw+OrdV+975Ry26kPBXx3b69dYj0FMOXBXgGPYX2hTZw3IjEa
yGu281ZmvKt4HnvbVNn4cahF6BCgAxtbn1C394/muRyHSmdlUO52WCZDCjnxdwsu
8PuonsVLk/k+/KrETU7pdkD62FPVzuXpg3Jf/jTnAf1+rCOvRZUdOIJZvuiktQV8
OWkdLuoHRz24ijY8UQneaCJQaeBnGm0OMAGjyw0UiebDw3lFo7Ad19hyetSNZbkX
b3UBqPA8wL6GSqMr/MnkhpX5oGRdZY6qSfoZCym2uqlgU6fb7t/nBAxKpVbSEv/J
YDVbdOPaLcDuAcgrLD5yBzsse47inIdaYw8Iwu4ssjuwNwGNs6i5cBJx3M6Sp/8I
ZMHmqURmmBlPc+Hr6ee9
=5I4q
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
