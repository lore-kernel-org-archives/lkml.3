Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3IWIf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:35:26 -0400
Received: from sauhun.de ([89.238.76.85]:55999 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3IWIfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:35:24 -0400
Date: Mon, 23 Sep 2013 10:35:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 8/9] of/i2c: Resolve interrupt references at probe time
Message-ID: <20130923083509.GF3051@katana>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-9-git-send-email-treding@nvidia.com>
 <20130923073451.GE3051@katana>
 <20130923080230.GA11881@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcvBIhDvR6w3jUPA"
Content-Disposition: inline
In-Reply-To: <20130923080230.GA11881@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JcvBIhDvR6w3jUPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > This function should be in the CONFIG_OF block.
>=20
> I'll argue the other way. I think that the whole CONFIG_OF block should
> be remove, or at least be confined to public functions. The reason that
> I've chosen to do it this way is that the i2c_device_probe() uses an
> IS_ENABLED(CONFIG_OF), which will evaluate to 0 if OF isn't selected
> which in turn will cause the compiler to throw away of_i2c_probe()
> because it is static and never used.
>=20
> The big advantage of this is that we get compile coverage for these
> functions independent of what configuration is built. The same could
> probably be done for the whole CONFIG_ACPI block. In fact I volunteer to
> provide that patch if I've convinced you that this is actually better
> than sprinking the code with the #ifdef blocks that make it harder than
> necessary to verify that the code builds in all configurations.

Yes, you (easily) did :) Still, I'd like the of_i2c_probe function
near the other of_* functions.

Thanks,

   Wolfram


--JcvBIhDvR6w3jUPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSP/09AAoJEBQN5MwUoCm2GHIP/Rhq+fgMMs0+9m7uXuoeEaO9
GCTFoirPnLRiofGgNSrMjCIxiGJ7zFNaRMdieA//chsY1342PuSLfuu0PQRB7V2s
XWjj/XiJSMvPT1JNv+b2GTxq5QQOcRDe72ucCFR2Qziq4qp2lAs5Rn54W84sB7tV
/DHa7vjfqf87HebvQDbilHWH60rn5Jyxf0uCY/hUKjd0kwYPAff4OlaaCsrT91Zx
7ydlgVflCzouIoRMWr2uYFQy/jXeptw5YogFnMghc/f0UN1kbaN6bxUVfUxb2Apj
QW+6TllRVOl+bug8Veuj16nYPrVN2AHEYo/l0HWxBWWxsGS0oPN7qaBXim+UZy65
5kdy1G50J+bWIpKOuicL96/lWyGR9CqpB1UDbT+X1Nbt3ahRJtUTk67vqBHc0aDF
MIdjbGdOqvXVOJwwJ4axYTK/sEIimMC9hyXEokRDTrmqmsXztKCtwbjhqmNnd4Rq
pahY0/vwIrCdZLhPjCEA1Q2J0vosBfMCo+c/Q3F85r7huKTU1Cz8ntJs60LU6jqX
2yS36m3vv0amhpBbubds7KI+3n+sZ15S+gP+PxMDf3F9e+ucNFHDb+HaTbcrG3jR
zI1vtkMW+DCgIMy1Gwd2UnVNuHvSHNjsy3VhVwBf79hb0WT3uog4LNz4BBUhLozt
U52AUCw08/dP31WArXz3
=PD8g
-----END PGP SIGNATURE-----

--JcvBIhDvR6w3jUPA--
