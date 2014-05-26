Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaEZARv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 20:17:51 -0400
Received: from ozlabs.org ([103.22.144.67]:51007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaEZARu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 20:17:50 -0400
Date: Mon, 26 May 2014 10:17:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-ID: <20140526101741.102768b2@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=AkyU_JTnP6a=eUdbdpBUAe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=AkyU_JTnP6a=eUdbdpBUAe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/Kconfig.debug between commit 7098cff2a3f4 ("ARM: debug: qcom:
make UART address selection configuration option") from the arm-soc
tree and commit 1899de289497 ("ARM: S3C24XX: use generic
DEBUG_UART_PHY/_VIRT in debug macro") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index 6ff3dc661fdd,4678870f8ee8..000000000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -966,10 -1007,10 +1003,11 @@@ config DEBUG_LL_INCLUD
  				 DEBUG_IMX51_UART || \
  				 DEBUG_IMX53_UART ||\
  				 DEBUG_IMX6Q_UART || \
 -				 DEBUG_IMX6SL_UART
 -	default "debug/msm.S" if DEBUG_MSM_UART
 +				 DEBUG_IMX6SL_UART || \
 +				 DEBUG_IMX6SX_UART
 +	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
  	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
+ 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
  	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
  	default "debug/sti.S" if DEBUG_STI_UART
  	default "debug/tegra.S" if DEBUG_TEGRA_UART
@@@ -1057,8 -1102,7 +1101,8 @@@ config DEBUG_UART_PHY
  	default 0xfffff700 if ARCH_IOP33X
  	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
  		DEBUG_LL_UART_EFM32 || \
- 		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
 -		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART
++		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART \
 +		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 =20
  config DEBUG_UART_VIRT
  	hex "Virtual base address of debug UART"
@@@ -1118,8 -1166,7 +1168,8 @@@
  	default 0xff003000 if DEBUG_U300_UART
  	default DEBUG_UART_PHYS if !MMU
  	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
- 		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
 -		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART
++		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART \
 +		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 =20
  config DEBUG_UART_8250_SHIFT
  	int "Register offset shift for the 8250 debug UART"

--Sig_/=AkyU_JTnP6a=eUdbdpBUAe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgogrAAoJEMDTa8Ir7ZwVI3YP/A5H4F0s23vSfjNAxugBp7KG
RRB1cDOI6Qvx18m3JRtjb5Awqi+JEPCc9uh1T+hIA/JimbGlKV9CJGuAQwfmGdLj
DVGfeRhKC1x1O3X9hqjV3Lnt1Ilnunmo6iMiJH2KZJZgyvskevREs6eRzsykxBhA
YcW51/D/aMwEdBwA5wzxl9M8efiHV9ICkdm4jwN5Pc9lRPf9oMtqHzlAE9dwb+EB
Y7NCELsMbkD7LYEfYCfx0mPVcABAX5HyHAJlj4Ad3+wmGrQyTnhzyf2GxLHENdD2
OTHNHmfkqhlN21Mgf+bGJFSI1z5DJAJVc+mGKF6lVwyPZtjw76y9wx0N/p3KvRUA
e5lz6ZJk3c+PWGEC0ms7GYkKcTpb95lOdgVfnhSI8VnKNq07dwMNWD35APflY2Mp
LnS1RTTFY5Z8g+e+ZLy6iU05TqYAjCvGYGfFUtrK6TUyxPAo81laZvN91qT8KHEn
r2x5kXB3Gt3oVKiewl4ZpIJYSib6EDZ19qp101rniiLr86k8vbfc8JYqFoj32gss
2Suy8jjnNW+b24q6mhRCbYDRsubu5jCP2EXKX3AdnD4FVhfhBubDOiDdwH8eopel
K+YmRRmF8NnbofAXe/+eCSqBfUKxOryxwyqGAIyzN7wslTumEHIBQmpzramv4XQz
L3tP0OvK0dBotA3tB3vK
=SVZt
-----END PGP SIGNATURE-----

--Sig_/=AkyU_JTnP6a=eUdbdpBUAe--
