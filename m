Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab3GBKMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:12:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46589 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3GBKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:12:05 -0400
Date: Tue, 2 Jul 2013 11:11:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130702101125.GD27646@sirena.org.uk>
References: <20130606164629.GG31367@sirena.org.uk>
 <51B1F859.1010504@itdev.co.uk>
 <20130607154134.GU31367@sirena.org.uk>
 <51B20630.7000304@itdev.co.uk>
 <20130607164700.GW31367@sirena.org.uk>
 <51B6FE69.6060505@itdev.co.uk>
 <20130611114727.GY1403@sirena.org.uk>
 <51B7151F.5070307@itdev.co.uk>
 <20130619185909.GG1403@sirena.org.uk>
 <51C47C50.8000606@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cClFwTGwHXbya3Sb"
Content-Disposition: inline
In-Reply-To: <51C47C50.8000606@itdev.co.uk>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cClFwTGwHXbya3Sb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 21, 2013 at 09:16:16AM -0700, Nick Dyer wrote:
> Mark Brown wrote:

> > Yes, to be honest.  I'd hope it wouldn't be increasing the number of
> > read/write operations...

> For some operations it does. For example updating the whole chip config
> (which is a common thing to want to do), it would turn a couple of write
> operations into ~20 on recent chips.

Is that really happening on peformance critical paths other than initial
power up (which could be handled more neatly anyway).

> > That still sounds like something the driver can handle (for example, by
> > eating the first error silently if it knows the chip is powered down)

> We've tried to implement this idea of tracking the chip power state in
> the driver and only eating the first error silently when necessary. But
> there are various entertaining corner cases (for example, it may or may
> not be in sleep on probe, how do you deal with intermittent i2c glitch). It
> would end up either being very brittle or an extremely complex mechanism
> involving tracking state and timers, the result of which is only to
> suppress a dmesg debug output saying "i2c retry", and to fail very slightly
> earlier in the normal i2c failure case. The normal fast path through
> this code is exactly the same.

It seems very suspicous that this device has all these problems but
others don't...

> > and of course a system integrator may choose not to copy the reference
> > design in this respect, it does seem a bit odd after all.

> You're being a bit optimistic there. Examples of devices that require
> this are Samsung Galaxy Tab 10.1, Asus Transformer TF101.

If absoluely nobody has used the separate wakeup pin then the hardware
designers are wasting a pin there...  my point isn't that nobody would
use the reference design it's that some boards will have the separate
signal.

--cClFwTGwHXbya3Sb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0qdKAAoJELSic+t+oim9IXoQAIb9aOtqhJg0wJOy1hk0QdUx
QmEkiwG+k1q2ACnsJF7SdSIgkKbGbdTu59roJXiKb/k8DIvka2qAqA5G8NEcdKCn
CjfCztYbmSyERvs6ekcJRFdGau0LaB493tDFBUuvQKfAy0xuVOkV+zveVQvQZ+fl
SUw982YGc3CBJWRU60YFtq+GVnBdNJxeP5EwK2FrN4agjhBDLd0SW5QGPPVl5vIt
FqssJ+IHcSrbE6+d3lSEhxkV5NWKxYMMFKgvgmdRVlDfk6ke4QMV+9+QnIg9Jg4R
Y1Aeau7hB/kGcRwOYAz7Axq5P1g2TtQDy3YwrDsBbhNF4ZQQNVFUlJ1raTa+x4DV
o++a92RqhvKQHUEi1PQByOVOi8NCj8zX3emKcCcmEvdfEhe1ldeZCW/H/dh+XWjl
NsYq8GSxx7z6PKHAmV2lb67pdk1Sewe/UOXs7bFMt2yv1YP+zEByt+x2FvgWT1O1
OlXApmbPWRzghMnQqeUSQx//sg2A3l2blxiaJ5RDttQSDOEI4c9/tDQ1SLhOuL31
mUBAdNe42abjnoL7XZxhnx/EEnJkFKeVIwsdaWQ6A1ba+SwDv4hvb0Ybpf9xFfPl
ThU+EvLJnCFiN+2gLIN5z+Z0dOx+fgxJQ3cottX9K4VbYVu89lW8v3uC+uEvisbc
ghFaOkp+BU159NO5m87f
=1lSD
-----END PGP SIGNATURE-----

--cClFwTGwHXbya3Sb--
