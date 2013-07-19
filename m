Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab3GSJmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:42:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33212 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590Ab3GSJmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:42:23 -0400
Date: Fri, 19 Jul 2013 11:42:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-sunxi@googlegroups.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.shevchenko@gmail.com,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130719094211.GD5106@lukather>
References: <51C8B84C.3020200@schinagl.nl>
 <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
 <20130706193646.GB9778@kroah.com>
 <51E466A3.4010503@schinagl.nl>
 <20130716064107.GA10868@kroah.com>
 <20130717114650.GN3125@lukather>
 <20130717161758.GA9822@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <20130717161758.GA9822@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2013 at 09:17:58AM -0700, Greg KH wrote:
> On Wed, Jul 17, 2013 at 01:46:50PM +0200, Maxime Ripard wrote:
> > On Mon, Jul 15, 2013 at 11:41:07PM -0700, Greg KH wrote:
> > > On Mon, Jul 15, 2013 at 11:16:19PM +0200, Oliver Schinagl wrote:
> > > > So using these new patches for binary attributes, how can I pass da=
ta=20
> > > > between my driver and the sysfs files using a platform_driver? Or a=
re=20
> > > > other 'hacks' needed and using the .groups attribute from=20
> > > > platform_driver->device_driver->groups is really the wrong approach.
> > > >=20
> > > > I did ask around and still haven't figured it out so far, so I do=
=20
> > > > apologize if you feel I'm wasting your precious time.
> > >=20
> > > How is the platform device not the same thing that was passed to your
> > > probe function?
> >=20
> > One thing I don't get here is why it should be set in the
> > platform_driver structure. From my understanding of the device model,
> > and since what Oliver is trying to do is exposing a few bytes of memory
> > to sysfs, shouldn't the sysfs file be attached to the device instead?
>=20
> It will be created by the driver core for any device attached to the
> driver automatically.
>=20
> > I mean, here, the sysfs file will be created under something like
> > .../drivers/sunxi-sid/eeprom. What happens when you have several
> > instances of that driver loaded? I'd expect it to have several sysfs
> > files created, one for each instance. So to me, it should be in the
> > device structure, not the driver one.
>=20
> You can't have multiple drivers with the same name loaded (or the same
> module loaded multiple times.)  You can have multiple devices for a
> single driver, which is what we do all the time.

Yes, I know that, and it's actually my point.
With the current oliver's code he pasted earlier in this thread:

# find /sys/ -name eeprom
/sys/bus/platform/drivers/sunxi-sid/eeprom

While I'd expect the eeprom file to be located in
/sys/bus/platform/devices/X.eeprom/eeprom like it used to be in the v4,
since it's an instance-specific content.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR6QnzAAoJEBx+YmzsjxAgkNMP/RAMcTbd6hkAZwloom+X9QsI
yY/dN3b3JX5VzawLcbdCmS4Np221RAAxmF8uRFhW4yviZ2exe9cOKDV1Jx+8KCYy
eQAnl8j8XlEPKRFvaNY7kFa++B1ZL2evzj2D6uFNwDCthnmWe0B9bmy+wgDnrKYu
ypTqgN+s6ovQ9v2WR+elewwVlYdAVpSlfXUem9J7fBF3oXzZ79KwJCb1yY23qlES
68tpc9aOtSA0lUoYdDQbqV32nGyy+1zOPPc/Nd9vaF1ig/8druZ/A8yEmif/s+MO
iEWjM7AG9s8etLeDYOVz2ao3z2uiQ0QnnTcGapnpXyaT78KiZsn6KWuLrHWwLpkz
udDtQf2/ya8sGi4ow0Qmki4el5bdLpsqHzjArCBdOua6kTQzBNY19K5VYHKpUJZL
uC9ITv8jBr6pIb05cMi7GWLGmbhHE8ycfPiTzwaP5q4oYj7fStSysCwALuOF+/0C
CyGB9oLMv4tEvGZ2F3mux1XhBLD9zsZje3MYEVEf5uI30+pK1EgH7oPLIP0tZ/g2
m6r8rfGCoI+c++oO/TFLCIFtgn6xuICFuozO/69uvl55QXQutRaSw98mHOvPZBld
ABA71NFlr4ZgvGOdkp/CjLA4ghxd1GFzw/+GBowkWM4HYscGgRd2iMDYp8YbaqEm
x110nWWXM614rNESkOdy
=VQRN
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
