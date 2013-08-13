Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab3HMSz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:55:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34631 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab3HMSzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:55:55 -0400
Date: Tue, 13 Aug 2013 19:55:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20130813185547.GD6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com>
 <20130812233641.GL6427@sirena.org.uk>
 <2472314.6b8DcBdcjO@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NxgoPD33jhlWcjWh"
Content-Disposition: inline
In-Reply-To: <2472314.6b8DcBdcjO@flatron>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/18] spi: s3c64xx: Do not require legacy DMA API in
 case of S3C64XX
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NxgoPD33jhlWcjWh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 01:49:53AM +0200, Tomasz Figa wrote:

> I've been testing this without any significant patches, like PWM, CCF or=
=20
> DT support, just everything from the branch I pointed to and some board-
> specific patches to help in debugging.

Done some more digging.  It's not failing the first time it requests the
channel, it's failing sometime later on (after we've been running for a
while but when we've had a substantial idle period).  However it is the
first time we're actually intending to use the channel, previously to
this the transfers would always be too small to trigger DMA.  I'm not
sure that's relevant though as we're not getting far enough to actually
request the channel.

I'm still debugging what's going on here - the basic refcounting all
looks OK in the SPI driver, I can see it requesting and releasing with
the refcounts all going back to zero in the DMA driver as expected but
when we come back to the device later on dmaengine is deciding the
device is unavailable quite early on in the process.

--NxgoPD33jhlWcjWh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCoEwAAoJELSic+t+oim9I04QAISKQsBhC5ipSZkwJ1dF2mgp
N7MbMprH513/7GBkLoSzO5z/SXF0947T+3TBj3jbb1M4zJuVE8KJAnJdCSYNgBFW
+omo3Fw0Dv7UVwJgn76WjMQaUzFkwUivDjrQ+pZtBmXNAgx01qbqpb2sxk/eGmBu
n/gow7k6ClbgGRypAvUXuGQo5fxfqdzSjHIDS+PQ8MA32R4nJZkd+QCceWLs5I8F
C6HU63BPbJbroRjnkgJAJsw/pouohPnuXOq/xqqM3sEnqtOq6uN0JFUswhlDNlzU
tBocIBn/F4Eg3QtfzERSBkAa0qIrepZiGXk93dTzQOvWfoqPmn7EtySmKhjYnc5/
dBOV3Fo02piZgAazHCYZZF+hQtdKS0rkAs3XO9GjAIseSFluOIOSPcCm+9ifeClJ
CXf8uB7beMWoSC8/d8O74Vvtj8eLtMTmR1wnH18OaQyjfy5UuYgMu72b2V7sd9aL
pibKump+AoN2Z+IYQwS7gnaQq5BMBC385GcFOV4VheD1QwZ0W7Tkq6rqnCGoZGrp
T2WTbf/2bEvRvFEAJImhWRa9SV4ajJvcbh7cTuGfPHtPzqis588Ecpsmxe3jqybV
Zass86LOrZcg+3ND4i0+Z2wzqmHVWTfyrEehpE631mZOwuwxdVXNGdq0TcXJN94s
RR/sM72k50bdwMnZeJGn
=9hBi
-----END PGP SIGNATURE-----

--NxgoPD33jhlWcjWh--
