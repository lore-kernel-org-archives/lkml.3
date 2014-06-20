Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966607AbaFTKQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:16:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50381 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965500AbaFTKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:16:41 -0400
Date: Fri, 20 Jun 2014 11:16:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140620101618.GU5099@sirena.org.uk>
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
 <53A308C8.2070004@wwwdotorg.org>
 <20140619175643.GR5099@sirena.org.uk>
 <53A3C613.8030207@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncfrQ09dBbS73TfA"
Content-Disposition: inline
In-Reply-To: <53A3C613.8030207@nvidia.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncfrQ09dBbS73TfA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 02:26:43PM +0900, Alexandre Courbot wrote:

> So I can see three questions here:

> 1) Why does _regulator_enable() on vdd_1v8 return 0 while everything
> suggests that it is enabled (this regulator powers lot of devices, like
> eMMC, which are working fine). This may be an issue with the palmas driver.

Returning 0 is reporting success and you say it is enabled so I'm not
seeing any contradiction here...  or do you mean regulator_is_enabled()
here?  An always on regulator should report that it is enabled.

> 2) When an always-on regulator that is not yet enabled is registered,
> shouldn't it be switched on by the regulator framework?

This happens during set_machine_constraints().

> 3) When a boot-on regulator is registered and _regulator_is_enabled()
> returns contradictory information, what should be done?

Same thing here (same check even).

--ncfrQ09dBbS73TfA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpAnvAAoJELSic+t+oim9BkwP/37LtNgu5Src16mIeQcafYF/
dpONEBPZyXaV3K+Oxg5PuanPNN+VaSi3LxQoDYMnXYq4TC1VbzDk6Hpb4Wi8dAJL
0BpVRX2mhOvNL5x9DmE+Dt1JrNIeTIuLqDjZXKx3li3dfRUsStSd10TA2z6TbMT4
B4tW8YSgep+Nfd5xngw6+6AFRNNOlMG32EsRtgkACdvwkQZoRowl0jAis3z7C1N+
3Q6A61KApTvV2NxqkpUa0ny1gqWtd7lEstc4OLlvJDw+gGzJK/oTQp4haz6ITCnT
NXpeJkJ530g6+H08r0ex4dy2WyEpmssXJobFL0ASIDh/2wImTBxag6rQ2KZ9Pfjf
ur8N4M4GGLBqukWiU/8hGPsncm+lXjKe5INDqyYKCBTLHzExAE8vBDrAW4cxzQQH
ykDEmLHzA860A0rVyZXkp/DoMNPek8Bwzg/pT4cO+4o1OA1XYCNzXOs1YajAGvtR
VjWL/EWV22hwf7GFgw2VG5mjq0/GsmOzJwVZqyRiDFCipu8hhTv59t3WVA87L3EB
87oMhTNgQjOgAQ67R2k20sTpUb/43bnbX8QQoGcyoD3GmuZDb3T0l1niMhMtxcfn
D7a4lqXByHk14Gf0PVNkZuJJGBVqI6uXIu6o5v8DT9k+nWjs3/zrT5WLo+r2srfD
1zU+OfsUn83vqnOVOcaM
=2SD8
-----END PGP SIGNATURE-----

--ncfrQ09dBbS73TfA--
