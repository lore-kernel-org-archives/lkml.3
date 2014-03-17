Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaCQSPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:15:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40331 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaCQSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:14:58 -0400
Date: Mon, 17 Mar 2014 18:14:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Harini Katakam <harinik@xilinx.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, michals@xilinx.com
Message-ID: <20140317181440.GY11706@sirena.org.uk>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <20140317175911.GU18529@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kigERAySUJmIn/9g"
Content-Disposition: inline
In-Reply-To: <20140317175911.GU18529@joshc.qualcomm.com>
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


--kigERAySUJmIn/9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 17, 2014 at 12:59:11PM -0500, Josh Cartwright wrote:
> On Mon, Mar 17, 2014 at 05:30:17PM +0000, Mark Brown wrote:
> > On Mon, Mar 17, 2014 at 05:35:36PM +0530, Harini Katakam wrote:

> > > +static int __maybe_unused cdns_spi_suspend(struct device *dev)
> > > +{

> > This needs to call spi_master_suspend() as well (and similarly on
> > resume).

> I'm not that familiar with the SPI core, but this seems like an
> inversion.  Is there a reason why the SPI master class doesn't implement
> suspend/resume() callbacks which handle stopping/starting the queue
> automatically for all masters?

This is for users of an optional feature of the infrastructure.  We
probably should just call it anyway since it does have checks for the
feature being used (but given all the open coding around this stuff I'd
need to verify that the class callbacks would reliably get called).

In any case that's not happening now and the driver as it stands is
buggy since it's trampling all over the hardware without syncing with
anything that isn't ongoing.

--kigERAySUJmIn/9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJzuMAAoJELSic+t+oim9ZGMP/iMA13Ug+kBvAWKjqod06Ph8
kBgZ38Llih+cwSsMYfeQ2Eyc+FMcWFA5/JOpxQOoEB4HFyGdUr99uo9CmbUwYsBO
ynA0vMfcHFQ16mQPtRa9GnCzrZR6Vhbml8CtX6Q8ol+mys4y3S0l2DRS1BqdoaIv
gP0W+aqyqYMCAIKz+bJ3+R4KjFOJ/gqMg4PizB0Zaacqmx0sxvFaYhGTNClH2ldu
/hBXBUMK6EqKONRtTO7wHRMZgPEX7KveIOSeecpZnbiKKcvEYOGxpGWXP5yO7Zwh
un53dHmsKmoAHPK+KX6NOsYLh3QgpwNgtYu4BJqK4HXVmdU5DdVSqSDBSVTXANe2
KP97QeOF3Hy829VKJsVrOU2cPbZ5SeA55ri+FD6SdQ8OkAsuUX9DWkoLCtlpUBHH
0SlfJHNOVAKE2s+y4xbGYR93tRsi4+8nw+4Zj80FHdkutykuK87FkCekrbJ0bUqc
cxaHkTKLqZVSRRpXlvqbyZq1ONlvjZLHrKwyyrnyV86EJ1D0Ijh6G4uuxI5vjs03
qgnAOMOMQdc2Fsfwpj6M93TOElYrYlBirSQ2pKa5Gi6HNQtzchyKSD5sBWf+wEbp
q9y8smKiT/wvhwYtZMuVes3JlkJTRctJ59mTjldx2MfWCEQBsZi1NNZFWvXxDMWN
KNqmdVzcYXDqxcI5VTno
=G5Dg
-----END PGP SIGNATURE-----

--kigERAySUJmIn/9g--
