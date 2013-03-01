Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab3CAMob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:44:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47598 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab3CAMoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:44:30 -0500
Date: Fri, 1 Mar 2013 20:43:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, ian@slimlogic.co.uk
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
Message-ID: <20130301124350.GA25302@opensource.wolfsonmicro.com>
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z4ZSWl3cPHKQyRxO"
Content-Disposition: inline
In-Reply-To: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z4ZSWl3cPHKQyRxO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 01, 2013 at 06:04:56PM +0530, Laxman Dewangan wrote:

> Currently driver sets the irq type to IRQF_TRIGGER_LOW which is
> causing interrupt registration failure in ARM based SoCs as:
> [    0.208479] genirq: Setting trigger mode 8 for irq 118 failed (gic_set_type+0x0/0xf0)
> [    0.208513] dummy 0-0059: Failed to request IRQ 118: -22

This can't be a generic problem on ARM systems, I'm pretty sure the
primary users of palmas would've noticed, this is more of a new feature
isn't it?

> +	/* Change interrupt line output polarity */
> +	ret = palmas_read(palmas, PALMAS_PU_PD_OD_BASE,
> +				PALMAS_POLARITY_CTRL, &reg);
> +	if (ret < 0) {
> +		dev_err(palmas->dev, "POLARITY_CTRL read failed: %d\n", ret);
> +		goto err;
> +	}
> +
> +	if (pdata->irq_flags & IRQ_TYPE_LEVEL_HIGH)
> +		reg |= PALMAS_POLARITY_CTRL_INT_POLARITY;
> +	else
> +		reg &= ~PALMAS_POLARITY_CTRL_INT_POLARITY;
> +	ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
> +			PALMAS_POLARITY_CTRL, reg);
> +	if (ret < 0) {
> +		dev_err(palmas->dev, "POLARITY_CTRL write failed: %d\n", ret);
> +		goto err;
> +	}

Isn't there a read/modify/write call for palmas?

Otherwise looks good; I wonder if we even need the platform data though
I can't see it hurting.

--Z4ZSWl3cPHKQyRxO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMKJ/AAoJELSic+t+oim9teIQAI40mOVqVKiMT2mAL+91409Z
92MTwsu1h+w8Dbzt8CqrV84bF/IzQzZ8PI28sb+O15gRBSznr8i9kgakxnPaf/cV
H5fx8A2k+KQgN8cqQ+BJbtGDTMApIjHrsuENkX/+HN7s8FQHfAAMjgRnhEimNdJ/
Hm8NJ/jPGjuGyfgKMMwL+PL8JRvN7DEXWb4zsD0l74H25i3LWf9YSZKC6jYKoqlW
OwFvPEVPXZ4Pxn/CSPAe602TyxSZqK8ZIbKrEgZpacxJXJvcQAKOmy6UW2IWIpCZ
O9nd72G5X8elcDlLusDj9QwgzRv33cU+0xOfOh2rYEq2b1gUZVxPn9Kxz+ywdTlW
SDPhtjP34sTWOr4Fgnlcuvlyljlqiq8CXqu2JgVS1DXw+GSggzIThQlH5WpFugaI
VyDhgNeIEBP7hjMrc/a0X/MSHsonkwePnV9cht/3HKaknwLQBH18j4kFAVbT198l
qNeRD/XHjVFqasrpFlMHnAiPUzczYEGweqnt6ZmmfmNCvxGhgrn9uQBYCtxxpzo+
vB/HrsGelN04so6OVqV6eYwtUM4xRrRg5EhYv1oKlaYIbyFAOr6PnrAodK0gEx+M
8HwdCdljdgPwfxN8IF0qK90namT+klXx2ibZcm7i7NDOXegoYFZLZVxB+gMCQ+AY
3AqCz0/hh8XK0tj8CAUT
=tpMm
-----END PGP SIGNATURE-----

--Z4ZSWl3cPHKQyRxO--
