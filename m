Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3J1Hrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:47:51 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:48087 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab3J1Hrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:47:49 -0400
Date: Mon, 28 Oct 2013 08:47:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Jeremie Samuel <jeremie.samuel.ext@parrot.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci: dove: Fix build breakage
Message-ID: <20131028074744.GD6629@ulmo.nvidia.com>
References: <1382533832-21085-1-git-send-email-treding@nvidia.com>
 <87ppqqkh2g.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zjcmjzIkjQU2rmur"
Content-Disposition: inline
In-Reply-To: <87ppqqkh2g.fsf@octavius.laptop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zjcmjzIkjQU2rmur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2013 at 08:56:55AM -0400, Chris Ball wrote:
> Hi,
>=20
> On Wed, Oct 23 2013, Thierry Reding wrote:
> > Commit 2d7c51f (mmc: sdhci: Use work structs instead of tasklets)
> > converts tasklets to work structs, but typos the conversion in the Dove
> > driver.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/mmc/host/sdhci-dove.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dov=
e.c
> > index 45c7f25..95f1076 100644
> > --- a/drivers/mmc/host/sdhci-dove.c
> > +++ b/drivers/mmc/host/sdhci-dove.c
> > @@ -39,7 +39,7 @@ static irqreturn_t sdhci_dove_carddetect_irq(int irq,=
 void *data)
> >  {
> >  	struct sdhci_host *host =3D data;
> > =20
> > -	schedule_schedule(&host->card_detect_work);
> > +	schedule_work(&host->card_detect_work);
> >  	return IRQ_HANDLED;
> >  }
>=20
> Thanks, Thierry -- I hope it's okay with you if I merge your fix into
> the original patch and add your S-o-b to that patch:
>=20
>     Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
>     Signed-off-by: Jeremie Samuel <jeremie.samuel.ext@parrot.com>
>     [treding: Fix typo causing sdhci-dove build breakage]
>     Signed-off-by: Thierry Reding <treding@nvidia.com>
>     Signed-off-by: Chris Ball <cjb@laptop.org>

Sure, no problem.

Thierry

--zjcmjzIkjQU2rmur
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbhagAAoJEN0jrNd/PrOh2LcQALwF1OL2ke7UL2BnxMdMoYQu
cr4CLHo9EuDi/Io8HajA/vuyY9bHLo8FLmm1vMzIYxk5Xh51J8N8gMP8pOaQ5lrp
7pFIugg9/24A+ojncB9QEu8n40qb4SG06VwZq3g9gRk04pn3ppesR9H/DBWRVSFH
omyvrljnUE88/QzJbkfAgKZKoZZDvw2/nCk/Twl7xDFrSpbWNbUFzXVgFP4NWoff
+YeXp+c6h/4jUuTGlTeOLmYGqURSIMoRHx/P4MwZK5/vszvO/eXYmVTngGNBWf+b
1nmwOnvpdsqNTpxczszL5qKy2m4vLKS4RiGwWCEh3qHCnJQMTyJQc/VVSke4xTpA
Pku/qLsEkEVFccydXtGFD5Qz+jhk9OqMbl65rxK9hSu+1HrTiWgUfPSbph5IrpoA
gEKXI1sLZQNXu2/acYNkYyhZjRZ4tXnirFM4FyYyNh6uv2GPDsXYhnkjpnhGWeqm
NY1CxhAfj45ssJ2t4+WbTIb68tZfo5PHANiqiQI/PSls2q3k3vSO5MTWYicDJuyq
Avmt/ModuqBDGK9wSJL3mSsVVdJVAzCGc+zc3SBO47ILvOuxmA7xarPijaECMYkG
DkwtQApkFKu46pCdWpValVOIkHdJci+vQKWiOKdAFab0DrFP+uRqQPkDgntnZpff
5BLrDCNBPcAX9AHlDxKB
=/Nly
-----END PGP SIGNATURE-----

--zjcmjzIkjQU2rmur--
