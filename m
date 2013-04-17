Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966468Ab3DQN4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:56:45 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56705 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab3DQN4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:56:44 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
Date: Wed, 17 Apr 2013 15:56:37 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-030900rc4-generic; KDE/4.10.2; x86_64; ; )
Cc: Kyle Evans <kvans32@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
References: <201304130331.18301@pali> <51699843.7060905@gmail.com> <1366129583.13667.11.camel@x230.lan>
In-Reply-To: <1366129583.13667.11.camel@x230.lan>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1415175.Y7FE9MHTc6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304171556.38832@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1415175.Y7FE9MHTc6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 16 April 2013 18:26:26 Matthew Garrett wrote:
> Can you try this patch?
>=20
> diff --git a/drivers/platform/x86/hp-wmi.c
> b/drivers/platform/x86/hp-wmi.c
> index 45cacf7..91cc5df 100644
> --- a/drivers/platform/x86/hp-wmi.c
> +++ b/drivers/platform/x86/hp-wmi.c
> @@ -53,6 +53,7 @@
> MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
>  #define HPWMI_ALS_QUERY 0x3
>  #define HPWMI_HARDWARE_QUERY 0x4
>  #define HPWMI_WIRELESS_QUERY 0x5
> +#define HPWMI_BIOS_QUERY 0x8
>  #define HPWMI_HOTKEY_QUERY 0xc
>  #define HPWMI_WIRELESS2_QUERY 0x1b
>=20
> @@ -284,6 +285,18 @@ static int hp_wmi_tablet_state(void)
>  	return (state & 0x4) ? 1 : 0;
>  }
>=20
> +static int hp_wmi_enable_hotkeys()
> +{
> +	int ret;
> +	int query =3D 1;
> +
> +	ret =3D hp_wmi_perform_query(HPWMI_BIOS_QUERY, 1, &query,
> sizeof(query), +				   0);
> +	if (ret)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  static int hp_wmi_set_block(void *data, bool blocked)
>  {
>  	enum hp_wmi_radio r =3D (enum hp_wmi_radio) data;
> @@ -925,9 +938,7 @@ static int __init hp_wmi_init(void)
>  		err =3D hp_wmi_input_setup();
>  		if (err)
>  			return err;
> -
> -		//Enable magic for hotkeys that run on the SMBus
> -		ec_write(0xe6,0x6e);
> +		hp_wmi_enable_hotkeys();
>  	}
>=20
>  	if (bios_capable) {

Hello,
I tested above patch and it fixing my problem. Now Fn keys working=20
again on my HP EliteBook 8460p.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1415175.Y7FE9MHTc6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFuqhYACgkQi/DJPQPkQ1JXIQCfa0pA6z+mhhBSNwnJc2K0elLH
GHkAn2ShEJGBZfAzHqclKgD0ZckUYVuv
=ylYv
-----END PGP SIGNATURE-----

--nextPart1415175.Y7FE9MHTc6--
