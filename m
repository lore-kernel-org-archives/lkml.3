Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbaCFCnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:43:39 -0500
Received: from ozlabs.org ([203.10.76.45]:41978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbaCFCnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:43:37 -0500
Date: Thu, 6 Mar 2014 13:43:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140306134332.0c3f12ec6849d1b2ccefda6e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_13_43_32_+1100_yQPDdRXmVATb.IL/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_13_43_32_+1100_yQPDdRXmVATb.IL/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdio=
_intr_rstatus':
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2464:3: error: implicit =
declaration of function 'atomic_set_mask' [-Werror=3Dimplicit-function-decl=
aration]

Caused by commit c98db0bec72a ("brcmfmac: Use atomic functions for
intstatus update").  Arm does not seem to provide atomic_set_mask()?

I reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_13_43_32_+1100_yQPDdRXmVATb.IL/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTF+DYAAoJEMDTa8Ir7ZwV/LcP/25XA+sSESm4S2Kno45SeZ5T
0Lpjv4sevCMF2gPI2bE3Xczy52YqTMPm1bdDbDSnEGdjgUWQGsRuCyQS+i/m2EM9
TkFcURSDgbAocw1Sdu0kKmuqDe8mpZVICQKMaouqjdZP0p5WCRVwlX6ss0jjCqL1
z5n4QA0RD6H8P07G02ceyjwQWju9x7EWSqfitJWU2VXvZ1CW76VuFV8JwnrO3GaY
d4XaC26Zxn+b9tss5SsI6IdNEuvK2MFi47s6AY6X7teyGTHtwF9/tJKmRn9shNBb
hG2f66MzxrUWgDA6YuPJ9w6f8lQnx1t89x/aelY9iRMxFtF8wWElA0lBJjVPrNpX
2ghlabfULk2fY6d2s3iL4/DGLcv5qeNO1A44go48wjQr7rShpDoTnN496yItEFvm
XuBUcbDc5/suMxVxykSvz12S9Dh35vEH6ZS/VSS3VBmebftvEMlar+QzdLyNPScc
JQT1/p56mlgHvN3Pvq+VGidZJgjfs8F3nndCUAVmM/kbU8ftV7gpJeBCQZHqQtZJ
j37qHIyt7PS1uC2oBY22nScrftUplog9X9xoszYDxBPzrzneiBYJfyEfrrR6g6Xh
C/qiGm4KYtLkoulrHXCzs8Aztfok9y84MqiaCiN22TVmDoRpURqKreup3wBLgfFD
Zq49U5i6ZXMrVrNHdL8e
=+Z3z
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_13_43_32_+1100_yQPDdRXmVATb.IL/--
