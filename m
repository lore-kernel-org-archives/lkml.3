Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3LKN1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:27:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43597 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LKN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:27:34 -0500
Date: Wed, 11 Dec 2013 13:27:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131211132729.GT11468@sirena.org.uk>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wYXww9TlNKyqAMAe"
Content-Disposition: inline
In-Reply-To: <52A7C0C3.2070805@codeaurora.org>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wYXww9TlNKyqAMAe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 05:32:51PM -0800, Stephen Boyd wrote:

> Are you suggesting we implement the reg_read/reg_write as global helpers
> that the config points to and then call regmap_init()? At a quick glance

Yes, assuming your bus really is limited in the way it seems from the
code.

> it looks like we lose out on regmap_bulk_read() if we do that. There is
> one driver that will use regmap_bulk_read(), but I suppose we can just

bulk_read() should decay to individual reads if there isn't a block
operaton and it's not like the hardware actually supports bulk reads
anyway.

> With use_single_rw I think it can be this.

> static int regmap_ssbi_read(void *context,
>                             const void *reg, size_t reg_size,
>                             void *val, size_t val_size)
> {
>         BUG_ON(reg_size !=3D 2); =20
>         return ssbi_read(context, *(u16 *)reg, val, 1);
> }

Right, which is a lot simpler.  Though I'm still not sure the
ssbi_read() interface is the best.

--wYXww9TlNKyqAMAe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqGg9AAoJELSic+t+oim9gtkP/jZJaOmpvEOoKU1CEiOBeZDY
yevv2WBQPb3kCtJl/Vh/Ppf1LcvN7s61HVrmzub+dsJONPOndxMJXu4dcaxhAkfR
zRC6XNg6uKUNSI73UrvUZZFoKxWCRtV+NiR2xLakHg0zuyIRUwh5Gdc9L89lT6FX
VmHGrfEEleygZhpT3GVzcr4QjbaFlWwbjuDyXNiFrNFtpxCWjvRPyHjVsLilmFzR
x2FyVt+h8C3VLmBlou96lZNsR6tDlp37iFw/E6A5zY35kcMhP8kUuWm3rRATqCl8
enf9NKYJXkwApQvA03EO9a3m4bZQNh3c5b+/3cdGqQV3xhQ5psv+NIgD2GejqL01
HQz0ioJ8MxbsyvPyj9tXvHDB/5vN5pZnvY1I0Svqh8q9eSbpu6uBOMuPgCmoodRj
JkwHRHTCCJ/zxjKArwoIX8RTYt4UtpjIYpTuRQbb5FxSDF1ELGE0ukMBgLxd5Fc1
vDfp2ozU1c42+8WUoZIvTJ96eOITUlog3CPHbcIboCIvl+yD2wYuO0wBGpK+Bzhm
6amwzh2J7gx5kxXBjPan1h4onWaDozCnFEobmdxX5xIFm4X0teIlHHZRecWTPO/3
xRGT7y3khtv0z+TuFyoIxg1oDlB7776WAzJH2zRsb9WvoMXFCVmwz0cXHenRCavz
3WObx0fypeVYBnt5yIQV
=VJXh
-----END PGP SIGNATURE-----

--wYXww9TlNKyqAMAe--
