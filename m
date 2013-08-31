Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3HaNHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 09:07:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3HaNHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 09:07:52 -0400
Date: Sat, 31 Aug 2013 14:07:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        alsa-devel@alsa-project.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130831130741.GG18608@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 0/5] Remove ASoC-level I/O functions from cq93vc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch series removes the use of the ASoC-level read and write
functions from the cq93vc driver as part of a wider push to remove them
completely and just use regmap for all register I/O.  Since the driver
is essentially doing what regmap-mmio is doing this is done by adding a
MMIO regmap to the core device and using that.  This is compile tested
only, I don't have any hardware to run on.

Since I anticipate doing more cleanups over the CODEC drivers during the
next release cycle it'd be good to merge via ASoC, though there
shouldn't be any overlap with the first patch.

Mark Brown (5):
      mfd: davinci_voicecodec: Remove unused read and write functions
      mfd: davinci_voicecodec: Provide a regmap for register I/O
      ASoC: cq93vc: Use core I/O functions
      ASoC: cq93vc: Don't use control data for core driver data
      ASoC: cq93vc: Use regmap for I/O

 drivers/mfd/davinci_voicecodec.c       | 23 +++++++++++--------
 include/linux/mfd/davinci_voicecodec.h |  3 +++
 sound/soc/codecs/cq93vc.c              | 42 +++++++++++-----------------------
 3 files changed, 29 insertions(+), 39 deletions(-)


--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSIeqaAAoJELSic+t+oim9g0kQAJqC4LjvgDuA0CCBWMDiu1t1
9mMl8fTqQmk+IWRTkKMgkEWz4+k5LIaCDp9y4ITS65J7YbaHZrOQJmrnRtXJUL3f
qQPPstoIcnn88cyEXI3ssw65lY6A3G4+fG7b2lDqGfkqsUwpzkGaPm69w6TXyFsj
+b5ZWqAQgSbpVHrtwL9VCYepHsCIWUEd/OaAvDl2a0ygfj3A1NPiYl8Clpe8fEKy
0nhBVkYZwqqPGRY4yWaNh2t/8EWhy9ZmLxOsx+/I2jRrKp64LxeTu+Sr3ZBQxcJj
/DW2P25EoUTFhlXSTQbgFjuzQovZTAFB3VoVOvs43vJGML5oq1jZJ7YO75aRKien
azvGo4IjXpiStmiGHw+e2/aQ+AD9mz0txyoFHQJfLKpQT0YdVk+d1dBxFwl53wZw
Cbx8pe1OQRjqT0ZrLuwRADqMWw9r3vZ44DEPHe6CdwsD+gS50b1MGbeMTMtkV1Y2
FlTC1EsnSTEq+uIjUNF8d7eU+BgQNLywcyPJC+CKaYntKDnEDC08eYR+tNReDqQL
k+OQE4bZeiyrL+bLXiNOH/VfyE05AvwBF3qzkzvUuSnY+a/VgC6tRUSTda03DQjx
Gc7jkAHSdjOjGUOdz1GpEA6UaGere0sJUhyPMf5Q2We1C7iYDqmUpuOi4e7eg1Q0
K2tW0WHuxedUy6a8aFks
=Bh88
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--
