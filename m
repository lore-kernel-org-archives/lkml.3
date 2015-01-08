Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbbAHPs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:48:56 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12588 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAHPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:48:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Jan 2015 07:41:28 -0800
Date: Thu, 8 Jan 2015 16:48:39 +0100
From: Thierry Reding <treding@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Paul Walmsley <paul@pwsan.com>, <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <linux-tegra@vger.kernel.org>,
        Allen Martin <amartin@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
Message-ID: <20150108154837.GA1608@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
 <54AE9286.1090800@linaro.org>
MIME-Version: 1.0
In-Reply-To: <54AE9286.1090800@linaro.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.68.19]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 03:21:58PM +0100, Daniel Lezcano wrote:
> On 12/09/2014 11:07 PM, Paul Walmsley wrote:
> >
> >Like several of the other files in drivers/clocksource,
> >tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> >enabled.  This causes obvious problems when trying to compile this
> >code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> >blocks exist, so it seems appropriate to provide support for them.
> >
> >So until we figure out a better way to partition this code, wrap the
> >delay_timer and persistent_clock support code with preprocessor tests
> >for CONFIG_ARM.  (The delay_timer code should not be needed at all on
> >ARM64 due to the presence of the ARMv8 architected timer.  The
> >persistent_clock support code could become important once power
> >management modes are implemented that turn off the CPU complex.)
>=20
> Well actually putting #ifdef macros in the C code should be avoided if
> possible.
>=20
> May be you can replace those macros by:
>=20
> if (IS_ENABLED(CONFIG_ARM64)) {
> 	...
> }
>=20
> ?

Unfortunately we can't. Some of the symbols in this file are only
defined in headers specific to ARM and not available on ARM64.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrqbVAAoJEN0jrNd/PrOhK6kP/RHXBVdtLPXfGpRU+JLTVgZH
kqD4GVu7fg1U+2k4fRhlwc6B8tR/ElT5tBJgbDZ4KVR6oOYOFqziPs6KiHjnwG38
2AB7XuvXVy69zSc4DBxSa3CTeXNc+dsvS/zKYBzhSNtFGj/+8j26h0tPNHn3kOdP
9k+dEQclVYOrEsVJ2XkBGhqKqHxVx+LxeI3hBAmZKnv/tnzV/3QhBoSOZFjUFn4X
NpbdYWtqAcnqKQUsDA5Z4MpYvYyOWdsbAG95dfJPP1R3V/oX8T0OO0wyhlSkArgX
X65aJiYQACVEJG+neys9HEknb5taZRjSuHAR+1eqMDmX8bbMzURvPpep5vxA1XrF
OlWB4+IiFyHKUc/MSOnRAzb1EpOQIdv7fwiTRWC7nbsK9b+8ZC77cj4JUNHmkZZn
m1MdvgWKQxC5xIPKbSnC9zXg15EA17QZef2VnRSalBbo5G9H4S0eSShBPXnAO+dB
PGhPHjYR7yH0/DS+/bsH7ZUBmBRHW8GO2bwCrtNJrhdixdcuHWdoFgNmf8hjcrJB
EX+TdPBE5SLebdvR378qfOXQe/2pKlFunL6t3RdLmbHQe8KWcgNpD+3NumTLoV9U
XuPoJms5InCaZJbuM6Ei53YTvAiocldxmA/SxAIiJP9GPtmGYNjyXFKsablF/uWb
zjZ9Gb3VUosD10JtPlOR
=uUAa
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
