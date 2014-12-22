Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaLVO2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:28:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44010 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaLVO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:28:41 -0500
Date: Mon, 22 Dec 2014 14:28:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222142802.GU17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <9699e11a566938b8d1821f9be3df3276d57cd979.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CYcXvPfqKSDi0QhV"
Content-Disposition: inline
In-Reply-To: <9699e11a566938b8d1821f9be3df3276d57cd979.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] ASoC: dwc: Add devicetree support for Designware
 I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CYcXvPfqKSDi0QhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 04:18:08PM +0000, Andrew Jackson wrote:

>  	if (IS_ERR(dev->clk))
> -		return  PTR_ERR(dev->clk);
> +		return PTR_ERR(dev->clk);
> +
> +	ret = clk_prepare(dev->clk);
> +	if (ret < 0)
> +		goto err_clk_put;

This isn't adding device tree support, it's adding use of clk_prepare()
which is a separate change and is normally better done by converting to
use clk_prepare_enable().

--CYcXvPfqKSDi0QhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCpxAAoJECTWi3JdVIfQnIoH/3TX0VwA90dSlaGB+Beh+Sld
t2FE+Ztj5h+elSIOKE9S2eU0BmnDWT80Vp3RXeV+blAs0juhbRx7H4IPI2pTywtU
EQf8K+R2nuXQ7eCjLCu2+sT1I4S/7QgzrBbcld7xms1OxNvXbW0EC6wuGYlyCref
HLSNu8gB0f1lN/MVbQJeg7GihCvXvScvVhgseXtpRScHzettwbDqvFm5FDnv00OG
l8M5RDpXZYLMwQ/J//EBW31+eEe7Dw7I5t3DxQInBwGm39u5gC15jOA4ueFV4koV
Ff01bBed2f+w47o885FN7lsdAHnoZiGcHwg1Z+++kqjOswfVn9yxYp8zpaGQMO8=
=HWsU
-----END PGP SIGNATURE-----

--CYcXvPfqKSDi0QhV--
