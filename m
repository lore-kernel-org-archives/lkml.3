Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaEIDpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:45:09 -0400
Received: from ozlabs.org ([103.22.144.67]:58378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbaEIDpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:45:07 -0400
Date: Fri, 9 May 2014 13:44:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Micky Ching <micky_ching@realsil.com.cn>,
        Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: linux-next: manual merge of the mmc tree with Linus' tree
Message-ID: <20140509134455.07d7de4d@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/PjVaGnR.dlNJckWVZtyr8/."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PjVaGnR.dlNJckWVZtyr8/.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/rtsx_pci_sdmmc.c between commit 98fcc5762dce ("mmc:
rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"") from
the  tree and commit 1f7b581b3ffc ("mmc: rtsx: modify error handle and
remove smatch warnings") from the mmc tree.

I fixed it up (maybe - see below and in the final tree) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/rtsx_pci_sdmmc.c
index 0b9ded13a3ae,09340b9429ec..000000000000
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@@ -258,10 -375,11 +260,13 @@@ static void sd_send_cmd_get_rsp(struct=20
  	if (cmd->opcode =3D=3D SD_SWITCH_VOLTAGE) {
  		err =3D rtsx_pci_write_register(pcr, SD_BUS_STAT,
  				0xFF, SD_CLK_TOGGLE_EN);
- 		if (err < 0)
+ 		if (err < 0) {
+ 			rtsx_pci_write_register(pcr, SD_BUS_STAT,
+ 				SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
  			goto out;
+ 		}
 +
 +		clock_toggled =3D true;
  	}
 =20
  	rtsx_pci_init_cmd(pcr);

--Sig_/PjVaGnR.dlNJckWVZtyr8/.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTbE88AAoJEMDTa8Ir7ZwV3kkP/jk0ARYN9mVJFkiqC38pDqpM
ZYI/dJyWNTiWN4G5oQqL4mr0vAxLFWhG9QlaMwp3UjRtQieZbbNizgq6g6mR+OY8
Ua51N6XqC5HPchYuQWsS7eJg0bYhTZ/E8fVejncjeCGTKp+1FSeUwVWQF6/LrB/8
Mn+6L/ImbQDKi2IG5gggJKw6KwVV8PB4a1nhob61Amh0oIOs0Fbq0az5/onJ7jXG
KGtug0sg6c6Vv3bC6A3Br9wo6EdO6ZtzGeKo7ppr8xMFz1X7Q9ILYsaYLv4HLj1s
YN+Kp6sNXGMig56VJtT3FRjr4Y3xF1DrBuICwhKXQOBsLvHH3xS5Sj5XVwryaYld
XCbXNlI0Rma4vkKQBVH4Wihe+soRkumYoHTWm6kmVoF/PNQCsbIc5WGkIkziIbOK
1tH1JzrjVzmegYTxAiZ5lZB+lvDNevHzqXuwk8W24UlvbyanK0hESA/7ZTGC07d7
ZZSTWCB8OoFw8So0qqd0pb7nrgdB9rpkbmxz/zPcs1fAJS8KKhBJNp+jGiXWlUMO
oIKbseF0RcQZ36koe+/+VcA9yxoEXKiC0GU135YKPKMQ85oBzArgAUH4WR/7j1ZB
K6sLx4wUejgD+ctAGJ558aIVD3nw6SiRF9WU4tT/En6nx829LgoKN1azGUiQ+SOm
oi5PSBG/z4/U75vTeGhq
=VXDj
-----END PGP SIGNATURE-----

--Sig_/PjVaGnR.dlNJckWVZtyr8/.--
