Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab3CMMBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:01:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36903 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab3CMMBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:01:36 -0400
Date: Wed, 13 Mar 2013 12:01:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Cut down on the average # of nodes in the rbtree
 cache
Message-ID: <20130313120133.GN25610@opensource.wolfsonmicro.com>
References: <1363175623-2716-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gWRamliw218YCZO9"
Content-Disposition: inline
In-Reply-To: <1363175623-2716-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gWRamliw218YCZO9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 13, 2013 at 11:53:43AM +0000, Dimitris Papastamos wrote:

> +	for (bitmap_size = 0, i = 0; i < map->num_reg_defaults; i++)
> +		if (map->reg_defaults[i].reg > bitmap_size)
> +			bitmap_size = map->reg_defaults[i].reg;
> +	bitmap_size++;
> +
> +	reg_bitmap = kmalloc(BITS_TO_LONGS(bitmap_size) * sizeof(long),
> +			     GFP_KERNEL);
> +	if (!reg_bitmap) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	bitmap_zero(reg_bitmap, bitmap_size);
> +	rbtree_ctx->reg_bitmap = reg_bitmap;
> +	rbtree_ctx->reg_bitmap_nbits = bitmap_size;
> +

What happens if we don't have any register defaults?

This also needs a clearer name reflecting the function rather than the
type of the data.

--gWRamliw218YCZO9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQGqWAAoJELSic+t+oim9OpMP/RHskue6qgkP3VHrbeGYwgOr
mspXdIAd77ob9WcfWcPgGe9AY+zzqg2mGO78sNE0Hz2SgPO5IT2pPsTS26LCc+uc
2M5d4kamQG6GYgcXT5vfm11GSG3d7p0YgNB8TDvnlpyAMRLsXS+7hOICWi0dCMIO
v70QTP+vndKe/1RQeZPae6xKu9F69RGfFLKjIO73SxQtv/igiDUtey9ruVxsqpmp
Zd8EVJ/FDGxZr7je+XIEsvrnQdDREZua03SDEhqIgL5zizfcELgx82ejJwP/tg03
rQqwaNeFkCVGcAvGeKE+37VFn7abwSABfvlu3mx6GcEw11Fs9DGDJOrF6b2Ls2Ku
GvEh9gVSa1/UXS8bhDFfOattV6tcaZ4bHGp4mtx7KnoGhA9Vfs9VfCimXcu3yoJw
GayZzShcuxGNEmXTOgM4FUYHOSdnEtmryUyzP5f+TC2YAZf0Zxh21j1ZykB5IazL
/9jmfFXXOJu7w4ch9XrOMuIEAulFc2HaYeta6hgt777/1o9266DRlvS8619leVe7
NRR8qo8IO5ClREtAVnpD8OtzFKyBzyRKCPPdgaiDMM8wPaVaBEeE6o+c4q81gE3f
C8g8QxExixKUK4EiF0o/s+5mXh6WoEzP2dNjxr1vzB4yEUMOrrqQd5QyN1/J00cE
KOGDqB6hRqa/I9Z8UA44
=zfmg
-----END PGP SIGNATURE-----

--gWRamliw218YCZO9--
