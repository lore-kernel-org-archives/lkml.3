Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaEBRk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:40:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55456 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEBRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:40:58 -0400
Date: Fri, 2 May 2014 10:40:48 -0700
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140502174048.GV3245@sirena.org.uk>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4uRSjkMtiHUwt2KF"
Content-Disposition: inline
In-Reply-To: <20140501223629.GJ3000@lukather>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4uRSjkMtiHUwt2KF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2014 at 03:36:29PM -0700, Maxime Ripard wrote:

> But it actually doesn't work in a case where you can't really predict
> what is on the other side of the bus. Either because, on the board
> you're using the pins are exposed and it's pretty much up to the user
> to know what to put on it. That could be handled by DT overlays
> though.

Right, that's a completely unrelated issue.

> What never works is where the device on the other side is so generic
> that you really can't tell what it does. Think of a microcontroller
> that would behave as a SPI slave. It's behaviour and what it does is
> pretty much dependant of what we flashed on it, and suddenly the
> compatible string is not the proper reprensentation anymore.

That sounds like another situation for overlays, really the thing that's
compatible here is going to be the whole assembly rather than just the
device in isolation (or you're in a similar situation to the one you're
in with FPGAs where you have a driver implementing an application like a
loadeer

> i2c-dev works great in these cases, because you always have access to
> all the bus, and all the devices, except if the device is already used
> by someone. The patch I suggested is an attempt to mimic this.

It seems better to implement something like this at the device model
level, provide a way to have a default UIO driver for anything on a
given bus.  I don't see anything bus specific apart from saying what the
default driver to use is and it avoids the icky code fiddling about with
what devices are bound and the races that might be involved duplicated
in individual buses.

--4uRSjkMtiHUwt2KF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY9idAAoJELSic+t+oim91ggQAIRRvs5rii15krEpu2Jjyaik
maNqSIcY0fMFm96uMFwb/8IynkuKGc7rgotRlFBCQoKS6XtbSDkPqxFGBEb1uxWu
hlArJEYTMot6JodLR2cnLtMWAQzQI/lgvHlEaMoKwMFC/hCMPFuhjufxFeV+oGxL
y2abgavREKjjQEtRh4tJA1qZl7mHEopvrrvazs+y1KFJHuhAovIX8pkuEq+/VIBG
ug4EIC5JrshDPHrN4QoY2ZZD2SPJkDWabqX/iYr6w5wdXtnQ9TlxJxmsUYVaITwB
fckEdke3lP1p6l1q2u/6dbgeDsjSzw9PWBGXBpft+n/NwxetaOwsPUirRiu/YAf6
Dw9+fw/QDxYnBLPig08hKZBDPGpxekxv20kVk4yZZ4LfEUai9GN5uiY2lcP42E5L
HiomBZBXwmgHd7UMyTzkLhlt0ir0fJkuGAaTbPrzNLUkzQixql2BbF6kKcYMuxXT
TUmCI1xI/28Gq8xFwu+/dynSQLEfuXh6YcNzJ30115BfgmY5ukHueVICBtOZYn1I
xAyLhU5xxF0Knen1g0HELqCUy7BgavWda8d+NaxyDtmDKrMFGmsuL9ipcwb/oYGG
piKCAPhcaaXG2nQKkhA+DXeC0qAOTRaAVqFhAfC+lkbNf4M8viI/3Io/6MO4jWKU
kY729JF6urJ4IEdhMJE8
=cfIw
-----END PGP SIGNATURE-----

--4uRSjkMtiHUwt2KF--
