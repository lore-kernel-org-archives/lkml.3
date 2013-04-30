Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3D3SlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:41:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47225 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3Sk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:40:58 -0400
Date: Tue, 30 Apr 2013 19:40:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        zonque@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130430184051.GF26160@sirena.org.uk>
References: <1367316438-20267-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <1367316438-20267-1-git-send-email-marek.belisko@streamunlimited.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] ASoC: McASP: Add device tree binding for defining
 separate clock and sync used by tx and rx.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 12:07:18PM +0200, Marek Belisko wrote:
> Add new property tx-rx-clk-separate which we can distinquish between common
> and separate clock for tx and rx blocks.

So, this is a sensible thing to have and in fact the core already has
the symmetric_rates flag for this.  This says two things to me.  One is
that this patch ought to at least set the symmetric_rates flag so that
the core can tell applications that we can't set different rates in each
direction.  The other is that this probably ought to be a generic
property for dai_links so that we can just set this for any driver -
even if the driver doesn't need to do anything it still matters to the
application layer.

What I'd suggest is adding code to check if symmetric_rates is set for
the DAI link and then key off that and then a generic DT thing (or just
set it in the machine driver for now if that makes sense) to enable that
for your board or boards.
machine driver).

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgBAvAAoJELSic+t+oim9S90P/R1EmxZ8DEBivkgVdoTtQAF2
3LS5uPU77DIRvi+9+hxfk/E1+5RIsSyzXd+qEqFMWhtcof8NKfWatjnL9C2loPNj
zh5dqKKN1Ra2WMqzfuu8ftsao0iKA5RNYEfdrMFtH0ipqIIEExESo85DUrC3NLDJ
GtWJSn85oI2IPDmEZQ2QLeaJC1TKrTuixRyxSRffmSMTTOr1PLoOxS2O9Oxlu/r5
o6urXcTKTBSDwnTjsrT9pQgjujFvkC/Yz4DW9dSOpwLyqgqwVdiLORtDfp3meX4w
Oc6juxq2esw4q2EcSZWMGXXRCj+xi9j1/fT+Pp1/MhCjZDB9tc24iaEBtjGhMEZn
3xSEldRexZ56F4aZ5mp4lzkd8QD2TG8xWOo38JWs1LEidWDU+Tcl7u5e3VbOmBhV
IPMSz1WR9Jbcqzj/TLK1w9WTL9scB0Km/7c1jT92bOCf7eAwCuDYsFYq9NDizuzE
VsoQzX2Zy8NATTz5CxpCbm4RNmTqEsVGAPr2ztUN5kswOQ2vs6z97ZujHe9K5DAU
QAXTPihV0/GQcGlusMRwYXADzPFhOnmF4DfcT44jD9uKePecTMXncfyk7OLIH6e+
fcG/tNDKDzvLusYMrFYd8WaO3fDecuzAPcKy0zb6gOmENzL2/tCydV5fI2KZx7We
TLLfZZksCFqtEyN15xLC
=OjKI
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
