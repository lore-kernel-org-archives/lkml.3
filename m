Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713Ab3BNOnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:43:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35347 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934172Ab3BNOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:43:09 -0500
Date: Thu, 14 Feb 2013 14:43:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regmap: debugfs: Add a registers `range' file
Message-ID: <20130214144305.GP13249@opensource.wolfsonmicro.com>
References: <1360845104-30392-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wg9FEZT+WCTrEXgJ"
Content-Disposition: inline
In-Reply-To: <1360845104-30392-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wg9FEZT+WCTrEXgJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 12:31:44PM +0000, Dimitris Papastamos wrote:

> @@ -96,6 +116,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
>  				if (c) {
>  					c->max = p - 1;
>  					c->max_reg = i - 1;
> +					c->reg_attr = regmap_attr_bitmap(map, c->max_reg);
>  					list_add_tail(&c->list,
>  						      &map->debugfs_off_cache);
>  					c = NULL;

What happens if we have three registers like below?

   X:   read, write
   X+1: read, write, volatile
   X+2: read, write

It looks like we'll not flag X+1 as volatile, we'll just take the last
value we saw.

--wg9FEZT+WCTrEXgJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHPfiAAoJELSic+t+oim9cKgP/iGhkGr+41XkijgD8sWDeQtm
JKqbTuo1HRK8aUaa0e6BhJiEllNp2Qk+lFN93lEg8c9SnFoLF1tfUr6kxiaK5+o5
cnS7n74BY9f9oBs6VYz0F9y/RpJmSaYydnFHAYvnOR3gKkmmXawHsTZoWHR6V+0/
YuohpBxKRdhPZyhh2C3LVBPmksfPa6Htf2oN57JF1BB3lMhtFLS4J5ceFRiJA8RD
UeUhSuzOg3HGQk7swJNuzI7uFY5ZAD5t9Z1OAD0+DZvxedGKnJURddobwH6sa+/h
GttOWCsR3JUhjZhmrpgOJ4BPSUH78zedwQgkEuG2+pAyfG/m/7xke+GQTt6OsfQv
E1iiScVEAhzEYpudhbNEpBq6NftCX1Nfw50oiTjh/aMPDO97FciImyzQIqU4Q+iY
TFqmFRXOHRMnqO+eqxyUXMqkpdZ2241YxysYFc3fx/VIxpVpEp5oLOZ+FUO/yKB8
gdAmo4lyTMwqQn61PQMGfH1wZ1aE3lJ53p/1+F6Nih8s3NnUf3LbwZI52LLRCSgL
JvQElMSuBiq7XoEmTHbJ5w1jYxT3LeY3lXsRVdXFhKxzkjrVzfmPlQZsir14xGm9
b4JDojCJan1efu1An+O6XqzvkrMJ8BkuvCOZKfMsy0Ro2lyBeC2fvFT+mRGL/fQl
MWKr2vHnMK2DF91zz2jU
=2dkl
-----END PGP SIGNATURE-----

--wg9FEZT+WCTrEXgJ--
