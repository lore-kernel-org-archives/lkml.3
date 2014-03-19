Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbaCSK27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:28:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45716 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaCSK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:28:55 -0400
Date: Wed, 19 Mar 2014 10:28:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: <nicolas.ferre@atmel.com>, Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20140319102800.GW11706@sirena.org.uk>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
 <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
 <20140317115518.GD11706@sirena.org.uk>
 <532931C3.4080909@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Affreb919SiI8I8E"
Content-Disposition: inline
In-Reply-To: <532931C3.4080909@atmel.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Affreb919SiI8I8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 01:57:23PM +0800, Bo Shen wrote:
> On 03/17/2014 07:55 PM, Mark Brown wrote:

> >If this is a clock for the CODEC it should be documented as part of the
> >binding for the CODEC and connected to the CODEC in the device tree
> >rather than being part of a machine driver binding.

> This is a optional clock for CODEC which depends on hardware design. There
> are 3 options for this clock, wm8904 as an example.
> 1. Using internal FLL, so won't use this clock.
> 2. Using external oscillator, no need to retrieve this clock.
> 3. Using SoC provide this clock (we use this case).

> After considering these 3 options, if we put this into CODEC driver to do
> it, I think it will be more complicate to do logic judgement. Do you think
> so?

There shouldn't be any meaningful complexity from the above cases -
cases 2 and 3 are the same and if the clock isn't used at all then it
can be omitted.  If the FLL is clocked from MCLK then the CODEC driver
should be able to work out how to configure it easily, the device isn't=20
like a digital hub CODEC with lots of clocking options.

> And, in machine driver, it will depends on the clock option to decide
> whether to call snd_soc_dai_set_pll and snd_soc_dai_set_sysclk.

Some if not all of this logic can be eaten by the CODEC driver,
especially with a simple device like this.  Realistically the device is
either going to be clocked from MCLK (with the rate telling us if we
need the FLL) or from BCLK (if it's slave and there's no MCLK).

> And also the <Documentation/soud/alsa/soc/machine.txt> mentions the machi=
ne
> drivers responsibility (one is for clocking) as following:
> --->8---
> The ASoC machine (or board) driver is the code that glues together all the
> component drivers (e.g. codecs, platforms and DAIs). It also describes the
> relationships between each componnent which include audio paths, GPIOs,
> interrupts, clocking, jacks and voltage regulators.
> ---8<---

That's a Linux specific consideration which shouldn't play any part in
DT design.

--Affreb919SiI8I8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKXEsAAoJELSic+t+oim9E3oP/RtcZxGdptmjg1C9jSMGLYEy
ThfViRTkO9s5XYR7LZCK0q9MgVf/a/P6O6fEGku80jA+TmQwa/eLEXCq/veoWtMU
mGIX5IhAbeFxwyYYj7G/TJ1kTxz/y2NJnrZQpPWcIDMmpk/OcEyfNjaHZoYySzWl
tI74SPeJJX0LFI73oYb5Qd+L/49Q+ena12R9qEtapqHgCkn0vBWv44qo4X0Gu8bN
kFoYmONti+IDruR8kw7NMPdl952FH6c8bd122PP62wX/pqolTrez97tWmVQf4a1c
DxFFdS8qa07OpDtWxKCPeGPrVGVX7AExjKGJ1EBByPQ1tIwevbYk3CRXUq+P6A0O
C3rJL6KsjRQaqhhXf0xt3T7GKjeczO5K5YG8Ifb98jWt6pupsRaboBFR8mDNAU9n
HoNiL+Ok4Fkd/9dtyJTxERgmpDWTn5mYfCSaJf95H0LPeWn/Y2iEo/b4yNKMfYRa
fCWK/zNl1dIXEejL7sBxrTy+S3K2SZLV5c22yOZZtJZxtzoSEHTFe0NaL0muvgRZ
raiveuHwzOJf0EMr5XPIStgckmv+xNRIBSzepxyDgADCNTQN0berU73OFggkw1h6
CuY2QkAnch/DV9/k4X+NUnfyxdIAyU8tex8zWTPhk/6odo1R/m+JqEUcM9PbvdUP
SDq4JPQtbrBSLabj8GJP
=iIvX
-----END PGP SIGNATURE-----

--Affreb919SiI8I8E--
