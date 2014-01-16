Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaAPSPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:15:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55771 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAPSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:15:41 -0500
Date: Thu, 16 Jan 2014 18:15:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, jslaby@suse.cz
Message-ID: <20140116181520.GL17314@sirena.org.uk>
References: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
 <20140116161841.GA7476@kroah.com>
 <20140116170814.GI17314@sirena.org.uk>
 <20140116172240.GB9587@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline
In-Reply-To: <20140116172240.GB9587@kroah.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] tty: Fallback to use dynamic major number
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 09:22:40AM -0800, Greg KH wrote:
> On Thu, Jan 16, 2014 at 05:08:14PM +0000, Mark Brown wrote:

> > No, the issue is happening because the drivers are registering things
> > at module load time and not at device instantiation time.

> That's a driver bug that could easily be fixed, instead of hacking up
> the tty core :)

Looking at the code it really, really looked intentional - in any case
that seems worthwhile, Tushar this looks like a way forwards?

> > While the drivers won't actually be run together things like the
> > multiplatform defconfig and distro configs will build them in since
> > people tend to like to get serial early on.

> Build them into the kernel and not as modules?

Yes.  It's the common case for embedded stuff to just build everything
in so people tend to do it.

> > The other solutions I can think of are moving tty_register_driver() to
> > device probe time, allowing tty_register_driver() to accept duplicate
> > majors and the complaining when the devices actually get instantiated
> > or changing major numbers where there is a duplicate which is guaranteed
> > to break at least some userspaces with static devices (which was the
> > original patch you complained about).  The first two solutions look a
> > bit fun though perhaps they fall out more easily than I suspect.

> How about fixing the drivers as I mentioned above, to not register with
> the uart or tty core until they know that their hardware is actually
> present in the system?  That would keep any tty core "hacks" from being
> needed.

Certainly makes sense to me.  I have to confess that looking at the code
it looked totally intentional and I remember dragons from the last time
I had to peer into that stuff.

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2CG1AAoJELSic+t+oim91dQP/2r+OAi3JGs+M3Q65AIEYjwC
8qgHHYsrrtLGhL1CIC6tW8oIs1mIPvAzdI89siDqzAIvrVVSeB0J8apxg3FHsu6K
uCQGYfjXynq3zXYWJjOjtCPiFSUJFNEpicKG+kDdFbuqNKflRsPMQ2cubRc42u0/
2ljEhMC+lAxs+CBHyCDB/KNDJyYwIHckb1DIMPcu2Npb+dc28Wb6246TpQfj8W8n
/2ydJVerH8OnuCnXNRxgTKNivqthvUAE32JPbYvaPlNO0u7HcqAgOzZY3rP73oYy
SCL5EshC8415FEJrJRFTYe3jNFANKqxLn315h/UtZrDurjWOAnQmr1s61N/x1+A9
lRMeYXgQBzaodMIlnLqdkpQBbYHPzPMomu7jtp691pBqkMN8Mzt9PgFpXCTUJ55P
rOwVkvW8cm0mnFeDqYsaGjZHYEpFjdqz7Q+38QQ/j/xRhnsCmr/GsVEUNoE4EWVl
3yotFC9wSC5CBLZFg2iNU/Usxrmpv8vwHaoejoiduxPmytbYjMNfT7jigRPrT1TL
FNc/JNwnvv0dE6wnsh0FXxVO9hTSC+K0VlY1O5KejZi1n47XsgcvjR/3PgV7DbZ/
8tS6G/Y83RzagV3asgXO5AD5ZvN1WdLXRwUZFzswdeMUQiHzBC6Cr7kBFEKq7sQk
V7Gu6xytUPuCny5ThiRf
=ghHW
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--
