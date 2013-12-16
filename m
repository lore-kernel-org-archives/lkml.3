Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3LPS6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:58:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46993 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3LPS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:58:16 -0500
Date: Mon, 16 Dec 2013 18:57:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Anson Huang <b20788@freescale.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20131216185753.GN3185@sirena.org.uk>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nRwNdQxTdQ7rZk9A"
Content-Disposition: inline
In-Reply-To: <1387228827-933-1-git-send-email-b20788@freescale.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nRwNdQxTdQ7rZk9A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 16, 2013 at 04:20:27PM -0500, Anson Huang wrote:

> +{
> +	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> +	u32 val;
> +
> +	if (!anatop_reg->control_reg)
> +		return -ENOTSUPP;

In what situation would this happen and why would the operation be
provided in those situations?

> +	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
> +
> +	return (val >> anatop_reg->vol_bit_shift) &
> +		((1 << anatop_reg->vol_bit_width) - 1) ? 1 : 0;
> +}

This isn't terribly legible but it looks like it's trying to read to see
if a non-zero voltage has been written.  If that's the case it looks
like enable and disable operations should be supported since presumably
the register can be written as well.

Please try to avoid the ternery operator, especially in cases like this
where it's not adding anything.

--nRwNdQxTdQ7rZk9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr00tAAoJELSic+t+oim9CKcP/RJHX8FJfJrM7j40/kam9LMw
AzT43gcVXk8CAWQTY/1nCC9FEafGCwPnKVNZpuyyrDLdOeFwKcHoirSlWgJj/g7Q
1XsY7L686F7/14DajCrR6TvwVSs0K9rG4G0yyHaYgf/fh8Updc8UAXJ7cUc/hG5Y
kirO3xG4YWXPrv2hFnBiBtU9bL0DHv6EXQIn+4HxynvqEjGSUv6RJugHyQnOp71i
/OFeGsYP9AD8FchU5xczj8zL+n+rh4o0WrYaeRKGzDoV8HzkPpjNHpwaSFQJbilG
kI0X/g2CmQOVXw/croxH8/vnBqQlmJdlvliuIljjN9mJheyTYD8HERD2fyrIQX0H
4faN7vgx3Fmbov9EFccKsPmBgIuqIHJXOBhv1+VyVgucypJ9QbzZ5LctqqKJE8yD
bmYJjb3u/V11IV0OSsm2gInripppVgrisufgTL4K3V8ZgO+dnhab30S5FJKGQnw/
tfXEYQVlnHcKN7nXik2KEcokyR+ZX4mlL/c2bv85eKoSPLoRrUWWuU3EZ/o0UjA3
WcpV6vAxNfa7KBn3O8BBCg5+g3Ko2We5GQFvOFwtLYvsOtZQCvpmIIV3LK2Tb/7W
BzZj9/kTKkmAWs5JvsSmwCxzOqNTeiupM2A59+iJGI3Scyrnv0SMnGpRPaKaMG18
UXV10qBqAYwBVXFpHys1
=IRwD
-----END PGP SIGNATURE-----

--nRwNdQxTdQ7rZk9A--
