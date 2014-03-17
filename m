Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaCQQnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:43:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57676 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbaCQQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:43:50 -0400
Date: Mon, 17 Mar 2014 16:43:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140317164339.GR11706@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
 <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJjS+Ds6jmpBvWv0"
Content-Disposition: inline
In-Reply-To: <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/4] ASoC: simple-card: Add DT documentation for
 multi-DAI links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xJjS+Ds6jmpBvWv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 15, 2014 at 12:30:05PM +0100, Jean-Francois Moine wrote:
> There may be many couples of CPU/CODEC DAI links.
> The example 2 is extracted from the Cubox DT.

Oh, here's some documentation - please include the documentation
before the code, without the documentation the reader is going to have
no idea what the code is supposed to be implementing.

> +  There may be one or many couples (simple-audio-card,cpu, simple-audio-card,codec)
> +  (see example 2).

This doesn't mention how they're matched up.

> +sound {
> +	compatible = "simple-audio-card";
> +	simple-audio-card,name = "Cubox Audio";
> +
> +	simple-audio-card,cpu@0 {		/* I2S - HDMI */
> +		sound-dai = <&audio1 0>;
> +		format = "i2s";
> +	};
> +	simple-audio-card,codec@0 {
> +		sound-dai = <&tda998x 0>;
> +	};
> +
> +	simple-audio-card,cpu@1 {		/* S/PDIF - HDMI */
> +		sound-dai = <&audio1 1>;
> +	};
> +	simple-audio-card,codec@1 {
> +		sound-dai = <&tda998x 1>;
> +	};

So, this is not exactly pretty as a binding.  I would expect to see the
links explicitly represented in the DT so you see the two DAIs in each
link grouped into a container, the above isn't very easy to read and as
Jyri says this lack of clarity also causes practical problems in that
there's nowhere to place link specific parameters.

I think what I'd expect to see here is that the simple card can either
be a container with a link in it directly or a container of links.

--xJjS+Ds6jmpBvWv0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJyY4AAoJELSic+t+oim9OS4P/2khiA2POaSMU0iHK/NHMpS0
w0OGadBvfHJT+zLr1L8wC/RCxtkWQh58nGLpf6a2YoOtH3YM/tCT+RjQAc+N7zuq
IjKQUKUNmLGhFoLvJcIyO6ivaMoAiAFSLFkcwOvf4AMiYkgtxgYZ3wAXJok2rs6N
Ubpr+wyPCz6omF9jYIvNHVkh5nGvGZuNHemZDx0CnnmICAfXsdb4tA3nrE98Qfbv
ouIC3mlMZgddxRzmyMM4OyoIL2bxnykhtf3WZkd35IrRGoVrALF7k4/C7o2OlqFX
OfrhgtzaM6IUjyZmu4q2DvvAsnEuYKtqxDSzOEMK/4a9/+zIEs+veMY41JTkrjUL
01J4jEm1k7qZtOYQbRdbxrj78K+nzCwd4gelBqVzz37cjgj/OegMpQibgLFHrIGl
8tndd6Dw35+EpKzIfLe4yQAXgJpxconRu8KC1Y5CWT78ZtCO/HvM6I8oYAwv/r/h
zaykERe5sEgj5l0KANI8AsZ0vdQkIDIsYG2bJzMuOTutnsrRXIhxaT4m8O/jF55Y
JM9+xaurD4v4eAxg/eotpx2Vfyj68ekiZxGhytkaEAKTq0JH+UzKSyv4OUiVwmPI
h5KTNpSZhTq1ZdQxk1wAbq1dbh+qgT1GqYpU5BPZ64W9TfJKT09WWQG+MP+DqDse
y08KQgCQhsweq0ZdBPWZ
=DYEL
-----END PGP SIGNATURE-----

--xJjS+Ds6jmpBvWv0--
