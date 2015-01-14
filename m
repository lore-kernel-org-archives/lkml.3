Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbbANMvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:51:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56795 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbbANMva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:51:30 -0500
Date: Wed, 14 Jan 2015 12:50:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jyri Sarha <jsarha@ti.com>, Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150114125056.GU4160@sirena.org.uk>
References: <20150112175705.GN12302@n2100.arm.linux.org.uk>
 <1421151718.4519.24.camel@pengutronix.de>
 <20150113122715.GP12302@n2100.arm.linux.org.uk>
 <20150113165411.5469930d@armhf>
 <20150113160313.GR12302@n2100.arm.linux.org.uk>
 <20150113200252.3dbfab14@armhf>
 <20150113192648.GU12302@n2100.arm.linux.org.uk>
 <54B574CD.9020905@ti.com>
 <20150113195415.GV12302@n2100.arm.linux.org.uk>
 <1421232418.3155.31.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9o1Xi4ZMQ45MudWG"
Content-Disposition: inline
In-Reply-To: <1421232418.3155.31.camel@pengutronix.de>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9o1Xi4ZMQ45MudWG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 14, 2015 at 11:46:58AM +0100, Philipp Zabel wrote:

> So the question is mostly whether four I2S data pins with a single
> shared WS/SCK input should be called "four I2S ports with shared clocks"
> or "one I2S port with up to four data lanes". I'd lean towards the
> latter.

Yes, this is what we're doing for the Samsung CPU side controllers which
implement this natively and seems to make sense here too - the different
channels can't really work as separate interfaces in any practical way.

> How audio2_i2s is forced to synchronize its clock output to audio1_i2s
> is a problem their bindings will have to handle.

Trying to hook up a controller that doesn't natively support this format
to a device that uses it is definitely tricky, as well as describing the
physical hookup we also need to worry about how things look to userspace
- it's ideally going to want a single multi-channel audio stream.

I think from a binding point of view we need a way to say "this endpoint
on the link is constructed from these DAIs on the device side" and say
if this is TDM or multi-data, and what's driving the clocks.

--9o1Xi4ZMQ45MudWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtmYvAAoJECTWi3JdVIfQt28H/1viMMw+EK2qHbR88BLH5iLi
9tbosp+jQxC+PTtsTI5YlUR3T/shxxV7+xA9D6wPezG2tyDghYicKvcDinxWGYnK
7wwtbmDBsRv69WPyeLNeZtZnTb4Oox5TYIYy1EtZluc1bYmpB3w1/MuOe4OU7ZdW
lkaOaL9pw8Bjx7ycw1rBIPbxszsOhDiQkrDkYKoKD3SlkCeSxtBAtJJG2Fas5AfS
yu8nGIGEI6f6EzXj4ry+j8/fAgftH+SMXj1/A+rOjFRWgjns9sCd8E9Sp2K7gEsl
wTgiBH1gecrvcQ3gnO492ZqfBvST+U2J0pzzDrOEKmLfck/2hoqLe884+yKdWgQ=
=pZEW
-----END PGP SIGNATURE-----

--9o1Xi4ZMQ45MudWG--
