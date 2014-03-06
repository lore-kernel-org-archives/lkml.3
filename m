Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaCFJkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:40:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56759 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaCFJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:39:58 -0500
Date: Thu, 6 Mar 2014 17:38:26 +0800
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Message-ID: <20140306093826.GO13126@sirena.org.uk>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
 <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rFSlBLLTJNJAtsmM"
Content-Disposition: inline
In-Reply-To: <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: s2mps11: Add set_suspend_disable for
 S2MPS14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rFSlBLLTJNJAtsmM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2014 at 10:22:52AM +0100, Krzysztof Kozlowski wrote:

> +	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &data);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Don't enable suspend mode if regulator is already disabled because
> +	 * this would effectively for a short time turn on the regulator after
> +	 * resuming.
> +	 */
> +	if (!(data & rdev->desc->enable_mask))
> +		return 0;
> +
> +	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> +			rdev->desc->enable_mask, S2MPS14_ENABLE_SUSPEND);
> +}

What happens if the regulator gets enabled between this being called
and the device suspending?  I'd expect this to be storing the state and
then changing what gets written during enable and disable operations (if
the hardware does what I think it does).

--rFSlBLLTJNJAtsmM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGEIOAAoJELSic+t+oim9TOUP/i+DD865maN6WMNSHgCEM8hE
hwZbTEVcrt+nccMGSJbm8+YVC+H+jwmOD9TVJGaSNZOgNESz2vv6YKHPY7ZkzLzK
3feL4ABIaKd55UfDzd/CNiAHLVaj7vvcL6jMAV+K0UfQSaaqUBEWgRwPuizqB5c0
pYCfuKXZVGlpGXvxW50b52kDCxh12XctgwfrhHoe+0xnOLq3pHg2CsU7NEna+bII
Fh5FhKBoFElnX/NLVWwR8q8kmJ1nVdJfmBUE4lxIuRI4cwoF9WvmHRIWS+XsLz0k
k8qGsYc6FEymJ315QtwTBjocFkz3GlK29KRNyFJrc300e/CYYSxnEHw4G1UNis/n
DgUGq5xTrJcQotVqGtz5l+mf3WF8De++Ho/w+ESaF/YiXxnqwvRggSIQ356kEUpj
7obdeDu1wTuqCQH6NZm6UJElxqIdBVdapZAeenUWEAxFR7rbl9gpYoZGZVoZA+HJ
xl6hH/fvSledzqypAZuHvF70FSGmZGNJhTvPYDRzO6a0ptzHQMU37QKva6NI3vRj
lms0VnpMIG01vNT02mV96vevdp+9/1lkibDRpQuzyMobgWm6XY6jtk2U5DazenLP
29hX7yR32D9CR8dIpIgIZKIX9Vi6XmPhD8gPNPt98RHfvD1L/YgOtF+FeLem0+x0
aQjhO8jBTVAmOj/q/kIH
=qFKo
-----END PGP SIGNATURE-----

--rFSlBLLTJNJAtsmM--
