Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFWBtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:49:50 -0400
Received: from ozlabs.org ([103.22.144.67]:38223 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaFWBtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:49:49 -0400
Date: Mon, 23 Jun 2014 11:49:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@intel.com>
Subject: linux-next: build failure after merge of the crypto tree
Message-ID: <20140623114942.6a937466@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/q6Zz=5V_d.m099D7ehHsv1U"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/q6Zz=5V_d.m099D7ehHsv1U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

After merging the crypto tree, today's linux-next build (x86_64
allmodconfig) failed like this:


drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:47:31: fatal error: =
adf_accel_devices.h: No such file or directory
 #include <adf_accel_devices.h>
                               ^
drivers/crypto/qat/qat_dh895xcc/adf_isr.c:54:31: fatal error: adf_accel_dev=
ices.h: No such file or directory
 #include <adf_accel_devices.h>
                               ^
drivers/crypto/qat/qat_dh895xcc/adf_drv.c:60:31: fatal error: adf_accel_dev=
ices.h: No such file or directory
 #include <adf_accel_devices.h>
                               ^

Caused by commit 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc
accelerator").

I have used the crypto tree from next-20140620 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/q6Zz=5V_d.m099D7ehHsv1U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTp4e7AAoJEMDTa8Ir7ZwVp6cQAIsdfCr660Y70YakIYB6Lr+4
U3FPdUxw2KbiPSsYwes6ImvU5y/zUkuvazXEIXBPH7S6zx2MTiaBrRFFh8Sag/S1
Aab7mfjeFAM9ewVstiKbyhoNNIeAmAHfFdmcfKQaXC0LNNPuBjCabs4k10BXHbmC
3bJhYVzyPU5Uh766HfvneYr3dILDje6bcLZpZDRKCvmJKJuOq9eSE0i1egfwu1+c
5ep6hzhCbYHUpMd4eiS8dksGP125NViekirEOCOTFP0ZfaN6T5TcIJ35yT8v9Jia
QL0fIH/5/gBuGpnWey1lUl/y3yE4ymRVDQ9A3pArwXbNzTHBEmkIhmcIKmDObNI6
mAe5c1LcW1hsJAzHImypL45a1Y7wvKC+8wMluiog8BrdLlOCP4oOla3H8fTVaUlR
pr6dyL0r48aoZEfLjOhPhqi7ZbnkQYnNOwendlsRf67fbO/i4sNRLA8PH0SK/lv+
r+R4PruRQonjXtpsUZH67FzZyaguUjLy7yrdCX/kAAuJ+IIYavKY6Wa6By9jppF0
SwbhhbptovtHDut4eajEoZUNBQEHw1Mw0bBLpVeNOPBc617SvLiNs8GhRixrIZlv
EChu8VA9ZBZDnuAYLyz9LNqtCJYx1PXvz7UMQodIu+XQnH0dOA5IQifPRNDofrqU
C0uMAzJeAisjhd4MrAN+
=QEiN
-----END PGP SIGNATURE-----

--Sig_/q6Zz=5V_d.m099D7ehHsv1U--
