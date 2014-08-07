Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaHGQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:58:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52068 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaHGQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:58:50 -0400
Date: Thu, 7 Aug 2014 17:58:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        rf@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        ckeepax@opensource.wolfsonmicro.com, B18700@freescale.com,
        b02247@freescale.com
Message-ID: <20140807165836.GL17528@sirena.org.uk>
References: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hnkm8iSck3C18VLX"
Content-Disposition: inline
In-Reply-To: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8962: Correct the bit offset to enable mono
 speaker output
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hnkm8iSck3C18VLX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 07:55:49PM +0800, Nicolin Chen wrote:
> As WM8962 datasheet describes for SPK_MONO bit of R51: When SPK_MONO
> is set to '1', both speakers output the signal from the left channel.

> So for mono speaker widget, we shall enable Left Channel whose enable
> bit is 6 instead of 7 (Right Channel).
>=20
> This patches just simply corrects the bit offset.

>  		   spkmixl, ARRAY_SIZE(spkmixl)),
>  SND_SOC_DAPM_MUX_E("Speaker PGA", WM8962_PWR_MGMT_2, 4, 0, &spkoutl_mux,
>  		   out_pga_event, SND_SOC_DAPM_POST_PMU),
> -SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 7, 0, NULL,=
 0),
> +SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 6, 0, NULL,=
 0),
>  SND_SOC_DAPM_OUTPUT("SPKOUT"),
>  };

Someone who's name I'd need to look up submitted an identical fix off
list recently - I checked the datasheet and it seems that in mono mode
the speaker output actually wants both left and right channels active so
there is a bug here but this isn't the fix.

--Hnkm8iSck3C18VLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT47A5AAoJELSic+t+oim9PdkP/2RQUGMdlQW+zC61dSer77d2
uRb0GjfWI0FiG98WLPnoTdBi6MALzLp0RbPCOqwi0DpMUG4nxohCcpYJyaKSpgdx
ZEZ8HpnnNo66eP62svlKoJSAF56tOKGnIjm8csVi+l4L0UJ1/p+0d0omg55tmWFT
ONJA38W7YBRcoqDhziRwZ2TKkFUpAs7aHHgUMh+on+2MvcohPicINS9amU6ssJra
LSNEQe/V902Qfe5t5YggGKmmERkl6BjiUHWH0DUkcEV6lKs7TdLs6mz679lNJzQx
svRI3XGngWkfdu4YUZLa5Dgs2OT8AJYyRWNIsrQ7zyHeZXt4QN2eqHiv0VOJD0fu
hwsevQFX0Uc9cZbRevVLgukQ/F4+LcGiixQ+43ufrWTc4Rv7dYPTP2gGd0kEBnC5
5I6ErVer2NC5FawNcEv82YNkRFMa1HG9Q6F5PfvHIdEIj7/7WAB761Cxt26L2v9C
F+/63KVSnU0hUoSqlYImMzh5bywvsCc5gMUUAzIc0PpqHtEA03L9HOpKdz2/fx96
OaDeOsaXeBxpgRZp5OMfcJnW45ShWkNOZRbXqRx0aQFkeB9ZWOnd6N6gLSwzvjdD
hUdZih+XogmP2ZefvGLhrRdeP919D/D7B18V4qLfGUmdlGG6zRvK0PR/+l4UqGKe
HYBfbvSUdQqStneLjUPr
=NpIG
-----END PGP SIGNATURE-----

--Hnkm8iSck3C18VLX--
