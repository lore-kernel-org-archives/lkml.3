Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaGULyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:54:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47793 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaGULyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:54:00 -0400
Date: Mon, 21 Jul 2014 12:53:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140721115353.GV17528@sirena.org.uk>
References: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
 <1405704668-8038-2-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BO2dbX1J/fdLEy+S"
Content-Disposition: inline
In-Reply-To: <1405704668-8038-2-git-send-email-dmurphy@ti.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: tas2552: Add DAPM calls for amp and PLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BO2dbX1J/fdLEy+S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 18, 2014 at 12:31:08PM -0500, Dan Murphy wrote:

> +static int tas2552_class_d_en(struct snd_soc_dapm_widget *w,
> +			   struct snd_kcontrol *kcontrol, int event)
> +{
> +	switch (event) {
> +	case SND_SOC_DAPM_PRE_PMU:
> +		snd_soc_update_bits(w->codec, TAS2552_CFG_2,
> +						 TAS2552_CLASSD_EN_MASK, TAS2552_CLASSD_EN_MASK);
> +		break;
> +	case SND_SOC_DAPM_POST_PMD:
> +		snd_soc_update_bits(w->codec, TAS2552_CFG_2,
> +						 TAS2552_CLASSD_EN_MASK, 0);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
> +{
> +SND_SOC_DAPM_PRE("Class D Enable", tas2552_class_d_en),
> +SND_SOC_DAPM_POST("Class D Disable", tas2552_class_d_en),
> +SND_SOC_DAPM_POST("PLL Disable", tas2552_pll_disable),
> +};

This seems broken, having to use _PRE or _POST widgets for simple
register writes (or almost anything really) should never be required and
error prone - what is this actually trying to do?  I'd expect the class
D to be a PGA or OUTPUT widget and the PLL to be a SUPPLY widget.

--BO2dbX1J/fdLEy+S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzP9OAAoJELSic+t+oim9x2oP/3zZDeDa9epGi3MzHEvbv5Ar
AZd7beM0xMWlGxoNxN0arkv/RyAYmgAEdLTGxAMnkfPVoF0xpJXaOU1scXgKhkMQ
wnFXLFZMdPHTA5znGbnvd4SP+iQiAMKYYSqDvU3GDe9/tEmE7yq4RodKJtwj2qQ6
UpWCv7RrqPrljw1O1LQmqwANc/WsAto/vXxu04VYTExv1fTRuCd65aacIX5ga6ub
RQGy7WL/++Om+s0I/ZQJm6iSfJbW7XmKsGCgd+4bEH/Qwa2WPIstMgCiyuK19HhM
OxX0K7T6Xu5fApK2OrRRpA89ncAOZ05GBOJ0fT4ftxMfYs+/tNMF3iWCl7EIsYMd
NTvjMfVNoK4exQa3GvDvueh0ncakVp4G9wXgJ/HFRhtHB2oYuGJ6fGJ0e/EtCtqA
xhD8azvcRZjtylOiZu4h1AQ7QBsfE34yK4D0hAhx6jHfgIJ8yW3WR7FznBU6gB6B
42OkWx8gDpG46FisI3aFkr+shErHxUvk1eN7wNna56gN5Ygbt7qLCXa2GLKohxBt
VppaaDFxJwNCf5mzNOrQ7oQURBfgtSj22g8bDuotkEHH6P1gztYijAqwxbgSQrRT
7CuB7DalS0r7aMmh9tzG2d/DnG2BXHJSnyAk1E3j7bokvvdHHVH3JlH4+IOwb3MB
ThhWYIc8iVJsS463DHa4
=MSE1
-----END PGP SIGNATURE-----

--BO2dbX1J/fdLEy+S--
