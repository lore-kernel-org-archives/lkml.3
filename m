Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3GZK7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:59:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37738 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3GZK7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:59:02 -0400
Date: Fri, 26 Jul 2013 11:58:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20130726105831.GA9858@sirena.org.uk>
References: <20130725111428.419ee278@armhf>
 <20130725191604.GQ9858@sirena.org.uk>
 <20130725225816.GG24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nGKiHl1eSywcUu0Z"
Content-Disposition: inline
In-Reply-To: <20130725225816.GG24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ASoc: kirkwood: merge kirkwood-i2c and kirkwood-dma
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nGKiHl1eSywcUu0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 11:58:16PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 25, 2013 at 08:16:04PM +0100, Mark Brown wrote:

> > This seems mostly fine, though it may be best to keep kirkwood-dma as a
> > separate module for the benefit of the S/PDIF support when it gets added
> > - I had a look at the implementation Russell has and it looks like it
> > can be added as a separate interface.

> You wouldn't want I2S and SPDIF to be separate modules though - they're
> the same hardware but different output stream formatters attached to the
> DMA FIFO output.  Don't forget the requirements concerning the simultaneous
> use of I2S and SPDIF - these "output formatters" must both be enabled and
> disabled in unison when concurrent use is required - both bits must be
> set or cleared together with a single register write.

OK, I knew they both needed to know about each other and to share some
stuff but I figured it was reasonable to compile out the S/PDIF support
if only using I2S or similar - so long as they're coupled at runtime it
should be fine.

> > Should the name be done as dev_name() for the interface (I don't know if
> > there is ever more than one)?

> Getting away from "kirkwood-i2s" would be sensible, because it may not be
> just "i2s" in this hardware block.  The documentation calls this an "audio
> controller" but I guess "kirkwood-pcm" would be a reasonable compromise,
> even though it has a separate AC'97 block which could also be construed
> as being "pcm".

I was thinking just pick a name at runtime based on what was doing the
instantiation which would avoid hard coding anything in the DMA driver.

--nGKiHl1eSywcUu0Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8lZUAAoJELSic+t+oim9EkAP/iXAJ6qaN8lVBm4Jvq0uZqO6
dn8feNjZc472gdpbFDctl4dGu1TIqPzyOYBLhQof7yui71Z0QURMtIWXeYovDUfh
Z5nG+/N5YSZfm0W5HDbM1sDNk3Y8fIeF8jTUpZ+JVboplBMBk36O9L/KRb/zARYu
CVc+MWVd8s3g9XPM+EodQ8YbsC6Gdm9pm+ixpllPJ3zK3Ed83gonJ5unByWLHMwX
qkSmw+3/ceEtv+1kYLVSOeh4TDkYTH4MB0Hs5VxvA0JMIv12ztcEarR3A8zrW6MS
8tsg1XvJc/uQkeKYQCa3o8vkHMIyb9WRSCETylIzxfrq3X79HdbPxSvHGeGnl4Tf
/Xs160V0dT1QrQX56QGsOipQNULJPks5QlVuk4jeqsmtS7oxIbeUXvmn9WbOo+r8
h4jcqUtWBW0zrr+vlJ6d3IGumDaDpN+v2OFiXhDXuKCBvYe6AnjQjkiT2LKrk/Eq
b6OPGUflsYpBOLNshEWjhD8uvDZ5RB4IUu4q91lsgAE4E2UC8LRt7+kmW9cFnipF
66tShXKvSWVoIBAQ0Hagkp9kFpCJScco4LFekhg2/x73I7zD2AyE6jSc6tusvBq7
BrLZeSe/fMY3PhFvy1g8GDaGnm/FBOpzGbjyhrihE33nSyREZiWRqnkDri1w0T/y
wk8uFpFxhW6wiggxPxVy
=jYt7
-----END PGP SIGNATURE-----

--nGKiHl1eSywcUu0Z--
