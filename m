Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3FSS7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:59:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59589 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab3FSS7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:59:32 -0400
Date: Wed, 19 Jun 2013 19:59:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130619185909.GG1403@sirena.org.uk>
References: <20130606131638.GX31367@sirena.org.uk>
 <51B0B52C.1090807@itdev.co.uk>
 <20130606164629.GG31367@sirena.org.uk>
 <51B1F859.1010504@itdev.co.uk>
 <20130607154134.GU31367@sirena.org.uk>
 <51B20630.7000304@itdev.co.uk>
 <20130607164700.GW31367@sirena.org.uk>
 <51B6FE69.6060505@itdev.co.uk>
 <20130611114727.GY1403@sirena.org.uk>
 <51B7151F.5070307@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uuwlSTc/3kiP/jew"
Content-Disposition: inline
In-Reply-To: <51B7151F.5070307@itdev.co.uk>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uuwlSTc/3kiP/jew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 01:16:31PM +0100, Nick Dyer wrote:

> Without being able to name all of the registers (which would require a
> large amount of architecture to keep up-to-date and would probably turn
> into an unmaintainable mess), you can only split up the register map into
> separate parts. You'd end up with binary attributes like this (refer to the
> document I linked for explanation):

...

> Is that a nicer design from your point of view? I don't personally think
> that is really gains anything functional other than making the API more
> complex and increasing the number of read/write operations. I guess you

Yes, to be honest.  I'd hope it wouldn't be increasing the number of
read/write operations...

> would stop bugs in user space code from accidentally writing into the wrong
> object.

That seems like a useful thing, and it does allow the driver to
relatively easily understand what any of the attributes is doing and
take it over if it needs to.

> > Well, there's also the potential issues with standard application layer
> > code either not being able to do things that the hardware supports or
> > getting into a fight with the magic custom stuff.

> I think it's better to present a clean API cut at the right level. If you
> look at the drivers in various Android trees for these maXTouch chips,
> there's an awful lot of phone specific code which is not very general and
> it would be impossible to mainline without having a 20,000 line driver full
> of #ifdefs. Surely it's better for that to go into a userspace daemon if
> possible?

Yes, having some of the stuff that understands the contents of the
controls in userspace is sensible.  However the kernel does offer an API
for controlling devices it supports and it seems reasonable to expect
that to work too - callibration and whatnot is a bit different but core
functionality should just work from the kernel.

> >> On suspend the driver puts chip into "deep sleep" where touch acquisition
> >> is halted and minimal power consumed. But it will still come out of its
> >> sleep state temporarily to service I2C comms if necessary (although one
> >> particular family requires that I2C retry for this case).

> > So these errors are just part of waking the chip up - in that case
> > shouldn't the driver be waking the chip up automatically?

> In the reference design for that particular model of chip (mXT1386), there
> is a WAKEUP pin cross-wired to an I2C line. The only way of getting it to
> wake up when it is asleep is by trying to perform an I2C operation, which
> will fail, and then retrying before it times out and goes back to sleep
> again. There isn't any other way of waking it up.

That still sounds like something the driver can handle (for example, by
eating the first error silently if it knows the chip is powered down)
and of course a system integrator may choose not to copy the reference
design in this respect, it does seem a bit odd after all.

--uuwlSTc/3kiP/jew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwf95AAoJELSic+t+oim99nYQAJFmhivlFl+mj2I+ETfiNY3w
J+mvbKyb62+TZWGIOvEvSgCjo3BtxLeosCGsY2qPMlTUX4N2uuN+KvEnWMdUu27Z
tHuMJyv/AZow7tIw/FIzU/g5kh4xJr3FLOmAp4irFPhsFFRIVdQrBkKj2zFbzGdy
nLHtzESWFEZ6gCb21qXzBv4caJvj02Q8WfatWXDWAapg82JJSsaST0ZA2zru4R1h
V+PKd+OWg7m64fQc24MUrbM+JDCGgOwyc5m4KQVBglAtXhzQS4cMRPJagk18VLvc
k2GdL4p9wH4shs9RQBstZ4apRMGGpZhR+Fa1SPV3dF28QEMkTf32rnNkq3H2oP4Z
efc8OoDCO4LuF81GEx9WLTTAlg3ZZVOnoourkOQNlE/WQsR3OJeWe96Z88V36nKf
JXi9HlJdS9rY4lzg60jNdiMHNxxSylOksVdn7ElQBwg8Y5QYMwNB1db/snTdJxIj
R6bKMWJVs28nHe/m1fMs9Qlpy3BxkaYhZXGW43Ht50fKrk1+ahO8/ZN/ksEH/Jwz
digJjmfES6gK8Va57sqiYrcmsz1uqM5ZKKFf+FtaeFk8Bp4lgLOzm+wCQlmBpHVj
X4ee40S1aGqSSYOaKunjCJV2cm4eA7nwxzuQ1c7vGf7maTSn2auVsvcYbJAqTQlG
DKM16GBew92v1/GotJ8C
=60vE
-----END PGP SIGNATURE-----

--uuwlSTc/3kiP/jew--
