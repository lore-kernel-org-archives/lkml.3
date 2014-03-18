Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaCRLG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:06:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47871 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaCRLGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:06:53 -0400
Date: Tue, 18 Mar 2014 11:06:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harini.katakam@xilinx.com>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
Message-ID: <20140318110640.GI11706@sirena.org.uk>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <20140317175911.GU18529@joshc.qualcomm.com>
 <20140317181440.GY11706@sirena.org.uk>
 <554ccbca-f92e-454c-90c0-b8a4ddddf3fd@CH1EHSMHS001.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oIPRF+aTX2m15D8D"
Content-Disposition: inline
In-Reply-To: <554ccbca-f92e-454c-90c0-b8a4ddddf3fd@CH1EHSMHS001.ehs.local>
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


--oIPRF+aTX2m15D8D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 05:22:37AM +0000, Harini Katakam wrote:

> > > > This needs to call spi_master_suspend() as well (and similarly on
> > > > resume).

...

> In case of a suspend, we are stopping an ongoing transfer and
> disabling the interface.  In case I add clock disable and anything
> else to unprepared too, it will be a cleaner exit but it will still
> stop the transfer right? What do you suggest?  Should we wait for
> transfer to complete or a timeout to occur?

I suggest doing what I said above and calling spi_master_suspend().
Right now what the driver is doing is just halting the hardware if a
transfer is in progress which will break any ongoing transfers.

--oIPRF+aTX2m15D8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKCi9AAoJELSic+t+oim9QyMP/jWiK6gxNUBgEjcdxAEcl69c
MkP/Jg7ix04sB81G+YQrjgwIvw4LWvqkL3aLwx2/ko2RvxlA5Ynmt9U79An28BVL
yt18j+hiPW74297eLkGmYE4i5vNa7U5a1O6kCLc9YCJ0ZGvpJy9rBCn8FhCPsYNz
l6KqJXLVwpalpZV4EzokDyrRi9y9Hurze9giCBrOq5NLEjm6X9wdGcgKanQPKiRm
4+Pn8Uu7DiTXuKH05QGWaOBkm3tHHybdPxl41JAoxKnWe+2CQf61tHyc83qEUFAP
UUCBjZodYMUTW92W+WzLcY88ab8PHYTNcncsihQiqETCC6+GHvp8nw8C/OIPc9q+
qEbXLWhJqYS4RcOzVjfnGVIMq58JVRAYQbsx5N+rgRpE/Iev5Qpde0H2Ebd1P6pT
S+i6xEh9mPDOExdfEshc+3IoWOgn+9ev60fNF8FN5v/dFFiPEH21t4kWlpj0YQJ4
a7rVsOuF3nIktByGxJcyJwrpiHqJW7oulRU8WurCJh2IDboLB7oltY82HRCmM6i2
LEwVEmyq9MmFg3jb3sPbkQsBfAPIwWZrbvUNVc0wQ7OGSUp9KMWOaNtUSixCTl7H
iBQZOpCEUXj/wB7E963vdv5YHPiqAwU/URpyY8HiisxOAiJpFrtYWSPRodt0GsLa
8v1QC8dSQRSy64nZqo85
=71yq
-----END PGP SIGNATURE-----

--oIPRF+aTX2m15D8D--
