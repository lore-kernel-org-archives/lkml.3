Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaCRMeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:34:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58405 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaCRMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:34:06 -0400
Date: Tue, 18 Mar 2014 12:33:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harini.katakam@xilinx.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Message-ID: <20140318123348.GR11706@sirena.org.uk>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <255edf4f-05a8-4d9a-b32d-1a4a8ddaffb5@CH1EHSMHS004.ehs.local>
 <20140318110401.GH11706@sirena.org.uk>
 <d7cf691a-c9cb-4a8a-bf5c-eae952a5d729@VA3EHSMHS045.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45nhIriPRwzWsBkh"
Content-Disposition: inline
In-Reply-To: <d7cf691a-c9cb-4a8a-bf5c-eae952a5d729@VA3EHSMHS045.ehs.local>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45nhIriPRwzWsBkh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 12:13:45PM +0000, Harini Katakam wrote:

> I'm going to remove the bits_per_word check anyway.
> But the clock configuration still needs to be done.
> Where should it be done spi_setup() or transfer?

It needs to be done on the transfer - that is required anyway since the
clock rate is specified per transfer.

> > > In this case both possible interrupt conditions are handled.

> > Are you sure that's the case, and even if you are that's still not
> > handling the case where the device isn't flagging an interrupt at all.

> The IXR_ALL mask is only used to disable all the interrupts in the beginning.
> These two are the only interrupts enabled.
> And RXNEMPTY status is just polled. That interrupt is not enabled either

This is all going to be fragile in the face of bugs or changes in the
code though and like I keep saying it doesn't handle interrupt sharing.

--45nhIriPRwzWsBkh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKD0oAAoJELSic+t+oim9ztUP/2qzLnUv/CjnBMQIs1UG8qz6
iTi++PrZKQyr/IxTctAIQjsZNO8EtFVkTvTYMShwIPQogcQR74ltZIl/QWxRbRPi
ezSiifH+c9VhVNr4aIOSumNJqVSlgPgkBn0ceEw0PG8qG8L8Ur/Hnu1K/0D9KvsX
A0XcnNJdAfOE613wT3sB4FWDt7hsw9H54dnvsKGRgsUpffZstSCngohXH9sibdxV
VgquocRL9uQukO175LevtdhsmF6IIPrQ4zPT732FyjWQD60+yJzs3dX+m2Pa/7/q
n9YV5O3+bKBMZ+Og9H313bvtulGHY/sUjlMtFUq04pg+nKjbJiMhk3I+2iJDnPq3
7Uq/njbXZS9AXpoG/F2Behw8MwRHziV4dRpHbOUyIhma6muGdIyFOqEg609bgCYx
LvaBVRp5b6ttnnMyuc8Ha86WQwjCYK/EcsRFM25sHYO0TBxCyJ3vGtmSXDVq2Mvp
redCyrvMMjVOXx4zUqLVGBwi9YfakwaqpKMwGCaljjUppRbCNi6rb0cfZ5HyDsfB
u0bJAmdKDUlESPnuPTvPoUKP3XUnuXKmhXEs0xg7UVCa/zH4AhdF2SZYqoXjC01h
aFrJcPxxSGLfoJ73qgx8/lqHP33YKl2SuR2koQcswUF86WcfEaov+b4EMnqyZVff
v7w6LvpWfDiceNqx+rkL
=vdSr
-----END PGP SIGNATURE-----

--45nhIriPRwzWsBkh--
