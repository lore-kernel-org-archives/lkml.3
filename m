Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaJ0Rnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:43:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:52885 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaJ0Rnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:43:45 -0400
Date: Mon, 27 Oct 2014 18:43:38 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] power: bq2415x_charger: Properly handle ENODEV
 from power_supply_get_by_phandle
Message-ID: <20141027174338.GA10897@earth.universe>
References: <1413383110-20310-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1413383110-20310-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 15, 2014 at 04:25:09PM +0200, Krzysztof Kozlowski wrote:
> The power_supply_get_by_phandle() on error returns ENODEV or NULL.
> The driver later expects obtained pointer to power supply to be
> valid or NULL. If it is not NULL then it dereferences it in
> bq2415x_notifier_call() which would lead to dereferencing ENODEV-value
> pointer.
>=20
> Properly handle the power_supply_get_by_phandle() error case by
> replacing error value with NULL. This indicates that usb charger
> detection won't be used.
>=20
> Fix also memory leak of 'name' if power_supply_get_by_phandle() fails
> with NULL and probe should defer.

Applied to next.

-- Sebastian

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUToRKAAoJENju1/PIO/qaGRQQAKUdqO8qigV7WeaJy3rBvwfs
2wTZdoMCFlteBYybwvUdPzMiyzmB1ZFCgADgfCujnvV1JwBqUawPY1F+FxpWte8Y
JdLEGkt6LS36iklNIT8NTOkiKJYeFDfia9J8fgx6eT1cS9AdH61cy0OpSX+EstD5
sKh+MZsZJFT9glc0nIFY6/VJYhzyQUKTAOnWkUVF/Q/r7uYLrUAvQXfoadNvvovP
QHRL73uWsPvVRgTF7yETMjE4tudHa9vstHFoenfxQttw3ypMheJ5GiDVBkiLesNM
Wfh/m8VEcd/TQXz4mYXAwpFKyQlN3jsMmkryTp8VPqPF/Glb+K9C/thBvWxHtWo/
xsuDHpYH8rIS4jB+kfjzLxJKi1ZzZD/wM/0wAVcRqI8SSKkz6/Xtj71Xoh+2vyN6
AH1D2FaR5fL2DGy7b5d2fI76ODhiOJ49/KH1PVh+AkYjxevUPDAF6N2FHxbCduQM
U/5FqY6s9pqMWOezYwvx1ieQVRW0YdpHWNMQgFycRUEOprytC+FiuNnkSlGz0qqm
bAJvJ4Mk6RTUY85ETIjbEtsVzI9ODmfhKiM2Fl2G3HzTd5ZtpygLizpNSv9gaRAr
mdnSwCPBodOGTPgJvUCKDhnqYor/gJBZragCRtbkYeDATB/IhUs+eGfHWd91p2M5
K+3ZsjsMjjKV6xE1MXRh
=5TBn
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
