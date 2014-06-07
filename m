Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaFGJbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 05:31:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58947 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaFGJbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 05:31:32 -0400
Date: Sat, 7 Jun 2014 10:31:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20140607093113.GY5099@sirena.org.uk>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-8-git-send-email-lee.jones@linaro.org>
 <20140605103009.85BE4C40A4D@trevor.secretlab.ca>
 <20140605103709.GE19550@lee--X1>
 <CACxGe6vLuKygv0E7yq42qe-Lh+nMZ1wrL7PW_TAeoz55wz9q8A@mail.gmail.com>
 <20140605155509.GH24240@lee--X1>
 <20140606102446.GK2520@sirena.org.uk>
 <20140606123653.GP24240@lee--X1>
 <20140606234253.A4E25C427F0@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6y7Y3jhkIVKgvfoh"
Content-Disposition: inline
In-Reply-To: <20140606234253.A4E25C427F0@trevor.secretlab.ca>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the
 aforementioned systems
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6y7Y3jhkIVKgvfoh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 07, 2014 at 12:42:53AM +0100, Grant Likely wrote:
> On Fri, 6 Jun 2014 13:36:53 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> > On Fri, 06 Jun 2014, Mark Brown wrote:

> > > > I've also been mulling over the idea of removing the second probe()
> > > > parameter, as suggested by Wolfram.  However, this has quite deep
> > > > ramifications which would require a great deal of driver adaptions.

> > > If you're going to do that another option is to refactor the probe()
> > > function to take the driver_data as an argument and then have the core
> > > pass that from whatever table it matched from rather than the entire
> > > i2c_device_id structure.  That way the driver just needs to supply all
> > > the ID tables mapping binding information to whatever it needs and the
> > > core can pass in the driver data from whatever table it matched against.

> > Unfortunately this means we're back to the aforementioned typing
> > issue.  For struct {platform,i2c,spi,acpi,etc}_device_id the driver
> > data is a kernel ulong but the of_device_id's driver data attribute is
> > a void*.

> We're actually okay there. Each subsystem defines it's own convention
> about what those values mean. ulong and void* are the same size and
> every user I've seen stuffs the same data into the data field of both
> tables.

Indeed - if we're going to go with that approach it seems to me like we
should just pick one and put any casting in the core.

> > I've just started work on a migration over to a new probe().  I don't
> > think it's all that much work, but if there are any objections I'd
> > prefer to hear them now rather than waste any time.

> I have no problem with that approach.

Converting probe() makes sense to me.  I think I would prefer to see the
ID lookup handled as an argument to probe() rather than with functions
in probe() but it's not the end of the world if it isn't.

--6y7Y3jhkIVKgvfoh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTktvXAAoJELSic+t+oim9l8wP/1jF0+blOk/7Tly8tDciwRIM
drLZj2RqQUutNEh62orzIMbkygeH+zlOsLPhyDwOv8ROUJNZ7b5eAknl5olePEgx
BFT+v00EogShn+QQepggCSTiEAxWLr2YNavzhzGm71m8l/wp6xDxoKeb4ZCubdCr
97lAb/pB0wIFATZ3nGTCJrm56KOISw3AWkdmAp0NQHFfBxE+zBQ8zQcIfRm8LZVo
KHsZc+PSlz6tJhJiqaC/aAn+jpRRJWKtaeoEZ9sGB5NWvvXqynnxD+rJPUft4sTC
e2d/oUQlmp6nicfwOOSqs08afXCnneF6VEfKJl/SRHtlS1O64uiZXsQPCC7bunx0
YfQ6DVdJIGfWh3eNxpSFaHkpm2snYT5pVosRobo675c1LaFT+QMmdk9cbIvUXYiU
r9x67MhJCnADRHhYa8GIXT8xtJD/bTVKABvFX1VCRxt6r4Tda2wKr9a2rep7PA1p
7W3I+0lsLxIW4moujk38lGOPvXE5XYeLUqxMtQkzURq/aIxrHluOjM0gkksozWB1
Um/l3hf0/wfVTha8s/veQAa/EgkSmjgHzrk5xCpk90UFYObVL0XHZzV5dmkJIm+F
KkgwbIYiW2Uzpga3EPbEkwox+J7xUzBu7aArG+wkVn6Y0pQhc9Hb/XyFHIwY6/34
zV8lulsr1d9VQQOIduqC
=e8OY
-----END PGP SIGNATURE-----

--6y7Y3jhkIVKgvfoh--
