Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbbALQ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:27:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53290 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbbALQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:27:13 -0500
Date: Mon, 12 Jan 2015 16:26:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: atull <atull@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Kyle Teske <kyle.teske@ni.com>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Message-ID: <20150112162608.GN4160@sirena.org.uk>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com>
 <20150110151118.GA16036@amd>
 <alpine.DEB.2.10.1501111009180.2556@shineypoop>
 <CAL_Jsq+ZfCajLXhLCi4MFbLRYGgs+BcDTsKg3r5rSBPv9yjGEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JfVplkuTfB13Rsg5"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+ZfCajLXhLCi4MFbLRYGgs+BcDTsKg3r5rSBPv9yjGEQ@mail.gmail.com>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JfVplkuTfB13Rsg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 12, 2015 at 10:05:49AM -0600, Rob Herring wrote:
> On Sun, Jan 11, 2015 at 10:29 AM, atull <atull@opensource.altera.com> wrote:

> > Previous uses of the firmware layer has been to use it to load once after
> > bootup; this is different since some use cases will want to switch out
> > the FPGA image.  If someone wants there to be only one FPGA image on
> > the FGPA forever, they will probably not be using this framework; their
> > FPGA will probably be loaded before Linux boots up.

> That's not really true. Some WiFi devices have to load different
> firmware for client and AP modes and switching is a common usecase in
> phones.

Right, this is also very common for audio DSPs - the DSPs are frequently
much smaller than the total set of firmware they might want to run so
they need to switch at runtime.

> There may be other instances of drivers wanting configurable firmware
> names already. A common interface here would be nice. It could also be
> useful to expose the firmware names such that you could generate a
> list of all firmware files needed for a machine (that may already be
> possible with uevents?).

Some standard mechanism for enumerating the possible firmwares and
switching between them would definitely make life easier on the audio
side.  It'd also be good for userspace to be able to say it's got new
firmware to add to the list, but that's suggesting to me that the
enumeration part of things might be better handled in userspace.

--JfVplkuTfB13Rsg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUs/WgAAoJECTWi3JdVIfQRMMH/3W5zl41DkzvdPDiQaTIU9Hy
WQun+fyw3tPjAOXqMpsz4z57hQ7RlQ6bzRnhGQ73TsaWkumAM/DmanryEiPV3x6n
s4ppRcdzAXhVzZ4EakxHGRtb1SZDQgErdLj9kR0IwCm3u8g1sx6uq7byvmbnKamh
wJboG797SqyEFqIpcwKfUooclQvBAFOFExcpUX24qxIxavmKtfy4Zx+vSZDwaufJ
ywmQOcUqQnkp/r+wIfbTWDR8iXd6rYfamqNUQJp8ehCEjfoGGX/TCQJwQkbw+3eE
/ij7ZuDqpblD9zGOMvpMqG7KdJR1FMUxArHOpOoVl9EIrywhPqmGgihGAUqsiC8=
=2WBm
-----END PGP SIGNATURE-----

--JfVplkuTfB13Rsg5--
