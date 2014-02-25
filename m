Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaBYBek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:34:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51206 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaBYBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:34:39 -0500
Date: Tue, 25 Feb 2014 10:34:24 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>, Sascha Hauer <kernel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <20140225013424.GL25940@sirena.org.uk>
References: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
 <20140223051209.GK25940@sirena.org.uk>
 <CAOMZO5BPvCcx_f09Khuw8MVxrR18fnv9e1xeuJ0c_8G22AR53g@mail.gmail.com>
 <20140224205058.GA18317@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zm9sv4N+ZePDBU/L"
Content-Disposition: inline
In-Reply-To: <20140224205058.GA18317@pengutronix.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/2] regulator: core: Fix ops->enable/disable usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zm9sv4N+ZePDBU/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2014 at 09:50:58PM +0100, Markus Pargmann wrote:

> The only situation where this returns -EINVAL is a dummy regulator that
> is not always_on. As it doesn't make sense to have a dummy regulator
> that is not always_on, I will add a check for exactly this situation to
> the regulator_register function and drop the "return -EINVAL" above.

I've squashed the following fix in today:

=46rom 937635aa9c667b90b76505de91c5693da6a5c120 Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@linaro.org>
Date: Tue, 25 Feb 2014 10:24:55 +0900
Subject: [PATCH] regulator: Handle invalid enable operation for always/boot=
 on
 regulators

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8cbc7d7..9a09f3c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1017,7 +1017,7 @@ static int set_machine_constraints(struct regulator_d=
ev *rdev,
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
 		ret =3D _regulator_do_enable(rdev);
-		if (ret < 0) {
+		if (ret < 0 && ret !=3D -EINVAL) {
 			rdev_err(rdev, "failed to enable\n");
 			goto out;
 		}
--=20
1.9.0.rc3


--Zm9sv4N+ZePDBU/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTC/McAAoJELSic+t+oim9rccP/0giz6cmMgye4hG2/kS7p7ig
Si54NnJU+d6RpDhcWtL69TnqhCKKm6+3onBEQbaoa5UuYFVgwcddlPHHcDTMyue1
A5Wg9nDkBEDJ71CeqcBBxWYatg6pavcAC0fTuppUoveDjVQQQXVO7lN2NS77Rmyq
NzMoi0iWpcqSXdh0HhYHhFZD4xcKG9oD1kexRZiIB4t6Le1lgtWyG524o1wVOK4b
Ganak7aiIQv7lgszEDSKRASGEyJMlaDthTvG+URs0XJvljfEzK4X7Ys4ewxj0BUr
hkHbudVCQLWwQytl3Ve4Q3ZebdffF9iwlDpgM1Louw1lUzd6JNnbtW7QsI7k+9q4
D1KqClXGzwtaMaU65VLCuS+Aku614H1hqU/uPVKWrPlybw+tQbfu6tTkR++MKtSV
dsH9+sHbAuYCUY34J7wNjs3bZaLUs7fTHcQ4/lClVznjGciQRYtQ000DyXB6WNRw
wGG8ahKGBAlqGvEPGFwUDLZGz3Nw5H+qywTYI+6Kheqtgi3QTzmJQHHKuwdc5zkP
UnsjzTziYXh1wPpiNjJMOSgfv/sOmTLQDkjN6Pyj/YScD61kdBkSgAMvlNvpZVPK
Rf62nT9oooac7inWzyrYSM2GbmVO7+0cMe1HyeyWVCpYAZPZgQfBVjTm98C8TNDd
LnAkcXuclVH4yt6+LnAQ
=bpzo
-----END PGP SIGNATURE-----

--Zm9sv4N+ZePDBU/L--
