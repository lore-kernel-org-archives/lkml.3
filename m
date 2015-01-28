Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbbA2BZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbbA2BZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:33 -0500
Date: Wed, 28 Jan 2015 19:52:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, agross@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20150128195204.GN21293@sirena.org.uk>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1422413199-17273-3-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mUrGsXPB0ppB5FvZ"
Content-Disposition: inline
In-Reply-To: <1422413199-17273-3-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/9] regulator: core: Introduce set_optimum_mode op
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mUrGsXPB0ppB5FvZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 06:46:32PM -0800, Bjorn Andersson wrote:

> +	/* set most efficient regulator operating mode for load */
> +	int (*set_optimum_mode)(struct regulator_dev *, int input_uV,
> +				int output_uV, int load_uA);

This is basically fine but can you please rename this to be something
that more directly reflects the fact that we're just informing the
driver about the operating parameters - there are other things a driver
could usefully do with this, for example set current limits so that if
something starts to consume excessive current the device will flag this
as an error.

It'd also be better to split the voltage specs out into a separate
function, especially for the output voltage where obviously we have a
separate range based interface for setting that.

--mUrGsXPB0ppB5FvZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyT3jAAoJECTWi3JdVIfQTtgH/2vvIyBzzoZh57nh2XJWCJMd
JU5yapGrYo2x1saTuHEgxSdl1L9iXPxaC1PC5a6ZQmgS+QywjkQBGMHIUtpLdTPy
WsLPzEFamCjBYG5QtCJsPnM/iJTEmV0s30keIEJ8QWsrVVm817q37suDCpeQ4TqZ
WVzIv4HqQwV9M46n3mZntR/R8+WefL4MqwAfGrbpA+RVsHLCH0IPHLxyxxdpsP6O
h8/1m6By2OvOaUpnt+FBXzmjrnW84ZDMbgUuZT3SevSSb8/BCQVk2NY6Pv5YC8tH
VKvw2xYV4SjF52uNH+wEHfjY0KSg7sVlN6y2yOKyx87pv1dAlygYVTS+yM400xY=
=YJAY
-----END PGP SIGNATURE-----

--mUrGsXPB0ppB5FvZ--
