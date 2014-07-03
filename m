Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbaGCPGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:06:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60727 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbaGCPGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:06:40 -0400
Date: Thu, 3 Jul 2014 10:06:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dan Murphy <dmurphy@ti.com>
CC: <balbi@ti.com>, <linux-sound@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ASoC: tas2552: Support TI TAS2552 Amplifier
Message-ID: <20140703150621.GQ5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404398393-21497-1-git-send-email-dmurphy@ti.com>
 <20140703145250.GO5814@saruman.home>
 <53B56F63.8000400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ivHc2SZskddb40s2"
Content-Disposition: inline
In-Reply-To: <53B56F63.8000400@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ivHc2SZskddb40s2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 03, 2014 at 09:57:39AM -0500, Dan Murphy wrote:
> On 07/03/2014 09:52 AM, Felipe Balbi wrote:
> > Hi,
> >
> > On Thu, Jul 03, 2014 at 09:39:53AM -0500, Dan Murphy wrote:
> >> +static int tas2552_set_dai_fmt(struct snd_soc_dai *dai, unsigned int =
fmt)
> >> +{
> >> +	u8 serial_format;
> >> +	struct snd_soc_codec *codec =3D dai->codec;
> >> +
> >> +	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
> >> +	case SND_SOC_DAIFMT_CBS_CFS:
> >> +		serial_format =3D 0x00;
> >> +		break;
> >> +	case SND_SOC_DAIFMT_CBS_CFM:
> >> +		serial_format =3D TAS2552_WORD_CLK_MASK;
> >> +		break;
> >> +	case SND_SOC_DAIFMT_CBM_CFS:
> >> +		serial_format =3D TAS2552_BIT_CLK_MASK;
> >> +		break;
> >> +	case SND_SOC_DAIFMT_CBM_CFM:
> >> +		serial_format =3D (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK);
> >> +		break;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	pm_runtime_get_sync(codec->dev);
> >> +
> >> +	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1,
> >> +			    (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK),
> >> +			    serial_format);
> >> +
> >> +	pm_runtime_put(codec->dev);
> > I have a feeling it's better to just put at the end of the function.
> > Remember your pm_runtime_put() will issue i2c transfers which can take a
> > looooooong time ;-)
>=20
> I thought about that but the next switch case could return if the format
> mask is invalid which means the runtime calls would not be balanced.
>=20
> So I decided to wrap the snd_soc calls with the pm_runtime calls to keep =
it
> balanced.

it looks like you can do both switch statements outside of the
pm_runtime region and cache results on serial_format and do a single
write to CTRL_1 register (?). If not, then just use two local variables.

--=20
balbi

--ivHc2SZskddb40s2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtXFsAAoJEIaOsuA1yqRERyoP/A+N2WCYmdSbDwoDNBzbxda7
Q7BePfLWZwJ5AH7ScQKgcJZ3b98ivNbwHumNjri/H81fmRHfEgJOywruZ13WTgPN
MN6fgtFKCVXc8AHp1qLUli/7VnBaLbv+lK0vPhkv36RnQ4tHZGG1G+hHm7Z1e7Tm
urm/FcpXUQmeZKPRHWxCfVECFrb5TXeyQrfItEmgbifckFdxaJA1Y+XJUnC15ihH
uI3VCq0TsKmDfy48ihbbQlfaeEquPoFguv/wbWV7mHDTp9OPeG/G38Mf/gpPF3Sx
gF1XDj69NcP2lu3/AzKQyD0ByZ/NlWp46WBsPR791ZkYj5t2rEuGmyex/67SaLQo
zScv/D0lakd5PyLmCv5AjRZ/1EtqD0ncbXrAxsZ8q7wNDETkhBavLzMRNLI7DjXv
WsTkqU+h8o/jCtou9dVHeXxsH7fsegna3KFXRE3YXuIYww2fxpXg3hVLbPRbtagF
ez69YtSppyNLXMJzqqmrUPrA1Y0iFIXMIpwv+Fa9ae/gMlhOX0SZuNYJD8QdxTB8
PRRcbQDBeUkjcQ/9ghom2B5CP0cpbNSbziNppp/dS1frOOv5Gi+JMv8DHatJ5RrJ
dPFMIKZT1+qI8NyUp5NX7VacW4g8R5l5cp6ydiNDxyKw4F/47JyRGLw0Qw7rGK4X
TeFJ1HTWw6wNoWL75zBd
=xw0x
-----END PGP SIGNATURE-----

--ivHc2SZskddb40s2--
