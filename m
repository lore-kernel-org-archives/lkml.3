Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaANNph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:45:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53957 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:45:34 -0500
Date: Tue, 14 Jan 2014 13:45:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140114134528.GG15567@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
 <20140114125242.GE15567@sirena.org.uk>
 <CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1TulI7fc0PCHNy3"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC] spi: core: Fix logic mismatch in spi_master.set_cs()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+1TulI7fc0PCHNy3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 02:23:37PM +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 14, 2014 at 1:52 PM, Mark Brown <broonie@kernel.org> wrote:
> >On Tue, Jan 14, 2014 at 12:36:51PM +0100, Geert Uytterhoeven wrote:

> > This also pushes the handling of CS_HIGH back out into the driver which
> > doesn't seem like it's helping anything.  Flipping the sense of enable

> It depends: on hardware with separate register bits for chip select polarity
> and chip select assertion it avoids having to invert the enable value a second
> time.

If we're manually setting /CS it really makes no difference what the
chip thinks the polarity is - something that is controlling /CS
autonomously can't implement this operation and something that can just
set it at any time doesn't need to worry if the chip thinks it's
asserted or not.

> > when calling set_cs() is probably OK though.

> Just flipping the sense of enable still needs a documentation update.

Huh?  Why were you updating the code then...

--+1TulI7fc0PCHNy3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1T91AAoJELSic+t+oim9tIwP/2/SgvM2l05oxvTaRmpUMjvP
c20RIruqXkijo0g9QoNPHVAK65dk3S5TuPwo61f/T8LPQ8brA3g/x1y1AbHs7UhU
0q2+vZJ9y0WnwP+8Mh6O401TcnMlspAYJ02e6U+fNCx9eHvDAsz/eIxIDr2Q8uuy
LIWQRaF+HSHzO8OhWs6Ce8Jlk3hCw5AJQDqs8El3oa4ZQVBACkyxo1o8/YknVn5V
KyFQ5DW+UsFePI1uPHs27itYSS608Yr1nfgn2JPlMx+en7jEfPAk7hJm7FaZHfO9
N65LfUYr4PjGBbVLxbd8Fo/v76lbOhpyJpyIpre3FTeD4Kw6G66wEe/qd9Y+XvVd
9cvFRY0mGPW1S6WPCnJ+cB+a4Ot0V5kQnYfUqrEeOD32rQizHTG6hfpT0JWF+xeG
A5q78wadsdcVp9zraHWbw16r5bJmi4cCr6DOxbgwpMJ9Ev3CVfZRqWSyUci62jjL
2Ai2QEfm364z9PhxGk/sC5Nu7CKott5z6qgQrAL+eD7fLf24ce+t1gHWOBVUf/+F
iGU4wP9Njz3sPnAC/yzFqDmNqV/AMxuvA9ngM9wqD3pehKmXm3gGpxhxVZa+YOxr
5mtnhTfkAti+uo+aYlpsTikMvBDiMY4iDOBrrgDaTW6FvvtSroASNZFfhYbiGve4
UxapnPH/NefQKzE+2E8J
=rdbn
-----END PGP SIGNATURE-----

--+1TulI7fc0PCHNy3--
