Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936795Ab3DHKuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:50:46 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57542 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3DHKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:50:45 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH] power: rx51_battery: Fix reporting temperature
Date: Mon, 8 Apr 2013 12:50:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.2; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <20130216213248.GC1741@lizard.sbx05280.losalca.wayport.net> <1364488943-6481-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1364488943-6481-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1584136.4s9V5JOaFn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304081250.38814@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1584136.4s9V5JOaFn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 28 March 2013 17:42:23 Pali Roh=C3=A1r wrote:
> This patch fixing units (1/10 =C2=B0C) in which is temperature
> reported.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  drivers/power/rx51_battery.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/power/rx51_battery.c
> b/drivers/power/rx51_battery.c index 8208888..527d256 100644
> --- a/drivers/power/rx51_battery.c
> +++ b/drivers/power/rx51_battery.c
> @@ -119,7 +119,7 @@ static int
> rx51_battery_read_temperature(struct rx51_device_info *di)
>=20
>  	/* First check for temperature in first direct table */
>  	if (raw < ARRAY_SIZE(rx51_temp_table1))
> -		return rx51_temp_table1[raw] * 100;
> +		return rx51_temp_table1[raw] * 10;
>=20
>  	/* Binary search RAW value in second inverse table */
>  	while (max - min > 1) {
> @@ -132,7 +132,7 @@ static int
> rx51_battery_read_temperature(struct rx51_device_info *di)
> break;
>  	}
>=20
> -	return (rx51_temp_table2_first - min) * 100;
> +	return (rx51_temp_table2_first - min) * 10;
>  }
>=20
>  /*

Hi Anton, please include this patch into your battery tree.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1584136.4s9V5JOaFn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFioP4ACgkQi/DJPQPkQ1KzEQCdFOgc1IvwX3XjK8vDpQrBIKXl
1GoAn2P6eoDtMnEcV/r3JRlnEnJtm7NK
=YmBy
-----END PGP SIGNATURE-----

--nextPart1584136.4s9V5JOaFn--
