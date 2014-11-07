Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaKGK3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:29:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48094 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaKGK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:29:32 -0500
Date: Fri, 7 Nov 2014 10:27:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, lgirdwood@gmail.com, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        jonghwa3.lee@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com
Message-ID: <20141107102752.GC8509@sirena.org.uk>
References: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
 <1415328727-16245-3-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wrbmJCjDMpeEYJph"
Content-Disposition: inline
In-Reply-To: <1415328727-16245-3-git-send-email-beomho.seo@samsung.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.192
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: rt5033: Add RT5033 Regulator device driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wrbmJCjDMpeEYJph
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 11:52:04AM +0900, Beomho Seo wrote:

> +static int rt5033_regulator_dt_parse_data(struct device *dev)
> +{
> +	int ret;
> +	struct device_node *np;
> +
> +	np = of_get_child_by_name(dev->parent->of_node, "regulators");
> +	if  (!np) {
> +		dev_err(dev, "Failed to get child node for regulators\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = of_regulator_match(dev, np, rt5033_regulator_matches,
> +					ARRAY_SIZE(rt5033_regulator_matches));
> +	if (ret < 0)
> +		return ret;

Please convert this to use regulators_node in the descriptor to match
the regulators, then you don't need any specific code.

--wrbmJCjDMpeEYJph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXJ6oAAoJECTWi3JdVIfQUkoH/ifR7qwAjlZHw8+a1r4K0rQF
100JcX1rnNiWYQx5zXGCcFPkFz2YRKhSgE4Qxis50AjeZD3kAyylg4W7u6C3IQqs
aoXGfeRk/G8KhuFVwrvN36LOcLiF3vPj1iAgMYVZCoDSnX586eW8570zrTXv55xu
eBkLj8esRI/2Zc565QDdpNVTa91JpB960jXsvKk2M2uBy+aLsWGWnEqOQEbMd3zI
FmaxjkI16TD91xB8ExH4PFDGjeYTo3/Rvsc53S/NanoMot2D1rlUZTSeqiAbP3DC
tA2oLNjfqbJ4RM29dgUzwIRe3j03hKYMsKnUzNODt1MoHj3QQ3/gf5HZ3L0PK6c=
=GEe3
-----END PGP SIGNATURE-----

--wrbmJCjDMpeEYJph--
