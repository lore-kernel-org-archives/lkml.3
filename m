Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3FASwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:52:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38894 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FASwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:52:15 -0400
Date: Sat, 1 Jun 2013 19:52:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130601185204.GF16790@sirena.org.uk>
References: <1369931042-9755-1-git-send-email-vinod.koul@intel.com>
 <1369931042-9755-2-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R6sEYoIZpp9JErk7"
Content-Disposition: inline
In-Reply-To: <1369931042-9755-2-git-send-email-vinod.koul@intel.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regmap: fix return of uninitialized value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R6sEYoIZpp9JErk7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 09:54:02PM +0530, Vinod Koul wrote:

>  	struct regmap_debugfs_off_cache *c = NULL;
>  	loff_t p = 0;
> -	unsigned int i, ret;
> +	unsigned int i, ret = 0;

Two problems here.  One is that we shouldn't mix initialised and
non-initialised declarations on one line and the other is that just
squashing a value in isn't a great fix for this sort of thing - it's
just shutting the warning up but perhaps the compiler has actually
spotted some control flow error and there's more wrong than just a
missing initialisation.

--R6sEYoIZpp9JErk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqkLRAAoJELSic+t+oim9IU4QAIOLrlkcfc/Be2A8KL4cS1sd
AGKhqGxP5ic2GIRoh1TkWHwKKCujOwEQ4aLR0XugtTiqH8+9r/QxyMaeiXXiwnAl
HphaSM82THRQzT0OF2oOAUZWksuRaRybdx+R+UypgZNO8KStqH1oJo3MdfCcsomr
3OZ6IYiWMCoCGnNKyeS0P5b0aEaga1/5aY/qqiGP7BW6dJKpqwuAChO0dGBQla97
4F4XlbUmH+ZENkpF9agLXyDN6iLgh2HSiHdjg9PSmUWoDFMTPpVVUyplYsZVc5eQ
XXSZbH1DYr11c7B1Ph/+jo9UzuhU5Pl5NjeqDOQcWhul8GSqvUqglmlQWHD/FPXo
QDD4QsfuUQtCuOeZ1FfJGmz941jWRqb72nkbp1Qn3Ch3/C+AE+nG2QJBYgFJjkZs
1zkFbMow48vxPTo/EIoGFsqyyxIHcqcr6rA3Jrf+cPFMS74jkti1jOUk+sDFIujF
ke6XY2XHL8j9Wtb1UQi5bRadKynj7HYkbNOPyeAl/wKUU9HdpnYeOevMQ5xdP+lU
xzXx70GmUA6cWdAaF6czlU6TYg5LqXSE1Gja8Nvc5LgNx97vUtEqHTAc0+s/mwVM
SNRNVENgTIT6kTP5VyT8c6N4CtZCQnRGI8OB9szJ/MzFBm+dKhjNgGHZ2eWNXIWl
OpRwnZKzRQ/uwvx3SSsa
=EfQN
-----END PGP SIGNATURE-----

--R6sEYoIZpp9JErk7--
