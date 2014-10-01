Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaJASOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:14:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57273 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaJASOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:14:14 -0400
Date: Wed, 1 Oct 2014 19:13:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20141001181346.GI4273@sirena.org.uk>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-8-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eG1/bcghN0MjPhCR"
Content-Disposition: inline
In-Reply-To: <1412037291-16880-8-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 7/7] regulator: qcom-smd-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eG1/bcghN0MjPhCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 05:34:51PM -0700, Bjorn Andersson wrote:

> According to the datasheet for the PMIC the regulators are indeed programmed in
> steps, but the steps seems to vary between different regulators and the details
> are hidden by the RPM that exposes contiguous voltage ranges.

> Either we run with this, add a few more compatibles to encode the steps or have
> the step coming from devicetree. I prefer the current implementation as that is
> the cleanest of these.

We have support for this sort of regulator in the core anyway so just
keep on doing what you're doing.

> +	if (vreg->desc.ops->set_voltage &&
> +	    (!initdata->constraints.min_uV || !initdata->constraints.max_uV)) {
> +		dev_err(&pdev->dev, "no voltage specified for regulator\n");
> +		return -EINVAL;
> +	}

You shouldn't need to do this - it should be perfectly legal to have the
ability to set voltages but not use that ability.

--eG1/bcghN0MjPhCR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULERZAAoJECTWi3JdVIfQkaUH/R8H4Om12BaxasTXJ9kZKzON
MEc99qV8yvzviRBVokPzsAyt76abtvh2LFCD1adSnjefHCI0/aKqBPKSvhC0y0ll
VJKwAG6FU04ty3a4Rc3l0DIfAFNmLl/SY1NOIzBPuxr42SjWmdLzqYtmpIXRO3Pv
xwxZ8koKJI2JAofGu4oEpamsTmRFEheTpWXOgyqJmqdar07Yeo5ZpBxf21r/E2AS
CRR7hS9SfWtsrPMuiXrcAoTIkiCYWRPnyGkds6bLob96y3eoo04dBq7kJPlt4a7r
jrGfri6ay0/4XLC/yZ5lF2H1v8DGYfr6naiwTJkzf3EKYYJUG+2byPmeqgATqbQ=
=c9/Q
-----END PGP SIGNATURE-----

--eG1/bcghN0MjPhCR--
