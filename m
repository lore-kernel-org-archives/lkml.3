Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKJEbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:31:47 -0500
Received: from ozlabs.org ([103.22.144.67]:48524 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaKJEbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:31:46 -0500
Date: Mon, 10 Nov 2014 15:31:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the driver-core tree with the
 sound-asoc tree
Message-ID: <20141110153132.259d49d9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7cmdIax9wmVRz0FiWbLQnfT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7cmdIax9wmVRz0FiWbLQnfT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
sound/soc/intel/sst-haswell-pcm.c between commit 2e4f75919e5a ("ASoC:
Intel: Add PM support to HSW/BDW PCM driver") from the sound-asoc tree
and commit 3c1af8802e45 ("ASoC: intel: drop owner assignment from
platform_drivers") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/intel/sst-haswell-pcm.c
index 7eb9afc9b33d,ad21e636edc6..000000000000
--- a/sound/soc/intel/sst-haswell-pcm.c
+++ b/sound/soc/intel/sst-haswell-pcm.c
@@@ -1173,9 -899,6 +1173,8 @@@ static const struct dev_pm_ops hsw_pcm_
  static struct platform_driver hsw_pcm_driver =3D {
  	.driver =3D {
  		.name =3D "haswell-pcm-audio",
- 		.owner =3D THIS_MODULE,
 +		.pm =3D &hsw_pcm_pm,
 +
  	},
 =20
  	.probe =3D hsw_pcm_dev_probe,

--Sig_/7cmdIax9wmVRz0FiWbLQnfT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYD+vAAoJEMDTa8Ir7ZwVousP/idXfKha9S0Te/FT6KwGnKiE
aIuwW/gs8OrFIckWM/ARsALtAqsZE5aWHwl6CT5jLdnuVd1/RjTBYKKNPDhHunnO
U+LfUgHDpi9fdrAe4OUac3aE6pXZSq8CdVb6DuBHoKoVFwinGWMD6yODUxIelKoi
OBCTJgoF1kCetH3TeIcj8t4wOV+Nhlnw+YW57oqpWFD9mheTBM4rIx0IN+ewN+OJ
XXjKB8erNiVSdeDYTtYBHWjkfrFuDze2ScG8KkppHMnjZCKtuNDJZ8tmQGKwRNJT
gJw/89CjN1roTHZYIgNxdtoEGvD41LtS6NB05Q6ZVYPXUqGX9UTo2S6hFTILO9L5
F09/FSxjGrjVY9rZdthinPtp0eNOE/PEc8AVsBkG3/5ENi1HqhHn8MZrKpRjCZb0
FfzoNAeGoXBfUTaFPGQ5A+cBx7JrRyWwkjnfVUmNimOZDRaZQcUsNE636rAtfGeC
V800qiwsQsHsl2nWGsy98v5cNyWCJBJr0rdOJTwxgtLJyS4xxTvxzfdbekvfAQsW
wXXtLkjivDpO3qiibkdx1VEFA5z2bxx8DewipHIJNTVK/AprEabiN0tqygAzZCH1
JOePWJvst8Y8bYNogakpxOIdtIM1+oD0I6f87wCwK/NU+x+YkaC9Ug84bVcMMjzj
76T1FaohO9UvZESxoMPo
=tsr3
-----END PGP SIGNATURE-----

--Sig_/7cmdIax9wmVRz0FiWbLQnfT--
