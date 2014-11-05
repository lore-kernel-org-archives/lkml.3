Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaKEEhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:37:14 -0500
Received: from ozlabs.org ([103.22.144.67]:58374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaKEEhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:37:11 -0500
Date: Wed, 5 Nov 2014 15:37:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amber Thrall <amber.rose.thrall@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-ID: <20141105153704.3af595f9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Stqo7ads/1GeHnF.8WcoN1d"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Stqo7ads/1GeHnF.8WcoN1d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/media/lirc/lirc_sasem.c between commit f3a75505ab5f
("[media] Staging: media: lirc: cleaned up packet dump in 2 files")
from the v4l-dvb tree and commit eca6a8872a04 ("staging: media: lirc:
Use pr_* instead of printk") from the staging tree.

I fixed it up (I just used the v4l-dvb tree version - see below) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/lirc/lirc_sasem.c
index 2f0463eb9887,123ddf68b587..000000000000
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@@ -581,8 -582,13 +581,9 @@@ static void incoming_packet(struct sase
  		return;
  	}
 =20
 -	if (debug) {
 -		pr_info("Incoming data: ");
 -		for (i =3D 0; i < 8; ++i)
 -			pr_cont("%02x ", buf[i]);
 -		pr_cont("\n");
 -	}
 +	if (debug)
 +		dev_info(&context->dev->dev, "Incoming data: %*ph\n", len, buf);
+=20
  	/*
  	 * Lirc could deal with the repeat code, but we really need to block it
  	 * if it arrives too late.  Otherwise we could repeat the wrong code.

--Sig_/Stqo7ads/1GeHnF.8WcoN1d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWal1AAoJEMDTa8Ir7ZwVpgkQAIrxoOyKI/77M3U7YcHxUgoD
MPIMVhloopqUDSesvpmqpXb+BWNjsqvhdd7HJyKWyqiJKIf0EgoNL2gpUiCCrwPu
4lM3Tks9VrB9/ABAR0Ka7i5bRFj6BL5shdmU2hRXQXZfxN4N69uaAtZBX0Ma4Fag
67tnUrmaFdbtqpdR834UMd5hKPpCgThJNCJb18OMVTRWqP/QkYF8leYA0EUDXB90
m3mAikP5LqEPcSjhTfi2RdNdsleoxKAPgPhpquro+RXzjFGM/Gbu9kbiE5w+8zzm
NaIZpcSXFz4gLoA/e8I2cmFD6XQXojkAUqhpFyNQE/wFkj5r74acMD4ZRxEAUWt8
E6kQtr499R5w20dm3rEVVdNqtM7qBFKQl4wjkc7MXkBzAmEtfyw9pHkQvlk5htX4
1YfR+EaAe5Xar4x53gmlMbhKHx2Bhr63JAmytBRdQSzk1szVIXRBGD+XJ6NiXbcR
3IBTsPH2o+ypgpHJsDP8J8OO2JA67Qn7yOJAh/2+oUqjii2lunNswPbssh2NpjXA
AamjUrY2vavYBq4rTdh/iiQUSjtq3fvV+j9/VW3MbdaL7FuZl6MLWhnifvMKSRh3
HWFYLodhkMGnsCvIEnaOWIOxIMAAGGQoiRIJfeDxv8C70mAJI34KEeX4pOFnafZB
pti1NXU0F+pbq9Znv7Xb
=EOrr
-----END PGP SIGNATURE-----

--Sig_/Stqo7ads/1GeHnF.8WcoN1d--
