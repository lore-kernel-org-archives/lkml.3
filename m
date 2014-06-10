Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaFJOkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:40:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55675 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbaFJOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:40:04 -0400
Date: Tue, 10 Jun 2014 16:36:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
Message-ID: <20140610143604.GC7054@lukather>
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com>
 <1402408036-5235-3-git-send-email-boris.brezillon@free-electrons.com>
 <6454089.IP8IFVsofj@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Content-Disposition: inline
In-Reply-To: <6454089.IP8IFVsofj@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, Jun 10, 2014 at 03:54:56PM +0200, Arnd Bergmann wrote:
> On Tuesday 10 June 2014 15:47:16 Boris BREZILLON wrote:
> >=20
> > +config I2C_SUN6I_P2WI
> > +       tristate "Allwinner sun6i internal P2WI controller"
> > +       depends on ARCH_SUNXI
> > +       help
> > +         If you say yes to this option, support will be included for t=
he
> > +         P2WI (Push/Pull 2 Wire Interface) controller embedded in some=
 sunxi
> > +         SOCs.
> > +         The P2WI looks like an SMBus controller (which supports only =
byte
> > +         accesses), except that it only supports one slave device.
> > +         This interface is used to connect to specific PMIC devices (l=
ike the
> > +         AXP221).
> > +
>=20
> Sorry for the stupid question, but why is this an i2c driver if the
> hardware protocol is completely different?

It's not completely different. It deviates, but still looks very
similar to i2c, and to be precise, SMBus.

You'll have the full discussion that led to do this in i2c here:
http://www.spinics.net/lists/linux-i2c/msg15066.html

Also, one significant thing to take into account is that the
communication with a device starts as I2C, only to switch to this
protocol after some initialization sequence.

> I understand that a lot of devices can be driven using either spi or
> i2c, and we have two sets of {directories,maintainers,bus_types,...}
> for them. Your description sounds like this is a separate option
> that isn't any closer to i2c than it is to spi.

That's not true. It's *much* closer from I2C than it is from SPI.

> Would it perhaps be better to expose it only as a regmap rather than
> an i2c host?

That could be a solution, but is it a common practice to define a bus
adapter driver in a regmap driver?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlxfUAAoJEBx+YmzsjxAgFO4P/iNeyhQQzPgGv9JiFxhW8yHK
bNIUu0TrEFKbxmIwhDaM6F1Q577NTAzrSkBwtHMZpU5E+EI8QD3iXn68RGT3bqBr
RLj8+h4LFqiJiWPCaJzajiarytv4dCEHnR6hmju7JXJiCDo7dAvUdg8UN8622Npq
UOHbvoqDJMDQa5kc3CyfxcRKSCl6Gjf9Erf1SdhWwdw4MEVaad0iTUaeo6EUbXTO
gUujuw5qq8Y8+9/xxmsFKVgeFQqIvvV/0c9NC6xe7NObUcHrYg7NI9UDgg6DqqgT
Yi7bhqyfIHz3SK+U29QkmurKb5XRgdLiOOxDEIloBxDTs5EXrWjAIrzf3IvWdF3u
dZ70DIcp8Jdx4sbIFm/74rRWVI8jsnps5wmbI9wHlV32FYCydC8blJja09bk4Hgy
YvNISdVYhBgidxFGONvXE2HZLik8bOGpGjzidS+K948zcszky2ntQ3Qjfw6VTxeN
JV+Fs744GxEmrKKVhrlL5iZLNNijbU2Ig4wTScUdTMLsT4UXQ7FIeXqGe/xhDEzH
knnAROIkEASiv0rfvYf1Og48BJ52+KvA3g0N/uzPVCkGDPusfFnb81wL//3oKKFi
SuxC6fsa9UZDk7QYajThZ8G5IpGpLDc8+tRSDGsW8c3p1cPLPcSSftMy62f19v58
yDbBX80NobCdQ+1ivrdg
=rFoN
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
