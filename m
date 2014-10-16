Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaJPHbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:31:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57549 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaJPHbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:31:03 -0400
Date: Thu, 16 Oct 2014 09:30:04 +0200
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org
Message-ID: <20141016073004.GL27755@sirena.org.uk>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rZqMZkSWbCsTbv0S"
Content-Disposition: inline
In-Reply-To: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/atmel: add support for runtime PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rZqMZkSWbCsTbv0S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 09:49:20AM +0800, Wenyou Yang wrote:

> +static int atmel_spi_runtime_resume(struct device *dev)
> +{
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct atmel_spi *as = spi_master_get_devdata(master);
> +
> +	pinctrl_pm_select_default_state(dev);
> +	clk_prepare_enable(as->clk);
> +

This looks mostly good but you should check the return value of
clk_prepare_enable() - it can fail.

--rZqMZkSWbCsTbv0S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP3P2AAoJECTWi3JdVIfQ1soH/ji3X+lBjzBCGY6dwXmoNGFA
INg1NCR/ciwMN9xnOyFdsVAC4m3WtKM32D6SiCN/fDtoyj/e556rA6QmhFa+Iai/
Ig+kRUPbyfmTjdYEdAUPWTDjZkl8k1nU2kvWD1NavtyKgb+whnoDiWLeYZWRZ3ae
q0PB31lgfSr29QgshX0o9/qH70SwmFR44pvSvxJli3LI+WkHrZNU2mXRoVN7uzrk
GmBlOLKEAjriX3OSVLLwXen0eW2Pz6AInKmMLoL+qEZp5qZyDla2lTweuwcqoXtP
vPx5Uupn1ulW/1vvnEiZctC5GlS6ICaE6RczA0l4SmD0Dm/XQfb14PjjXq47bCw=
=4i7c
-----END PGP SIGNATURE-----

--rZqMZkSWbCsTbv0S--
