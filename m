Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195AbaGCOzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:55:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45039 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbaGCOzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:55:38 -0400
Date: Thu, 3 Jul 2014 15:55:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>, sjg@chromium.org,
        afaerber@suse.de, stephan@synkhronix.com, olof@lixom.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140703145517.GE410@sirena.org.uk>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
 <1403898973-19571-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0k24IdCjZr+ZpLJG"
Content-Disposition: inline
In-Reply-To: <1403898973-19571-2-git-send-email-dianders@chromium.org>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regmap: cache: regcache_hw_init() should use
 regmap_bulk_read()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0k24IdCjZr+ZpLJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 27, 2014 at 12:56:11PM -0700, Doug Anderson wrote:

> We really should be using regmap_bulk_read() in regcache_hw_init().
> The regmap_bulk_read() will translate into regmap_raw_read() when
> appropriate.  Doing this fixes problems where regmap_smbus() will
> crash because they don't implement .read and .write.

Not quite - _bulk_read() does do byte swapping so...

> -		ret = regmap_raw_read(map, 0, tmp_buf,
> +		ret = regmap_bulk_read(map, 0, tmp_buf,
>  				      map->num_reg_defaults_raw);
>  		map->cache_bypass = cache_bypass;
>  		if (ret < 0) {

...a direct replacement shouldn't quite work.  We need an actual
fallback to word at a time operation I think.

--0k24IdCjZr+ZpLJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtW7SAAoJELSic+t+oim9Jp0P/iS1DC0/Vx3EXyqk4/YYzvBg
nBc/YBTscAQB/kxHQPikZOAZSw0Vy40pxmQolVKCrgnBEGgmDnjqGv5rDRFepeqM
UGQ8dOSOkENaV3Q9eR6F+R6MYZvNgh9ghQJwnMHLkmytgP4trQcGJucqiOuNcSTd
eaP3VWSXYCUOfIciUCW7yTSCA4eAzaCUNtWKxebbnCb/7PHsMq1cRI/YYEJrlLZK
SSTwC/9f2/izyjJHj7qcyVHy7dHjq+XM1VTIiZK17+PRYU1NqlpgCSuohEXLU+b1
5vbcfhotuFa9lnl92UfEW4yr5/3TFZIDuHysRPmvr0TERjT3yD02CA2DEbcUOykM
0UhonlDiSKMRk44bCC0Gk7uZTvcSneOSoukKi94ewAyNtOCJarYSNtbD00y+spzg
zvIaeiZlGkxaG91Fb5dG/JVbvkuR8g6+FjP+kBqxg6sxRF/dCbbrhSQBANUIpzE3
WHk+RtMU9yWQinVqmsFPglX2/tPBBV3C+fE6nJfJRCWuvbUnqBFl+B8ToIEmoJ/B
malV4zzQvKEdntnn37ALYlN/npKC8bjdbru2Km3losaJrcgM4+jBwYDTz3Mbo59k
F3gibiaBCD8avpm90c/7oo0pyqvd3hYp9CuGsyNbOtjl4YAxLaLTDiLBK7tZiJDT
JqGIV/GcDjgYXcQlGGM2
=DfuW
-----END PGP SIGNATURE-----

--0k24IdCjZr+ZpLJG--
