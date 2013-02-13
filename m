Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab3BMOUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:20:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042Ab3BMOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:20:38 -0500
Date: Wed, 13 Feb 2013 14:20:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: irq: do not write mask register if it is not
 supported
Message-ID: <20130213142036.GJ5062@opensource.wolfsonmicro.com>
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
 <1360761290-15976-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7PTD44AewjTsiSV"
Content-Disposition: inline
In-Reply-To: <1360761290-15976-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7PTD44AewjTsiSV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 13, 2013 at 06:44:50PM +0530, Laxman Dewangan wrote:
> Ignore the mask register write if mask_base is not provided by
> regmap irq client. This is useful when regmap irq framework is
> used for the MFD's gpio interrupt support. Typically, gpio has
> two registers related to interrupt, one is for setting interrupt

Again you're talking about specific devices as though these are generic
things related to the class of device.

>  	for (i = 0; i < d->chip->num_regs; i++) {
> +		if (!d->chip->mask_base)
> +			goto skip_mask_reg_update;
> +

Why is this inside the loop?

I'd also expect us to return an error if a caller tries to enable or
disable an interrupt, or possibly to give different ops to the IRQ
subsystem, rather than just silently claim we did what we were asked.

--C7PTD44AewjTsiSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJRG6ErAAoJELSic+t+oim9SYsP+LoGuVwbiRkbhkJMopW6A+1k
r+yowmYSvOi2GPInvqdPT3mmxHGfxbsYIfwkcBMMBpDaQoo0lZ0mlgbv8a3yE3h7
ofj93/IxeR1n0ZsFS6H74ToTz1tQeTsiERAhjFM1TPvRK1Mg0+IE6j7q8YiHcK7p
anxEHqnaljWTB6tO/oIuIsQgnfnFdCcw3tpNYWhRfkJBiXLTfyH3IndZQr7TFT1J
9jr0t8XGObxJFvZsqWsfkUFSO56Ece8zSgUPtJjfj5tKvZmMokCQfr2cgeEND4cD
0SWcZqqPD+9CpUZq9yMD5w5BWLe1Zc4KZKMIlofVdbw1CWkqx2k2EeWnO5N9zKHS
DVDinLohgclmEVETCgpmC6uZG6ONjbi9xUom+smtWON1puZB41Tljrfw0ygy9DD+
nnSiljUf2eDku3LrF7SnNFlshvS0w8Fyp/M1H083ZzAaFuVwDnYrz6xDZls8+V0F
HqX0r71Nn/tYSd9pn1IUmQVgT8vopEKHTduYwAkTJbl+PN/wwXy7j3w78s2TvYfo
PpOvEdKDZwm0T3e7XzmIcU7tyjcmdMcAbXIhMvXbfBaWWdHMRYh1P/o/ZeFINbnJ
BswYdNihv8T1EQdBgaoSPjCTqiFv3LaxsF8Pmk8FnYDaYnMr8R5oTYTRgI1+xPFq
ddLlcc75+eVQx9QjsRs=
=PNOT
-----END PGP SIGNATURE-----

--C7PTD44AewjTsiSV--
