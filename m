Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaL3Qvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:51:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaL3Qvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:51:47 -0500
Date: Tue, 30 Dec 2014 16:51:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141230165110.GK17800@sirena.org.uk>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
 <faa0193d388fe808c2fae461954bb1730ba29244.1419936132.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qu+55eaNXpiLf04N"
Content-Disposition: inline
In-Reply-To: <faa0193d388fe808c2fae461954bb1730ba29244.1419936132.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 2/6] ASoC: dwc: Prepare clock before use
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qu+55eaNXpiLf04N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 10:55:44AM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> Some I2S clocks may require some time to get the clock ready
> for operation and so need to be prepared before they are enabled.
> So, prepare the clock as well as enabling it, but combine the
> two through clk_prepare_enable.

Applied, though the changelog is inaccurate - the need to do things
outside of hardirq context is the reason the common clock API has a
prepare stage but it's just a flat out requirement of the common clock
API to prepare clocks.

--qu+55eaNXpiLf04N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUotf9AAoJECTWi3JdVIfQsHYH/1MqZ5lyDjuDapIqu4M8WpCG
XDtrgSBuB2YvZGPMGh0c7n9l4S7xS3I/C3zhbs3RBLAEpl8hUZzbu8SfQQfcM7tw
neIyrAJ3VLxQGPN6U1t3lYPsFyCvcwUeBqLmOG/JwVVhBcWaL+pW39YDSt4NEt4H
CsHoAFwwtlQoqKZojEvujdyx5RL9H/OfTsccOHrlNKkEasQDEWPUdDLfaIlKHIW1
xENWBkv9smBLwzYS0rrjAtyWXvy5eKFwbBx/EAwrNFWd/ogwRHrPedRG1re0Pt2V
Lm7RpUWls2n9vfDdnzDJ3lQeHrcNAcpAGXYNSuNehLlXLfVLUFuWRv1bDGWAxaU=
=/tMT
-----END PGP SIGNATURE-----

--qu+55eaNXpiLf04N--
