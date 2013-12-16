Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3LPU5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:57:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48782 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3LPU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:57:20 -0500
Date: Mon, 16 Dec 2013 20:57:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131216205711.GZ3185@sirena.org.uk>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213171407.GN21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9CzcV6dAFIr7O1Ie"
Content-Disposition: inline
In-Reply-To: <20131213171407.GN21983@codeaurora.org>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Allow regmap_bulk_read() to work for "no-bus"
 regmaps
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9CzcV6dAFIr7O1Ie
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 09:14:07AM -0800, Stephen Boyd wrote:

> regmap_bulk_read() should decay to performing individual reads if
> we're using a "no-bus" regmap. Unfortunately, it returns an
> error because there is no map->bus pointer. Fix it.

Applied, thanks.

> > Yes, I'd expect the operation to work.  Your changes below are mostly
> > fine (we should add an additional check for values that aren't integer
> > numbers of bytes, I can add that) - can you send as a signed off patch
> > please and I'll apply?

> Here you go. Do you have any suggestions on how to make regmap_bulk_write()
> work?

Off the top of my head I'd expect it to just fall back onto
regmap_write() if it can't do raw I/O.  Or perhaps just change that loop
to do regmap_write() all the time since it's hardly the fast path.

--9CzcV6dAFIr7O1Ie
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr2kkAAoJELSic+t+oim9SXQQAJWVZfjunSJ9WLD6v2VbjbG8
o57ThEWuT2+2zOj1pfFtRlAEd7ooC9izOr+tfxQcuT6mjTW6YFGaP8XmPBx3yUnH
t1T3e+REmIT64xxV7ZcEtE+Sbh3ROgG6sAUWwxnBBHptv24SM91rXoGI2M2TTqaG
dqfhobo3iMZ3E90iuZS3VlajyrupjzdyI1RTCT6YhTzI6kf/Nt79iVwZYTgjyv6j
FGhMa9S6Ns3lkkzyLOfWEKF4FUdIYXemMDq6WY+bAu82pSEeyaYI4Sj+0FY6VXlo
O539/T+JULyQeNX0whY/cnahAyJEa5sOtBwNozKYIuKugNkBQn6Vne/I9gTr5Hdj
kDn35dHO1yCIGvKvKuLYUGm3GXIUa5oB8JoxzPYHVPabO94o08H7fxsQ5U/oWDWn
tBpeculNLJp2NTFW2AWXgvkzU+uIIKDfDFmHoB+NhR96iEHyDbTkdWkHcbCpVHOm
MA1/cQsGRjtHl9jhisx5vd+Y/2ONDjbXZva/ROfWbaJd2qcATfaHdp87VyA9C3jo
DAkM8REo/joXIcYBvx3xnWFb0pgk0rQjhWQ2ixw4c5Xc4gtm8jvb7VPla34TBVq3
PzpI71HYry4xpfSeEQmDXvWYhMk+tnu3Lb2EerkV2KqyNI40hNUFPPG/ni9lqfX5
HKBLk9IeXkPlfmMXQOS4
=bRbG
-----END PGP SIGNATURE-----

--9CzcV6dAFIr7O1Ie--
