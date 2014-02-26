Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaBZCz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:55:29 -0500
Received: from ozlabs.org ([203.10.76.45]:46322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbaBZCz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:55:27 -0500
Date: Wed, 26 Feb 2014 13:55:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: build failure after merge of the libata tree
Message-Id: <20140226135521.047c301755d2bb44401e3ac6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_13_55_21_+1100_anEQrncZ=+8EAVZm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_13_55_21_+1100_anEQrncZ=+8EAVZm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the libata tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/ata/ahci_st.c: In function 'st_ahci_probe':
drivers/ata/ahci_st.c:159:8: error: implicit declaration of function 'ahci_=
platform_put_resources' [-Werror=3Dimplicit-function-declaration]
        ahci_platform_put_resources(&pdev->dev, hpriv);
        ^

Caused by commit 0d8d213703ff ("ahci: st: Add support for ST's SATA
IP").  That function is defined as "static" in another file ...

I have used the version of the libata tree from next-20140225 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_13_55_21_+1100_anEQrncZ=+8EAVZm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDVeeAAoJEMDTa8Ir7ZwVNb0P/AkI6Ur1vRq3u4Ww14omBmCO
mFL1k67D00iTFrD8FY0aKydX22jrLvkmEBgBgiLYfskucGE577kxwc6wtl/5ngWl
lbGF3BVKAWy6+5P+a5lWybnoN8mRNkJnANxZrHvvDX0hJnRGlFOTIntI5ensi55j
eJ/9lhhoJmInEpJbhManVMt5UwhQft1BWkabHURtxF08mOGj6epB6as92X0J8Nd1
l9z/m36jChXiZI1gR8jIws/IP1tB4sNRFCLydoWiaRmM72R8tVdY9dvoejB2m8iz
o9wMmKHvSWscZNlezTjfFXAwqIjUIt4Gx/o7IxGMLPiGm+Rd3fKqQ9PAz406GAlD
9k4+nkhdWTsIGkzfTS3EYuXwXIuPmpGRVrsrMcdIceYOSkVuk/TM3iryrirGklCe
Afa3zVz8xpSjI3UtCQheyZn3AAArB3yxxbXO717IJdCYvvmklJdzEPnCNXjUKAj1
qtRROhGe+/88dbVMzC63ZMC69T+wupfvFrM6KsYab3/UN/y6M7g+KQRT8ec0liar
AdhBkqhbkv+bG0CpUFy3wkOLspGXkbg8b68VwLDeMrKZnluS4Tv/IHD8yAcFLStF
gHOVWp2DGIL7FGY4AojRYD3kmXi+g6a3b8xoX9G5yAgiZGPc2CUf7S60elZd7ehZ
kyfG9L+yba1lDdAlN3uw
=rIZ/
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_13_55_21_+1100_anEQrncZ=+8EAVZm--
