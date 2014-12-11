Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaLKMbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:31:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55551 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbaLKMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:31:40 -0500
Date: Thu, 11 Dec 2014 12:31:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexandru Stan <amstan@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lgirdwood@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141211123106.GU11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
 <20141210235347.GT11764@sirena.org.uk>
 <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qq74T9cNcLNVv1KL"
Content-Disposition: inline
In-Reply-To: <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qq74T9cNcLNVv1KL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 05:08:37PM -0800, Alexandru Stan wrote:
> The spec is from 1.7V to 1.95V, with 1.8V being ideal. It's not that
> symmetric. But let's say that 0.1V is fine for tolerance(so 1.7-1.9V)

Don't top post so people reading your message have some context to give
them some idea what you are talking about.

> Imagine a board has a 1V-1.79 V regulator, we tell it to
> regulator_set_voltage_tol(1800000,100000). It will try the 1.8V-1.9V
> range, when it sees that it can't it'll fallback to 1.7V - 1.9V, and
> it will just be lazy and pick the lowest of the range again:
> 1.7V(causing voltage drop issues because we're exactly at the minimum
> of the spec). The correct voltage would be 1.79V

This is just an implementation detail, everything you're saying here
applies equally to any user specifying by tolerance rather than range.
If the reason for doing this is to fix that problem then a new API isn't
the way to go about it.

--Qq74T9cNcLNVv1KL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiY6JAAoJECTWi3JdVIfQUT0H/iHhxGYO5AHqDtfLAmRRTBc1
85bQzms2XHjw5DK/xUyegaXxplbUg7mhpBE22dIckpj1GVGfmtrKXAtVeJ3viQNh
swLi6sg7oYGvdJJtnemskwL5OcbDvi6TTFXnqg/2Rz5APU83lFKf1HN8dtGB1xh+
OCGa++kho+q0SAih4JejLYx7TQKF6p4ErIqIFRIRUtJEpJYgwqJUQNtr+PoLMlu2
CcPs0QsEg4P1S4aHUEdJ/59EFwxEEQtZLeCcPvYABwPWAGGCwPr27YoCd0gEV5pt
FE2VI0LKiKlbEjc3WTlsjct11YL47/kNbrPpvJkGKaSF/B4PEByYJgrj85zI6a4=
=z2Se
-----END PGP SIGNATURE-----

--Qq74T9cNcLNVv1KL--
