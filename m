Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3KRNNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:13:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3KRNN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:13:28 -0500
Message-ID: <528A1272.5060905@ti.com>
Date: Mon, 18 Nov 2013 15:13:22 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        <linux-omap@vger.kernel.org>
CC: <linaro-networking@linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 03/23] OMAPDSS: raw read and write endian fix
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org> <1384560086-11994-4-git-send-email-taras.kondratiuk@linaro.org>
In-Reply-To: <1384560086-11994-4-git-send-email-taras.kondratiuk@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="33kiFDp1ikqsBMNg4htjFshQ4ATeeU8Oq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--33kiFDp1ikqsBMNg4htjFshQ4ATeeU8Oq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-16 02:01, Taras Kondratiuk wrote:
> From: Victor Kamensky <victor.kamensky@linaro.org>
>=20
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>=20
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
>=20

Looks fine to me. Quick test with o4 panda works fine.

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--33kiFDp1ikqsBMNg4htjFshQ4ATeeU8Oq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSihJyAAoJEPo9qoy8lh71+NUP/1m1RwKvK3huisQeWvEw7+wI
s0BDaaApbGboGavEtINAkdLoY295IrszG7hNMJ9zVk0k0+4zgmdCsoVn7oSuzMM2
YgC1pfWAbGt/VJwO+ZXb5oxl0QlzMJwqsG7WikibxcUVeRYR2atrIjFU444M0yi2
86Ywnz0V4ymJPPh7oQSK4h8olOq0JjY89/1QxVtDJYGwKXuVwZDT2ysDtvQdEcrL
+tS1rmVlwbv3KSoHJsNltMHWQl2N31DJP9yd905OY8Fx9VUFfpQxnsCMsvU9xzNA
5wl5G2oaqe+JVKNgeIRsuPX8/ON/kSiG+aq3VPkb9AU2pThp1KILiG0fEG+hN+z8
okG1YtQwlb/8azXXnjHgKgPFiD00VKt58BqFmQTeyGtDwFkwflhVc1cljNf6OFZx
A3N/G4uccRXsGErSAjg6vlm3OyiOnF4sNNzFsnpBQZUyjgR2BYLr5N8RR9zlkOgW
j7dOnaP1ZXGtD3wKlgBZPxRFlxM9wqoSJD+lpt+Y9P7eD2+S1kcBz/u/4/6U8yyX
jeLu9IFs5aAvzzeX6rcNrMAoU53YHIY+5sTnVyuLjsMFYhyrFp/b6wwuy/b08rfX
SFI7klMNSf3q/Urkjn6Rbrgj/Zu3CpbN9cVGlfXmq33c9zeqm6i0JRFlMY57xpDR
1+Jg47MGlvengt62ReL5
=99tS
-----END PGP SIGNATURE-----

--33kiFDp1ikqsBMNg4htjFshQ4ATeeU8Oq--
