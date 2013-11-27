Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3K0S3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:29:13 -0500
Received: from sauhun.de ([89.238.76.85]:60792 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab3K0S3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:29:10 -0500
Date: Wed, 27 Nov 2013 19:29:02 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, patches@linaro.org,
        linaro-networking@linaro.org, linaro-kernel@lists.linaro.org,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: davinci: raw read and write endian fix
Message-ID: <20131127182902.GA16550@katana>
References: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2013 at 08:23:44PM +0200, Taras Kondratiuk wrote:
> I2C IP block expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>=20
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
>=20
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>

Applied to for-current, thanks!


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSljnuAAoJEBQN5MwUoCm2qXIP/2HMNusq/Z2UEkxgIdoIkF6N
AkyojhSLI7OfvRFuSvQEsbO+g1HnMy/ok0e38pYjiqTfL9W2znHJhDu5FvYTzlWE
VHsiTqStfpZFgjloIKsP2gqA7BpBZEPkU7Vwsv/wFIqAE6PMmqavpfCCFxZ1HLJx
sFuTtRc41ZzWhx0CAgClN9D0QFl2QasqYWzpAljsQtgwfwtds1xLpYxkeUCJCWBQ
vc7RgHF1SuXLSooYgAme7AXKC5T/+U2k2IN32SoCIFoX2uWqaQS5bACGSLZhCEWs
74o7mq78nzTjoeFSHaaiJxcfdB/fXe8U9jILugbbPJvQUa1Vkkjv78dvxYoYufup
veBO2r6t1QSiM7BHXRBq97YN6DSd9sxjJFOMTGnBGF+xCIEgkDA9vQOpFqHaxweB
1z2QYjKL7PubHqxRP/NtvE2Tv2ZzdeKOgr59wqe9wzGZwhgrwvyjda53cezC+EJM
tQw02BB+0/9MiIdEw/fhuhMCNClXo9Uiz/CRTToOCETvA7Skp1bY0M3bYvSlFkrp
HkJ7B5c4RJRmfnoMjHRKhzZb9qz3t1wT6puiRYTR8sPEav0+kTQrN1yYvwKRUp7n
J3RbCxqhsqd85F1+sFveNPvFS9agqTa5lCP4BwVZTCwU6zxAU3jvhBzHaNw4dI5Q
tK4FdXQ2N66v1SZMMVdu
=z6Gd
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
