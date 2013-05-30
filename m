Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3E3Ld3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:33:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3E3LdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:33:23 -0400
Date: Thu, 30 May 2013 12:32:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lgirdwood@gmail.com, ldewangan@nvidia.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, ian@slimlogic.co.uk,
        balbi@ti.com
Message-ID: <20130530113247.GI5180@sirena.org.uk>
References: <1369911393-25747-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IbA9xpzOQlG26JSn"
Content-Disposition: inline
In-Reply-To: <1369911393-25747-1-git-send-email-kishon@ti.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.128.224
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IbA9xpzOQlG26JSn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 04:26:33PM +0530, Kishon Vijay Abraham I wrote:

> Only compile tested. Just sent a patch to get some comments
> /ideas on how to handle such one off regulators.
> to handle

What's unclear or confusing?  This all looks really basic...

> +	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
> +	reg &= ~PALMAS_SMPS10_CTRL_MODE_ACTIVE_MODE_MASK;
> +
> +	if (mode == REGULATOR_MODE_NORMAL)
> +		reg |= SMPS10_BOOST_EN;
> +
> +	if (mode == REGULATOR_MODE_FAST)
> +		reg |= SMPS10_SWITCH_EN;
> +
> +	if (mode == REGULATOR_MODE_IDLE)
> +		reg |= SMPS10_BYPASS_EN;
> +
> +	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
> +	return 0;

This looks like a switch statement and isn't there an update bits
operation?

--IbA9xpzOQlG26JSn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpzjcAAoJELSic+t+oim94D0P/AkS3CxTPS5tMWqmXyU8n8XE
m69NQW52WOsNdRaDDKjgL7LA68e+266wZVoVhu3O2GJOwja+XAG0wIOfzWW2eEOO
WYDJiDk1HNDRec++WKtN6gx/pW12NJmDqCjnYZ4EDmBaZp/b51elBIVgLrHTsUVt
xuEUYx/yAomjdPH+j5tZwMueO5wJAPUh59o3iNxxb4C9wgEW7Py5dUVNjyjCFcWq
KG3DjdjNikK5OjG1QTxcQLZScqUg0lvhImYeqheJZuh/sG08WZ4lWo+AM8YSbTpY
lMu/Q2vbTnNkWyV798mT3Hmj/wBEtnPC54HnWaWMXsH2REfd10D7F7o+628AH/MF
cgD11OVjWJ4LKUvYp7RPZcOOHCh2BbiIeDPKK2NcoFSLqp/TioBkj9jCvByuSXeH
kcGEJzMT6noF3fkmbCwt5+q6EnrcVu8eFvj98F6hLRDwSns7lEnlK2gAHa0Z4lsD
RYNYp6a+NO9MuYxAYFytENFlXnJEcrQarugyYel69MbDrXBvPqUQ2ZpH1+P4bwTx
Ul0D/ADZINZDloKu1AWYHmIfTFMQvYZsavTYdbONJQlUCuxsDMRC8+5etlQsniWM
B1gIFjWEPh+Q6r/RjPog0h0xvZL/IzesE0x+pdZoLWMPOyL/FKy1w+UOTVHsvG/m
J84GzZw5pSbTxGAO2gqD
=TOHw
-----END PGP SIGNATURE-----

--IbA9xpzOQlG26JSn--
