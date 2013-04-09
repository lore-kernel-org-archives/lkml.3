Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936965Ab3DIHlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:41:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49472 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3DIHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:41:01 -0400
Date: Tue, 9 Apr 2013 17:40:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Archit Taneja <archit@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20130409174047.c506479e08e9688c0a4ced9a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Apr_2013_17_40_47_+1000_x7QlJ2ZkP+gjyzVo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Apr_2013_17_40_47_+1000_x7QlJ2ZkP+gjyzVo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-2430sdp.c between commit 3b4ece75b9e9 ("arm:
omap: board-2430: use generic dpi panel's gpio handling") from the
omap_dss2 tree and commit 5b6513d27775 ("ARM: OMAP: fix typo
"CONFIG_SMC91x_MODULE"") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-2430sdp.c
index e551aae,cb0596b..0000000
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@@ -135,7 -146,27 +135,7 @@@ static struct omap_dss_board_info sdp24
  	.default_device	=3D &sdp2430_lcd_device,
  };
 =20
- #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91x_MODULE)
 -static void __init sdp2430_display_init(void)
 -{
 -	int r;
 -
 -	static struct gpio gpios[] __initdata =3D {
 -		{ SDP2430_LCD_PANEL_ENABLE_GPIO, GPIOF_OUT_INIT_LOW,
 -			"LCD reset" },
 -		{ SDP2430_LCD_PANEL_BACKLIGHT_GPIO, GPIOF_OUT_INIT_LOW,
 -			"LCD Backlight" },
 -	};
 -
 -	r =3D gpio_request_array(gpios, ARRAY_SIZE(gpios));
 -	if (r) {
 -		pr_err("Cannot request LCD GPIOs, error %d\n", r);
 -		return;
 -	}
 -
 -	omap_display_init(&sdp2430_dss_data);
 -}
 -
+ #if IS_ENABLED(CONFIG_SMC91X)
 =20
  static struct omap_smc91x_platform_data board_smc91x_data =3D {
  	.cs		=3D 5,

--Signature=_Tue__9_Apr_2013_17_40_47_+1000_x7QlJ2ZkP+gjyzVo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRY8X/AAoJEECxmPOUX5FEOlwP/0LkrImgJYl7Y5dgtlNW5b7W
44I/ZzeRtpWzz56EXgungZUHw71HTYiH4asovBqSwW52qxVItBqekq+qGb2nf1v2
zShRvFdLPfkuDCep6sc+sePmqsDVMzvD/pPFaFu+OpEnVj3YmFLhDFZcIWE1QQRf
EzYARMfFD6Q0UaIa4B/TuCnQcgES+KcqzzU+nY0b4LLBOHvppotq10crcPWXFB4L
BPZh4pc/1Ui4+/UawW5cLWdToQZThmp5zEURmtY5AIZvbzzmopXQRsct2M+U5rhJ
/oEXFuxOoNByuGTDStqJTP1T6LCxCmrOBDFkBhsDHZLRB17ACWCr+K88bxuDdTYN
942awfbz+LeHjDTWBNZ+HH1cEl3CJ/pqzohu2+xPbh6DfE+80bJxzxwCXEiirTBW
H+tPNXVuJoYuZr5rq0c3+aVCbRoFCnXWqW/Nn1y8Lj+JGHHjYHPNE7JA9REv2PEf
fS+rprt+dUGxE4xIBgoxFY/7bCn0WdQQe5HCcePGIuFn44Nm4hNX8r+1T+59uGeZ
Xvno4DA15Tl0WFkEo9dRt1gNMCbbgjVgt4u4PxnI8ZThsSkvTRNTcup1tnEJ4In2
0D/udKsou48VUpI7l7vvmSGrPwBuNV8nXnsQDp23MhvTLQV2zzUl16fl48LMbZrN
3lNMMi0hyrGePODR0EEX
=BvpW
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Apr_2013_17_40_47_+1000_x7QlJ2ZkP+gjyzVo--
