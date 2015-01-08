Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbbAHSQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:16:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44865 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbAHSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:16:01 -0500
Date: Thu, 8 Jan 2015 18:15:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Ashay Jaiswal <ashayj@codeaurora.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Anirudh Ghayal <aghayal@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>
Message-ID: <20150108181556.GR2634@sirena.org.uk>
References: <1420723465-12045-1-git-send-email-ashayj@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XQVe3nzScD1ikyTV"
Content-Disposition: inline
In-Reply-To: <1420723465-12045-1-git-send-email-ashayj@codeaurora.org>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: core: fix race condition in regulator_put()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XQVe3nzScD1ikyTV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 06:54:25PM +0530, Ashay Jaiswal wrote:
> The regulator framework maintains a list of consumer regulators
> for a regulator device and protects it from concurrent access using
> the regulator device's mutex lock.

Applied, thanks but...

> +	mutex_lock(&rdev->mutex);
>  	kfree(regulator->supply_name);
>  	list_del(&regulator->list);
>  	kfree(regulator);
>=20
>  	rdev->open_count--;
>  	rdev->exclusive =3D 0;
> +	mutex_unlock(&rdev->mutex);

I'll do a followup which moves the frees out of the locked region
(reordering things a bit) - they're the main bit I was worried about
with time, they should be fast since they're just frees but it's easy
enough to avoid having to think about it.

--XQVe3nzScD1ikyTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrslbAAoJECTWi3JdVIfQircH/3PtYm1lJQdpQzy19YAvh8f8
pOMdz7iFHfqd+1y3qaSVZKiAE/p0qOf6vNEbuAMjlRXL37CUirPY8ktEv8+adirt
S8MxIEjtNTXACTjKSaPFFSjuL0uMvA/sWxDDCqeqokOEmt4kF8Hjd8ShhfXxtI86
KHGWkXXMLaw14zynH73//wvCg3wZbufIzPLZMyGeIwTEuLKhdhx8n8HgIqoYzGSs
RlVqQXt3zSDwsr4/gnzm7vRbPVC879EH9PrWSOojMBRbM7CtfcJHVLUAhleGc8CW
uUh5p0hdJnQF1T1QlUzElIC6Z4G1WymXodSrs3NX0pAVPvqQ/ClMVU4jleCmyRE=
=F0SA
-----END PGP SIGNATURE-----

--XQVe3nzScD1ikyTV--
