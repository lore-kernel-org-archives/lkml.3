Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3DWNpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:45:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40909 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857Ab3DWNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:45:16 -0400
Date: Tue, 23 Apr 2013 14:45:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Taras Kondratiuk <taras@ti.com>
Cc: lgirdwood@gmail.com, rjw@sisk.pl, viresh.kumar@linaro.org,
        shawn.guo@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philip Rakity <prakity@nvidia.com>, Eric Miao <eric.y.miao@gmail.com>,
        "grygorii.strashko" <grygorii.strashko@ti.com>,
        Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Subject: Re: [RFC PATCH 1/2] regulator: core: Add regulator_set_voltage_min()
Message-ID: <20130423134512.GL5019@opensource.wolfsonmicro.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
 <1366372554-20866-2-git-send-email-taras@ti.com>
 <20130422131904.GL30351@opensource.wolfsonmicro.com>
 <51756A21.3020405@ti.com>
 <20130423084838.GB5019@opensource.wolfsonmicro.com>
 <5176743A.9070201@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7vAdt9JsdkkzRPKN"
Content-Disposition: inline
In-Reply-To: <5176743A.9070201@ti.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7vAdt9JsdkkzRPKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2013 at 02:44:58PM +0300, Taras Kondratiuk wrote:

> GPU voltage is regulated by some devfreq driver.
> CPU voltage is regulated by generic cpufreq-cpu0 driver.
> Both drivers know only about their operational points.
> They don't know anything about chip limits.

Clearly at least the lower bound is known to the drivers...

> I see two options here:
> 1. Pass somehow chip limits to drivers so they can limit their request.
>    Pros: No need for regulator_set_voltage_min()
>    Cons: a) Need to pass info about chip limits to driver. New API?

Why on earth would this need a new API?

>          b) CPU and GPU may have different limits,
>             so after very first request voltage may violate
>             CPU or GPU range.

If the CPU and GPU drivers are trying to select incompatible
configurations then we really ought to be detecting that, ignoring it
seems like an obvious failure.  There's a bootstrapping problem but
that's also an issue with specifying only the minimum voltage...

> 2. Define chip limits in Reg X constraints.
>    Pros: Limits will be applied to driver's request transparently.
>          No need to pass info about limits to driver.
>          Limits are set before the first request, so no violation.
>    Cons: regulator_set_voltage_min() is needed.

> IMHO option #2 is better.
> Do you see other ways?

Above you clearly say that this is all modelling operating points.  If
you're doing that then I would expect the drivers to be talking
operating points to an operating point abstraction.

--7vAdt9JsdkkzRPKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdpBgAAoJELSic+t+oim9YbMP/A4f4LzAN5ciPaE3kuL3aAfE
ucvHyWpKUlJZYdoes3XmN5bAet2CLiCli9jhh5T/SVVzaJCOLuaVT9B3a/QMjyA1
XdZ3zIbYGF5gnaLdVKEIeRriyKg/mnR7S7eabOL6sO5ri0kl82mQ0VG6hLFvXbeq
vwj+YKexWmbnYsC5P7ghnsg/m2z7r3FnOHjIMuXJHrmTkkNouQ1G0emvpwVHCNjB
M2ZFtIDx8hAje9tbmA2eBLNqRykN2df+fPE+6dVejas/43X10qya32gfqKiMLFz9
RTXqhoPeHY5AN74TdfRZhj3mXWIkDGXAAKRVhsbGxh+PgUz1O7hQ0KL/xgo3Bd+p
d9LKyd4q1TTGdr+FIyKjct8mQPPJMqJt6HZ0l9J5KfXViFuQvpUtnGiYOzdjuA2n
+GkDBZi+SGy2qWTBeW0SsRe4NKuhuDKchIlbx2KMMhpbN+9X/zrSctL91kwEah6y
eVty6mc5KeTcXEfnxbkoDL95aloQc6jGC8SHyM0mByLgHn56S+ITffxkvO7tjISr
ta/lZvm00M4TDmpn8Ho8KyjCzklwn/9FBJSbxLIqLy+pYdtxcVi4Uznyoe50LrsX
Iu34UioTXBbP9Ht2id6qdRBo9g53q5AZyKfj9q/fZxQTrE6tCQnJpco51w6VM19Y
Lxw+JIFky6UnJELh5ay5
=Ey9Y
-----END PGP SIGNATURE-----

--7vAdt9JsdkkzRPKN--
