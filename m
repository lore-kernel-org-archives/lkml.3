Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbaLKNVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:21:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55635 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:21:50 -0500
Date: Thu, 11 Dec 2014 13:20:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Strasser <kevin.strasser@intel.com>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>,
        Yang Fang <yang.a.fang@intel.com>, linux-kernel@vger.kernel.org
Message-ID: <20141211132026.GY11764@sirena.org.uk>
References: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VBg0eA7b+gOCQW/G"
Content-Disposition: inline
In-Reply-To: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: fix possible acpi enumeration panic
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VBg0eA7b+gOCQW/G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 11:21:57PM -0800, Kevin Strasser wrote:

> A crash can occur on some platforms where adsp is enumerated but codec
> is not matched. Check that the codec_id string is valid before
> attempting to match.

> -	for (mach = machines; mach->codec_id; mach++)
> +	for (mach = machines; mach->codec_id[0]; mach++)

This changes the check from verifying if a codec_id is present to
verifying if the first character in the codec_id is non-NULL.  That
doesn't seem obviously safer and the tables of machines seem to be
terminated by having an entry with all fields set to zero (which is
a common idiom in Linux) which would now crash with this change.

--VBg0eA7b+gOCQW/G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiZoZAAoJECTWi3JdVIfQg8EH/2KJ8UMn3w/EnvG41T+3DPYf
7ZEYmHAkQeXVjlaM1aaqU22vfN8M3Dkh93VkARAygSEdoVG4OmkIpQF7jitj20kC
+cfF2t/ws+lWpPoIHaZ5t9+h7RuV6PxaxgPbXsrAv/7LWa6lXHmAPRHADwLdhhh/
V0L6B2On1OiZb21BDDuxL1lM91KqGTfdAcItY7TOK1+/9QNb+SJEVxl/y4VYRpzy
wZkKXm/s4dYWaX1cRJoHXTNND8hfZz4RcJPn2CYS096DWnngCjllRqKvUjL+xCdV
ZBZdeo8/zq9SH7EKUxmf3+LNg95ZI8h4NUa170obU/zqLGzQ5+qMHpXrI4EW40s=
=OD8U
-----END PGP SIGNATURE-----

--VBg0eA7b+gOCQW/G--
