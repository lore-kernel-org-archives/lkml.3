Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaHVVHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:07:50 -0400
Received: from ozlabs.org ([103.22.144.67]:46318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaHVVHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:07:49 -0400
Date: Sat, 23 Aug 2014 07:07:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: linux-next: build failure after merge of the pwm tree
Message-ID: <20140823070737.371f09fb@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//nJ0M/NQMUUAeP11+vmtLNn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//nJ0M/NQMUUAeP11+vmtLNn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

After merging the pwm tree, today's linux-next build (powerpc allyesconfig)
failed like this:

drivers/pwm/pwm-lpss.c: In function 'pwm_lpss_config':
drivers/pwm/pwm-lpss.c:81:2: error: implicit declaration of function 'readl=
' [-Werror=3Dimplicit-function-declaration]
  ctrl =3D readl(lpwm->regs + PWM);
  ^
drivers/pwm/pwm-lpss.c:87:2: error: implicit declaration of function 'write=
l' [-Werror=3Dimplicit-function-declaration]
  writel(ctrl, lpwm->regs + PWM);
  ^

Caused by commit 28160b18787b ("pwm: lpss: Properly split driver to
parts").

I have reverted that commit for today (and 06c7b5394e21 ("pwm: lpss:
pci: Move to use pcim_enable_device()") which depends on it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_//nJ0M/NQMUUAeP11+vmtLNn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT97EfAAoJEMDTa8Ir7ZwVzxQP/2Sqz8OZeTj9FEoHFydq5dKx
yiu2CTJQFL4xxuOHZyZq4rqzhRlGvTyqupPi2pDKGXHLMZxx2pyfvdmV9X2YpAz/
eCZJOwqEzZj3FbEvxmh2/PP7eDi30gm7hpHpPTpxculsDPscTmJN0c3DTulQUSBn
2sYCG0M3kA1uXV3exUC9PnEr4xfwZ89BWQF9Gpvtq7LYZZ2gPE4xSX1XiJ3L7beV
Eb1pSYpu6e70Gzo00v2bs9XtUbMikenD8O7sA06N0eYlLVzmMWOn50y8u7tyzmwY
wPvpFRCLCwmzz/Hfg5qZNWdg+gnqUoKep2Gi4RiVH+FM3N9O2rIimKNzSOkqNZnb
B6Zxek9HMsr5aM/DBH9kUbDIEb+dPtzo0pCun9XMbS4PCJ2QGRM04yApfJ3Y2Upt
C7rD4XHI9SxXOyFNDWsDGBZSY7qXnrdZNht/uCXLmIV7xiaomOsL7OcqmOk8LJVu
R3KBRQ1zhwFFF5O7A4mTSQ20JWapVXRH4vQZCdeekPAkjvdfrkFIW2zMKuGwiTm1
ic3ZF79bTt3OOsN343Up/T4iKUI1wmL/AsEoLI/nz/BtE5xg44K/PDwhW7BG0kNo
laSIV5Mc0hsZ+jk0lTPlybrGVNSSR5FDf+c13lk/bQAvtHS+6wc65BU1TEycCRlK
pC6DfkGqueRpYuaB25a1
=MTop
-----END PGP SIGNATURE-----

--Sig_//nJ0M/NQMUUAeP11+vmtLNn--
