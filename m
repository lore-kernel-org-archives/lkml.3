Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaJMKzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:55:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50241 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaJMKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:55:13 -0400
Date: Mon, 13 Oct 2014 12:54:50 +0200
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Message-ID: <20141013105450.GQ27755@sirena.org.uk>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-7-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PE0DJtTPNVbxyIcY"
Content-Disposition: inline
In-Reply-To: <1412845377-17134-7-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/6] regmap: cache: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PE0DJtTPNVbxyIcY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 05:02:57PM +0800, Xiubo Li wrote:
> When all the registers are volatile(unlikely, but logically and mostly
> will happen for some 'device' who has very few registers), then the
> count will be euqal to 0, then kmalloc() will return ZERO_SIZE_PTR,
> which equals to ((void *)16).

Applied, thanks.  I'm assuming there's nothing affected by this in
Linus' tree which needs this as a fix immediately?

--PE0DJtTPNVbxyIcY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO696AAoJECTWi3JdVIfQ8wQH/Al8YbZ7PmEAzr5C+fuMQGW+
X0dWW0Qup32Nxks5Ds2RegCAVlmfhiAYIJi+3J8AVTqTFZfGmbDNMWXkurMCVQke
cL+4erYDQLqoMXbki212cSQhzOL7u5xox5UAEAi44TckZh+rHRcX6Pn/d3s/TGCl
lNaVf/wwQ3oh9/vXOupKrKEE/TzQ8PtA6kRkGbRZEzOhkAXQd1VNeITvPly7oZKz
5XZoTKXxD6oK4NeEI8/oWzCskdjhpAFU0g241u6h7eyBCR5So60UGQddLfUxguYk
IGCSwgA7P8RGO6/AL/RX7Pmu8ELiFT0sh02HFsNoZsQdePLUlzwjel2ebdBji/8=
=bGs9
-----END PGP SIGNATURE-----

--PE0DJtTPNVbxyIcY--
