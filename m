Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaC0BQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:16:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49233 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbaC0BQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:16:15 -0400
Date: Thu, 27 Mar 2014 01:14:24 +0000
From: Mark Brown <broonie@kernel.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Nicolin Chen'" <Guangyu.Chen@freescale.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140327011424.GB30768@sirena.org.uk>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6E958E@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6E958E@AcuExch.aculab.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 26, 2014 at 11:59:53AM +0000, David Laight wrote:
> From: Nicolin Chen

> > +	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
> > +	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);

> Assuming these are 'write to clear' bits, you might want
> to make the write (above) and all the traces (below)
> conditional on the value being non-zero.

The trace is already conditional?  I'd also expect to see the driver
only acknowledging sources it knows about and only reporting that the
interrupt was handled if it saw one of them - right now all interrupts
are unconditionally acknowleged.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTM3ttAAoJELSic+t+oim95MUP+gMsQMOBj7NRxd7FrKARq1Gm
LUZUJOWHUzsG/KUzJHmWIkYmcDfQSFnME6ff8piAkhKNSTctMJJa+enfVdFABO9W
v9nwruVF3qFbU29s8/G+V0PbaPyPgobUt2z5v223XLpqfGOcaAmhLtbZrJwSembu
vplBpegifopzWpo+kdb4X0BdBuVfwEXrpPmpwIz/K2EfJtUINvNB/vtw7RmKE+Xt
HamSfmEzjJsxowBNmRpgoTd7rwz1Tfudfy4ADwGHuZrr/mvUhGKWGyjxGU1+aFQj
/nNjaHvbt1L+gIWbxgookmoorRMgR99iIN6Za0mER+ZLdKHPkQT7UTC7IlTwOeAO
ZxMe0e6kgOVDvKIDstaFLsKN3d1N7GAXTapXRByjMg1QLgN8K060vs+z1XI4wxJb
JbhnOqxsc6Vw0wgpKyvHEDb3M2wdk6NPgxopdi9qGoDyRIoplsmwwfFwCxAQ0a6B
AW1H76dsqkOmeBdo8eHno+foNeD5Mx49BCL9RKiqc+nitzt1nrgwpMgE5axsex+F
bnFam/NBcw7Q2y2jbwWqBbpQziVgTwZcvXbjXpLSAX/SjJFNYnTc6UTx8WD17Htu
gAM9W6qJZqCm9Tgq+twff4xLiH0agnTZtQOf/Au2qMIR1XnGuJOzJsRerhFN48Bz
XReN9qP/EFGKVV/Ij2e8
=N62s
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
