Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3HLHsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:48:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:20513 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3HLHsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:48:19 -0400
Date: Mon, 12 Aug 2013 09:48:00 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Shinya Kuribayashi <skuribay@pobox.com>, mika.westerberg@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130812074800.GA23792@ab42.lan>
References: <20130711101330.GP4898@intel.com>
 <51DFB6C1.4040001@pobox.com>
 <20130712085140.GY4898@intel.com>
 <51E0E76B.1040304@pobox.com>
 <20130716111616.GA25835@ab42.lan>
 <51E6ACBE.7000509@pobox.com>
 <20130722131706.GA24081@ab42.lan>
 <51EFE550.1000507@pobox.com>
 <20130805093126.GE20936@ab42.lan>
 <20130805100225.GA9694@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20130805100225.GA9694@katana>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2013 at 12:02:26PM +0200, Wolfram Sang wrote:
>=20
> > > >Would it make sense to add generic I2C device tree properties for th=
ose
> > > >parameters? These parameters are independent of the actual bus drive=
r,
> > > >rather a PCB property... And as such the correct place would be devi=
ce
> > > >tree or ACPI or similar.
> > >=20
> > > If there are other bus drivers that make use of tr/tf transition
> > > times, I think it makes sense.
> >=20
> > Wolfram, what's your opinion on this?
>=20
> If it is a PCB property, it makes sense to have generic bindings for
> it. Can they have very-safe defaults and thus be optional?

We can definitely have safe defaults that work for a given
driver/hardware. I don't think the same defaults would be safe for all
drivers/hardware: The timing strategies of different I2C hardware seems
to vary widely (which edges of the clock are sampled, how does different
hardware deal with hold times etc) and depending on which parameters are
available to the driver to control these timings, the safe values would
either have to be the minimum or the maximum in the range allowed by the
I2C specification.
Every driver would thus have to implement its own defaults in case the
properties are not defined.

  Christian

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlIIkzAACgkQbI8SbDT4m4/F5gCgqWnchQJiBmeIDuhHZ8TL6RPB
K0QAnjR/hDxVcDa3oJ95d1XkmSk4SHpC
=kkYe
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
