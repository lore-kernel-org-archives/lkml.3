Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaCXVyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:54:16 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41406 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaCXVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:54:13 -0400
Date: Mon, 24 Mar 2014 22:54:09 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 02/12] drm/nouveau/timer: skip calibration on GK20A
Message-ID: <20140324215408.GB17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <1395650554-31925-3-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2014 at 05:42:24PM +0900, Alexandre Courbot wrote:
> GK20A's timer is directly attached to the system timer and cannot be
> calibrated. Skip the calibration phase on that chip since the
> corresponding registers do not exist.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c b/drivers/g=
pu/drm/nouveau/core/subdev/timer/nv04.c
> index c0bdd10358d7..822fe0d8a871 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
> @@ -185,6 +185,10 @@ nv04_timer_init(struct nouveau_object *object)
>  	if (ret)
>  		return ret;
> =20
> +	/* gk20a does not have the calibration registers */
> +	if (device->chipset =3D=3D 0xea)
> +		goto skip_clk_init;

I'm concerned that this won't scale in the future. Perhaps a better
solution would be to add a "flags" or "features" field to struct
nouveau_device along with feature bits such as HAS_CALIBRATION or
similar.

That way we don't have to touch this code for every new future Tegra
chip. Unless perhaps if there's a reason to expect things to change in
newer generations.

Thierry

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMKmAAAoJEN0jrNd/PrOhJsEQAJcXGbrjZueUP8WLMd+Zwozx
eupilYYQ18I0YeUle/n0ol5uuhz629rQ7ls8HG1wJ0zdE15YQiK9WkHALcKuYyJt
5GDKxdT67g+Za14dOj1MFoMvzuQcCp3/XcjcEeP1bGL/W7fAmFnwg7fTtAZepjL9
NF/3SsBo6YAu2Cm60LLHCFzKxypQaJrU7sUPSzEvpd9Pvh47/XDsFiRnohUHkAbq
k2E8tvMTsTWNtmsOkGuaN80QhqHEHHfdYaBZj2jOkfbqE5OkF03YX3WDIV9hYfU+
AdogH2LqIvmwRIyybNyRhN39wanYR82AQDCywJ4ckbJTK0VKp71gTA+SBM8T+jiD
PXgjlQZfcOpGRVNHJUz3q4DcWUc3bGI6MhLMV6k7dKHkC7gO4pKGX+cAiun4mi9k
SYYQe5xZ5DsOVz0Knjb8kK4oXOidWlLtUryLoRb0DBAy471B9XZ+ZS7xaMWWruFk
Ajdk083IqXHpiUu/CviMKBuPkAEJlCM1aKvHTksz35YkNTplE0JwlAVCGerKyYC8
TpefAGUt5RVhFiYqXFw8Pw6MEqWZJY8/Lyurasjp9zvgdtvyiSmN04VjjytFlTXJ
2dBoGhptpkkAAp2IFaftmzbpm17/brY0AiG6MUAnaw3CtSKiQoEewzcYurgC1FFd
v7qZnRdm9J7qPyQvMdDO
=Hw+n
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
