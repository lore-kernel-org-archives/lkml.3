Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3KZMjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:39:45 -0500
Received: from sauhun.de ([89.238.76.85]:52326 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab3KZMjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:39:43 -0500
Date: Tue, 26 Nov 2013 13:39:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, patches@linaro.org,
        linaro-networking@linaro.org, linaro-kernel@lists.linaro.org,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: davinci: raw read and write endian fix
Message-ID: <20131126123934.GB7427@katana>
References: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
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


--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlJaGAAoJEBQN5MwUoCm2RkQP/ivFJqKxoUQg6fHiZQ7/Gx8j
qhe4XrmwSAhK6IrfztgRTDyrzB5kNa11Uj0mcX63dSnRUllOPsnGnn6XMNbQzu/a
QZqztrlB9QF5PEgddLn48I04ARm5xKlMp9iS9RM8+sh/qpcWc5aNGmoQdGtPfRgB
vqF72XFvNjrlpO7omo3oT5Lvcc6dpNP//RWeYB6t68GvNxzbaXLMtCVV4YOLGU6z
0K6TKkpQVZ4h8VURHObnqV3CygP4XfU36/9OInQAjtWS/KwPCvFoDEnyP4kWWXIz
ElDvFiBoVY9WK+tFty00+1vBRvSdn8sVhy+uIafaLsBkAc/KQa6ooewLmM/I/mLq
S3RcLL773AKrxMttCVvORwheUiScLmSHRBJcfPJjW0gIk3Pk/Lnlq6S/VwnUjs+C
Ov30LMjnWs6UpGtUVt9whmlwoOy0E3lnpp/5k+fnOd3A7lzvBYavtWINPTGqHnWX
Te37PVTHf41Ihk7cEIkpAir7K1oHoN/037jxxFdKMQbL/u1F1M6Dg9wRiXH8HHm9
QS/wsPPnTtZqjwTO3YWfHWH2NMAEaXoTBagxwhIFf4xcMg2mrVEt1cDWGDgb6p0s
Vse74Y/oH3w5AIYiwaiXnnkEzvC3ckWMCeHuMVJsHKcs5m1nSUtlcEjbfJt1KejB
Hw6gXSqTCtPJ5YDDSqSb
=kyNw
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
