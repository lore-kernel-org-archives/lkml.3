Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab3JON43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:56:29 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58887 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254Ab3JON40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:56:26 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] bq2415x_charger: fix max battery regulation voltage
Date: Tue, 15 Oct 2013 15:56:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
References: <1380709462-860-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1380709462-860-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2163547.AFlqKWErlh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310151556.23557@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2163547.AFlqKWErlh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 02 October 2013 12:24:22 Alexandre Belloni wrote:
> As per the datasheets, maximum battery regulation voltage is
> 4440mV.
>=20
> The formula is (voltage - offset) / step, so the maximum value
> is: (4440 - 3500) / 20 =3D 47
>=20
> Signed-off-by: Alexandre Belloni
> <alexandre.belloni@free-electrons.com> ---
>  drivers/power/bq2415x_charger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/bq2415x_charger.c
> b/drivers/power/bq2415x_charger.c index 0727f92..0aa643e
> 100644
> --- a/drivers/power/bq2415x_charger.c
> +++ b/drivers/power/bq2415x_charger.c
> @@ -607,7 +607,7 @@ static int
> bq2415x_set_battery_regulation_voltage(struct bq2415x_device
> *bq,
>=20
>  	if (val < 0)
>  		val =3D 0;
> -	else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max
> value ? */ +	else if (val > 47)
>  		return -EINVAL;
>=20
>  	return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,

Right, max is 47 (101111) and not 94 (1011110). But if you set=20
all six registers to 1 then you get 63 (111111) and not 122.

I do not know from where I got above bad values, but you should=20
add comment to code that according to datasheet max value is=20
4440mV (101111) and not 4760mV (111111).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2163547.AFlqKWErlh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAlJdSYcACgkQi/DJPQPkQ1IUawCfY6Hlbi+RTkNI2xeDJjt8nFAk
t8AAmNaenMh3wWS07TzWqKB+K5zbv5Y=
=GId1
-----END PGP SIGNATURE-----

--nextPart2163547.AFlqKWErlh--
