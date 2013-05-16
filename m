Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3EPRyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:54:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50686 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3EPRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:54:07 -0400
Date: Thu, 16 May 2013 18:52:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Matthew Mowdy <Matthew.Mowdy@maximintegrated.com>
Cc: "abrestic@chromium.org" <abrestic@chromium.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dylan Reid <dgreid@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralph Birt <Ralph.Birt@maximintegrated.com>,
        Evan Ragsdale <Evan.Ragsdale@maximintegrated.com>
Message-ID: <20130516175241.GF1627@sirena.org.uk>
References: <1368640112-1417-1-git-send-email-abrestic@chromium.org>
 <A453F1AE3B5DC14DB19666C506CE75A710ABEB1EFF@ITSVLEX06.it.maxim-ic.internal>
 <9F78FA13B8C7A749B307D9AECB279EB713E7B327F3@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NQTVMVnDVuULnIzU"
Content-Disposition: inline
In-Reply-To: <9F78FA13B8C7A749B307D9AECB279EB713E7B327F3@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: max98090: add digital mic mux to record path
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NQTVMVnDVuULnIzU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2013 at 09:10:23PM -0700, Matthew Mowdy wrote:

Sorry, didn't manage to find the content I meant to reply to in here due
to the formatting issues I mentioned in my mail and the enormous reams
of datsheet that were pasted in.  Anyway....

> Default Routing:
> Of note (software can confirm) I believe the default DAPM routing for the=
 driver was intentional setup such that :

This indicates that the driver is broken, the driver should be using the
chip defaults.

> Record:

> o   If a headset MIC is present, record from it.
>=20
> o   If not, digital MIC is the default record input.

This is a bug, the driver should not be making any automatic routing
decisions.  The behaviour you describe would break some fairly obvious
use cases like speakerphone while headset is connected.

> Playback:

> o   When headphones are detected, playback is through the headphone outpu=
t.

> o   When headphones are not present, playback was through the speaker out=
puts.

Similarly here, this is junk. =20

> The defaults can be modified by each end user as needed (for analog
> microphones, line inputs, etc.). Please insure any patch to the
> baseline driver reflects the correct operation of the digital
> microphone enable bits, and preserves the intended default operation.

No, this is stupid and will be buggy.  The register default values need
to reflect the silicon defaults, the frameworks (both ASoC and regmap)
do things like suppress writes that have no effect and rely on knowing
the silicon defaults for that.

The framework already allows the application layer to configure the
device through the controls exposed to userspace, if people need to
modify a CODEC driver for their system that reflects a problem in the
CODEC driver.

--NQTVMVnDVuULnIzU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRlRzmAAoJELSic+t+oim9HCUP/2yn0pjEesjPOb44HzmF72jn
AJ0KDfjPoOo11KCpE0QO2x3CU9njHCaFkKWFfGTOR3lV9BbGXS0wzNhSXCMjsYRP
hphPLnICM2DM898SW+KbZayG7qsS2pKHMSBBon9vPRQfFW5p7Y3fXKYXR4uGBF9V
stuwNb+j16OcRjOPmJmyRlBME5B0voUSXypixjBVZndbNSB9oLlmCLBiZoNbIQg6
74XqeV+lvoBJFUv14mboHkPni1tnvVnX9dsV3b6scpk7s0t7wPRsKiQVhPCMvPJ1
tL3us6s5e7hFL0VFMFsHTYM7Nt7nGTwtunYpPc7nnTfqMnTHP7xJTK5VJIFeh6h2
puyM9cMEN1c1+i464vbGun0iq9NB5Eye5PPn/1SLUAgVOgp47GeJ+hxwy6F0xJJa
ukKEM7sS4oMZcaF4VNlRgldoViDCPCLGfJQ6z3bN6P/Du23etlzyvQaHctZFhIvO
Pm4cvj5biJYSpbsZSSuRf3rGKIT5OLz2oXx6zk6TfiPTdZ92+8AXbYPsd4e0pTJH
IfQ7Kdkeb3Epv2pzBZ2TmUdfCtPMU5PWmdNCMP6SeEfTIFfzT/PxYEyuTMHRSHty
gZvJLQ3BqOkcxikfDrKjWmTPjFoB9qmxo8ISpMBzVAKZz2hu+IaTjdshQ1uWvf/l
8NfPzhyvUxbf35lVcicf
=wNgK
-----END PGP SIGNATURE-----

--NQTVMVnDVuULnIzU--
