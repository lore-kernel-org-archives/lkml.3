Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3FGKAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:00:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49421 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3FGKAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:00:01 -0400
Date: Fri, 7 Jun 2013 10:59:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Andrew Chew <achew@nvidia.com>,
        Matthew Longnecker <mlongnecker@nvidia.com>
Message-ID: <20130607095936.GK31367@sirena.org.uk>
References: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com>
 <20130607090923.GH31367@sirena.org.uk>
 <alpine.DEB.2.02.1306070920010.32163@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k6SrlR5F+BMzH45x"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306070920010.32163@utopia.booyaka.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: add regulator_get_linear_step()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k6SrlR5F+BMzH45x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 09:38:10AM +0000, Paul Walmsley wrote:

> +static int get_cvb_voltage(struct platform_device *pdev, int c0, int c1,
> +			   int c2)
> +{
> +	struct tegra_dfll *td = dev_get_drvdata(&pdev->dev);
> +	/* apply only speedo scale: output mv = cvb_mv * v_scale */
> +	int mv;
> +
> +	/* combined: apply voltage scale and round to cvb alignment step */
> +	mv = DIV_ROUND_CLOSEST(c2 * td->speedo_value, td->cvb_speedo_scale);
> +	mv = DIV_ROUND_CLOSEST((mv + c1) * td->speedo_value,
> +			       td->cvb_speedo_scale) + c0;
> +
> +	/* XXX Bring back cvb_alignment_uv; put it in the board dfll DT */
> +	return DIV_ROUND_UP(mv * 1000,
> +			    td->cvb_voltage_scale * td->vdd_step) *
> +		td->vdd_step / 1000;
> +}

Hrm, right.  So I guess for this the question is why you need the steps
at all - can't the driver just ask for the voltage it wants with
whatever tolerance is appropriate (or just specify the maximum tolerable
voltage if that's better)?  I'm not sure what cvb_voltage_scale is.

I guess the problem here is that you have to hit some fairly tight
tolerances on the voltage?

--k6SrlR5F+BMzH45x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsa8FAAoJELSic+t+oim9nxkP/iWcC1owc/5TFBkzaoPDtpfQ
GXaZXiSG81A4xcFzB6grKuAKUK60jChYDg8//zAes9W2JqmadrWKkjNbFq547bvT
0ymynTwBHIUjE/DPTyT0n74SUkQYolhcM3WhRJvFSetc1PPxW7X6QIzprBqATKgQ
uBYyLPGs3AqmtDXSSJAHyZDCxhObTSyns1OrqYmVx/MxCTjrx9JwqTOMAlE4bufl
J2vlUaGzTQ86dH2KFx0/G2UcIEgp3NzD0q6htfrfl1hW6CozEGCcJwJ3zr5mZGEU
IjdpKoxYHnSKnv8pOLVVquQ19PUonYN861+VVMd+1QxNXvogK0xUtgrmxHS9t/Qr
VD3vcioAwwoD8g/pJJQSuNjkEzMmqGoqI5QyPs6yM4CS7clnwUGZXQC4ZHpIs77M
OlyrdFCIttu7t+8K/F+QsEvmIyBmIW22kjI56Mj/XNvMZKV2B+4ArhR9aB6sUzut
2d33YfNsweLCB8SvMSu+3ocwbVq+KLu8GfCmUIqIYftQVbDYB+jbQpGTia8pmt75
VIhfnLiBzdS9W9bMjzWeyqiQU+BgEROzOrc3Hk6AqxXktfDdWrVHhnptlvBzAsrx
5hGKs4xO6NEE93EHRUQ5O10chfiHMoMa2PlMFs4qHz+z2Fsj3F1DjOE625VdQZaS
neTYnE5ZapNJtWz2Mlbu
=DyEh
-----END PGP SIGNATURE-----

--k6SrlR5F+BMzH45x--
