Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbbA0Ssv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:48:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36630 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbbA0Sss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:48:48 -0500
Date: Tue, 27 Jan 2015 18:48:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Inha Song <ideal.song@samsung.com>, alsa-devel@alsa-project.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, kgene@kernel.org, sbkim73@samsung.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150127184808.GK21293@sirena.org.uk>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
 <1421989410-12490-2-git-send-email-ideal.song@samsung.com>
 <54C7C653.6080904@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="I9EedR+SylB3Jyyc"
Content-Disposition: inline
In-Reply-To: <54C7C653.6080904@samsung.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v4 1/3] ASoC: samsung: Add machine driver
 for Trats2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I9EedR+SylB3Jyyc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 06:09:39PM +0100, Sylwester Nawrocki wrote:
> On 23/01/15 06:03, Inha Song wrote:

> > +	priv->clk_mclk =  of_clk_get_by_name(codec_node, "MCLK1");
> > +	if (IS_ERR(priv->clk_mclk)) {
> > +		dev_err(&pdev->dev, "Failed to get mclk clock\n");
> > +		of_node_put(codec_node);
> > +		return PTR_ERR(priv->clk_mclk);
> > +	}

> Wouldn't it also work if we added clock handling into the wm8994 codec
> driver instead? Not sure if it is correct to retrieve the codec's clock
> in the machine driver like this. Or perhaps the MCLK1 (SoC CLKOUT) clock
> should be added to the sound DT node and handled only by the machine
> driver, together with the other (MCLK2) clock?

That's definitely where we should end up but there are practical issues
with that approach since it involves coordination with all the machine
drivers using the device.

--I9EedR+SylB3Jyyc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx91oAAoJECTWi3JdVIfQfyUH/0/oWbQKGTYoaMNAy1uPtrKY
pUAkVYCcYAcFK/3izIRPB+blvAqT0+Pp/j85XTrlsh0W8bA950ZTnNu58tE4HPaX
NY+EDq3gB+uYwoeHo5CmXmRvm2eTpNhQ9b48jN+9VlPkZlKrIZSUjbeAP9Hk/JKW
ng68h5F9Dn0+KjVBdr0bsu3/zIUJ6ejDEe9zMrAZZ3TnR1H8QSCJ/w/u0rL1RnA/
iDAPtWNM2ADajDOIXi7AdIjjNRwBcgqNbd/Z/vBkglz6naaydqIILqGjHEplPqzW
K4VzPxCamup8wbS8X+ksKVsl3gnD4t0rYSyNbb4sKrJSbHPoAk+PrmjSatNwM18=
=s2TA
-----END PGP SIGNATURE-----

--I9EedR+SylB3Jyyc--
