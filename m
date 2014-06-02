Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaFBROi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:14:38 -0400
Received: from sauhun.de ([89.238.76.85]:47017 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbaFBROg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:14:36 -0400
Date: Mon, 2 Jun 2014 19:14:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        t.figa@samsung.com, arnd@arndb.de, Rob Herring <robh+dt@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/6] i2c: s3c2410: Handle i2c sys_cfg register in i2c
 driver
Message-ID: <20140602171428.GK2654@katana>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-2-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8kI7hWEHMS8Z+7/0"
Content-Disposition: inline
In-Reply-To: <1399706419-13976-2-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8kI7hWEHMS8Z+7/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 10, 2014 at 04:20:14PM +0900, Pankaj Dubey wrote:
> Let's handle i2c interrupt re-configuration in i2c driver. This will
> help us in removing some soc specific checks from machine files.
> Since only Exynos5250, and Exynos5420 need to do this, added syscon
> based phandle to i2c device nodes of respective SoC DT files.
> Also handle saving and restoring of SYS_I2C_CFG register during
> suspend and resume of i2c driver. This will help in removing soc
> specific check from mach-exynos/pm.c.
>=20
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Wolfram Sang <wsa@the-dreams.de>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: devicetree@vger.kernel.org
> CC: linux-doc@vger.kernel.org
> CC: linux-i2c@vger.kernel.org
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Shall this go via i2c-tree? Looks to me like it should go with the rest
of the series? Patch is mostly okay (only reviewed the code, not the
bindings), one nit:

> +	regmap_update_bits(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, BIT(id), val);

Hardcode the '0' and drop using 'val'?


--8kI7hWEHMS8Z+7/0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjLD0AAoJEBQN5MwUoCm2HgcP/A9XZJFA630XxvImjYAFPtk6
3vql4HguDLoCdDlv+kR7IhGt3SKtMwFeOZDvmOFhX7HMdvBsfhd1b/1suarQtCSZ
6AHCLmlH77i5LoeaflqLGWmzpxl0I/Frg28dk1aNBWk0fot2IlRzo4XFlqmCV4MT
DoUbAd9yNZySqAmyFm21y4p8+EJm6aW8eU7e1XbBCgWBlEtQVQlSUFG1/AY1MwOW
HNoV2f5AlpV3ZeaCDxWFy2H7/5QzZSIW/VseyYL/sAgRtYgdT4SIy/5cNBg+UvUs
cWH6Hzogu0tew87R1TZi6cSlq4pTZ4ZzhlHfvxzusqnsv6OZD7XKrxbePzQlyI0+
eNSDeBTqEiuRyw+LjaAMvx8k98TaJXF0MxEyrmtLpH/xrIr8vtfyNIk2TAoZhQmp
HvhHd5QwgahiHtd3MInQZ44+IUfQJX2E+bwWDLw4DhRpoLIAfIR+1cd+GG9yL0eR
PKPwsakTasrMCSp12zf5ewdhJgsDSZ5TBqQuaYev3Ff1k+YeQ6TEDIzpS27wtnPv
oBAVc0F+eyqulHAKjpWlmJOdizeVcF9qBERWeSf+Ca7voRQbUNF2knJph7fXpaW8
nKi9mP/jaLxI1a79YBQ1d2EoM8ZmDZe2cfOQY34DMyuyLMBs5/9VOfYsuocETMqD
CRanmYag61F7JjFdQzDP
=KCHP
-----END PGP SIGNATURE-----

--8kI7hWEHMS8Z+7/0--
