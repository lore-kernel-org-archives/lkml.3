Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaG2SwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:52:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaG2SwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:52:06 -0400
Date: Tue, 29 Jul 2014 19:51:46 +0100
From: Mark Brown <broonie@kernel.org>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20140729185146.GF17528@sirena.org.uk>
References: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
 <1405704668-8038-2-git-send-email-dmurphy@ti.com>
 <20140721115353.GV17528@sirena.org.uk>
 <00FC9A978A94B7418C33AFAE8A35ED49DA8D1E@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oKuqsEW27CKFx7x1"
Content-Disposition: inline
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DA8D1E@DFLE09.ent.ti.com>
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


--oKuqsEW27CKFx7x1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 25, 2014 at 06:54:19PM +0000, Murphy, Dan wrote:
> On 07/21/2014 06:54 AM, Mark Brown wrote:
> > On Fri, Jul 18, 2014 at 12:31:08PM -0500, Dan Murphy wrote:

> >> +static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
> >> +{
> >> +SND_SOC_DAPM_PRE("Class D Enable", tas2552_class_d_en),
> >> +SND_SOC_DAPM_POST("Class D Disable", tas2552_class_d_en),
> >> +SND_SOC_DAPM_POST("PLL Disable", tas2552_pll_disable),
> >> +};

> > This seems broken, having to use _PRE or _POST widgets for simple
> > register writes (or almost anything really) should never be required and
> > error prone - what is this actually trying to do?  I'd expect the class
> > D to be a PGA or OUTPUT widget and the PLL to be a SUPPLY widget.

> I need a little help here.
> I am not seeing the PLL being disabled or Class D being disabled when
> I am using the DAPM calls

> My implementation is like this.  And I use set these widgets and audio
> map in the call back functions in the struct snd_soc_codec_driver.

> When I look at the registers after stream playback I see that
> the TAS2552_CFG_2 register is untouched

> static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
> {
> SND_SOC_DAPM_AIF_IN("DAC IN", NULL, 0, SND_SOC_NOPM, 0, 0),
> SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
> SND_SOC_DAPM_OUT_DRV("ClassD Enable", TAS2552_CFG_2, 7, 0, NULL, 0),
> SND_SOC_DAPM_OUT_DRV("ClassD Disable", TAS2552_CFG_2, 7, 1, NULL, 0),
> SND_SOC_DAPM_SUPPLY("PLL Disable", TAS2552_CFG_2, 3, 1, NULL, 0),
> SND_SOC_DAPM_OUTPUT("OUT")
> };

> static const struct snd_soc_dapm_route tas2552_audio_map[] = {
>     {"DAC", NULL, "DAC IN"},
>     {"ClassD Enable", NULL, "DAC"},
>     {"OUT", NULL, "ClassD Enable"},
>     {"ClassD Disable", NULL, "OUT"},
>     {"PLL Disable", NULL, "ClassD Disable"}
> };

This looks very confused, why do you have separate enable and disable
things - what do you think the effect of the above should be?  That's
probably what's going wrong.  I'd expect to see one DAPM widget for the
class D and one for the PLL.

--oKuqsEW27CKFx7x1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1+0/AAoJELSic+t+oim9VawP/jRdz6vZL+DGv+WlPT/siM2q
QDvUQPa9Zqp3heZRC2aMQ/6TfM2cNJQPjYcS28yKRatwDs4tqxiMDDpiqxxR9E4h
2YaLhaLmPHzR8jafYDpvbnTnWwIW5tGfen8bSsvCGa8u5bYKU/omMH9RJKvhli3d
xfOPdKsKz2dCKhE8124qY6OfIDlARXATB2/X6TQfuGq0BUNpfIugB2pqnSlVKn4J
DrHNxBRx2/LF1rCuehI7fUk8iHejVmJgYYmKSGE02Rwt47jYrrj6fzQrDhFiYXW+
sCAkGJh9O3e0LFrQ6aJ0aPi7P+Ijptp3HepZoVQOmdWVJUBPTNeCrLe+FejjZ1aS
xDZJvz5Gp4curq5M+286DcLUbNrOvdS4Y40vFItvunrG3px0wS3MSaummnHmSEoD
/IaU1rTenmPdBKpHKGi/6CQRjqU3RN9lvLUjJE+tGyLX53VzDouCattX0GCcB1RO
mkJtPbWMkZIh18fLEfikDxnx9uzjZmZ/qCrT3oYksDg891L3qc9Y/eHMKPGhhtKe
QXLjeptXdGESjlffVZltaRlmbAkdN1hHiEBxMOAkZvhCBfs9xGdptzECavN9bxlc
6CFVXQxE7QNVwb78jA8C9y7kvjjRrOrItcnWiX1DC4a4Wfr2g/E2jpD6MuvwKCG/
4ujYVPng14ymBjcrJQsN
=j1jy
-----END PGP SIGNATURE-----

--oKuqsEW27CKFx7x1--
