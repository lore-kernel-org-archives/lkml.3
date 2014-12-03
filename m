Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaLCTUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:20:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47418 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLCTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:20:45 -0500
Date: Wed, 3 Dec 2014 19:20:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, sonnyrao@chromium.org,
        heiko@sntech.de, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Message-ID: <20141203192024.GL7712@sirena.org.uk>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
 <1417591118-18695-1-git-send-email-jay.xu@rock-chips.com>
 <1417591118-18695-3-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JQobbgWnX7WjL0pQ"
Content-Disposition: inline
In-Reply-To: <1417591118-18695-3-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: rockchip: i2s: add support for grabbing
 output clock to codec
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JQobbgWnX7WjL0pQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 03:18:38PM +0800, Jianqun Xu wrote:
> From: Sonny Rao <sonnyrao@chromium.org>
>=20
> We need to claim the clock which is driving the codec so that when we ena=
ble
> clock gating, we continue to clock the codec when needed.  I make this an
> optional clock since there might be some applications where we don't need=
 it
> but can still use the I2S block.

I would expect that the clock for the CODEC should be managed by the
CODEC if at all possible - that seems more logical than having the CPU
I2S controller request and manage it if it's a separate clock.  Why add
this to the CPU side driver?

We've not always done this for older systems due to the lack of a usable
clock API but that's starting to be addressed.

--JQobbgWnX7WjL0pQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf2J4AAoJECTWi3JdVIfQpDUH+QGvbqNNpYTTeH9BR7l1M2F1
Zbiy2YsxaimSZggqRO1wIKuXgiikPtNctuduDCCN9feAWkjvvh5qPfo2gTE3EMw/
p4PHfrozU/7NMhkZ4bJwneTMg2/Cs4YTMKpEYF1VD8rDZvyR4OzGswTNnJSrBX4Q
bYLL0NyUb/hQUIHzAF2VAU6ffbjPXJvrAmzolEp7ujsuRq3qpRDtU8hiScaUpUG2
8sluxjAaNbtMpB6ycQUx8ImIf48z3uRLrPK8mQW8THX1d/tFBtqk2ZBI0xNSdV8T
8lowjJ2p+9y15mhDLOrOZg1N2Toh6Uo6VK/xfSFRUNYUw4FSUyDrvRHp74J3YAA=
=2pcn
-----END PGP SIGNATURE-----

--JQobbgWnX7WjL0pQ--
