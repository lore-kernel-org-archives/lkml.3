Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaDPRHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:07:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35233 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaDPRH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:07:26 -0400
Date: Wed, 16 Apr 2014 18:06:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140416170638.GT12304@sirena.org.uk>
References: <20140415223849.GJ12304@sirena.org.uk>
 <1397636170-664-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HL+2C3YiDdBCOf2R"
Content-Disposition: inline
In-Reply-To: <1397636170-664-1-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: i2c: fallback to SMBus if the adapter does not
 support standard I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HL+2C3YiDdBCOf2R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 10:16:10AM +0200, Boris BREZILLON wrote:

> +	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C)) {
> +		return &regmap_i2c;
> +	} else if (config->val_bits == 16 &&
> +		   i2c_check_functionality(i2c->adapter,
> +					   I2C_FUNC_SMBUS_WORD_DATA)) {
> +                config->reg_read = regmap_smbus_word_reg_read;
> +                config->reg_write = regmap_smbus_word_reg_write;
> +		return NULL;

This all looks good to me except we shouldn't be modifying the config
struct (it's supposed to be const).  We should instead add the ability
for the bus to set these ops - that'll also be useful for things like
AC'97.

--HL+2C3YiDdBCOf2R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTribAAoJELSic+t+oim9yDgQAJViSM+NIbZRXB90eCTbZ/8Q
Dm0fn8vsZRzliPmp/BIBrfhYJPn7817gxiwOpiCO1D1+UJYUTBywrMmXr3RYYufS
USrkMfz8ME4IUrI2ZJ/61b2Vy3AIl8/EmvW+Uuz/q4a4V+LYZ3j5F1HU0huxYbda
m6dbAxW3KDMuVp727jYp7UQNQct9/KBUU/+xFDW1+H9wX1Adi/GDugSPVnSMBNfG
JSdQOJoxbz0VosemoTKoMymkSb8naIucTP21SQSnZaFj5YMMAQo1FF28q+aoXcsL
RYLX3Win9vkIL+gBKBZdf43JsUX5IWLubYYdPgTax5Y+RtvLHnE9qF0891z4/jXs
YkRr29VX3Dx/swgfvXEoMFTRZcb7dmcAkQdFpoB5dcztWTLODJ/imQ32ZKDUZUxV
QJSlG0B2w7cAHaMhjig5+0lvYP3f1KO8Rip9HG2c8wAgoQyCiNWBwrNDgKPq3wCh
sJqg/+iv+YJSe+E40UdLg/+vaX8PyqZjTm+TFufPAgOHBvXsAKRjPQRT6qbrLA9I
B/o9/6gE2y7h3j5K1DVMBhJpjASMeLdx1iPc844VF4OWBDF0sj9vZp7BxyElllUS
CvIngmIBO0CiBi9H+BLlVCC0GfW14JWouiykSdXJk0CSZnmg02RSTJQFwoSfRQMm
aR6xf/inPyVVhQuEdaiA
=XB/3
-----END PGP SIGNATURE-----

--HL+2C3YiDdBCOf2R--
