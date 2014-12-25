Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaLYIcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 03:32:47 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45724 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaLYIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 03:32:44 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Nishanth Menon <nm@ti.com>
Subject: Re: v3.19-rc1 regression(?) on N900
Date: Thu, 25 Dec 2014 09:32:40 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: "linux-omap" <linux-omap@vger.kernel.org>, pavel@ucw.cz, sre@debian.org,
        sre@ring0.de, aaro.koskinen@iki.fi, tony@atomide.com,
        ivo.g.dimitrov.75@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <549B44E2.6080202@ti.com>
In-Reply-To: <549B44E2.6080202@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3982783.nH4CNfp8MO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412250932.40403@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3982783.nH4CNfp8MO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 24 December 2014 23:57:38 Nishanth Menon wrote:
> based on automated testing with u-boot as a chained
> bootloader..
>=20
> v3.18: boots fine:
> https://github.com/nmenon/kernel-test-logs/blob/v3.18/omap2plu
> s_defconfig/n900.txt
>=20
> v3.19-rc1: hung
> https://github.com/nmenon/kernel-test-logs/blob/v3.19-rc1/omap
> 2plus_defconfig/n900.txt
>=20
> in the interim, my farm had a bit of breakdown around the time
> of n900 breakdown..
>=20
> as per my last functional linux-next logs:
> https://github.com/nmenon/kernel-test-logs/blob/next-20141204/
> omap2plus_defconfig/n900.txt -> hung.
> https://github.com/nmenon/kernel-test-logs/blob/next-20141112/
> omap2plus_defconfig/n900.txt -> working.
>=20
> DEBUG_LL, CONFIG_DEBUG_OMAP3UART3=3Dy and early_printk did not
> yield information either
>=20
> Note: I am using the combined uImage+dtb image.[2]
>=20
> I think this might just be my setup..(i use chained loader ->
> NOLO->u-boot->serial download->kernel) but anyways.. Since
> Pali thought others might be interested in sharing
> experience...
>=20
> [1]   http://slexy.org/raw/s2osxhhwbR
> [2]
> https://github.com/nmenon/linux-2.6-playground/commit/177f5f71
> b3f21ea484ee4b09a2e0c015de522417

CCing other people.

I see same problem in qemu with 3.19-rc1 kernel when doing DT=20
boot. In qemu I'm using direct booting from OneNAND (X-Loader -->=20
NOLO --> kernel) without U-Boot. After NOLO load & boot kernel I=20
do not see any other output from serial console. Also on qemu=20
screen there is no new output (just NOKIA logo from bootloader).

I do not have this problem when doing legacy/board code boot with=20
3.19-rc1 kernel, so this problem is related to DT.

Kernel 3.18-rc1 worked fine for both DT and legacy boot.

Can somebody look what broke DT booting?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3982783.nH4CNfp8MO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSby6gACgkQi/DJPQPkQ1KAHACfWND8P4rKtlIfii9F/7J9ATzb
Vn8An3kKKhrqVkJQ5bZtnoPXUiXNSP1N
=ngTb
-----END PGP SIGNATURE-----

--nextPart3982783.nH4CNfp8MO--
