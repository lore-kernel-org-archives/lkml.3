Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaHKBl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:41:28 -0400
Received: from ozlabs.org ([103.22.144.67]:36524 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaHKBlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:41:19 -0400
Date: Mon, 11 Aug 2014 11:41:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anson Huang <b20788@freescale.com>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: linux-next: manual merge of the pm tree with Linus' tree
Message-ID: <20140811114110.5e81b8a9@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zkCOc.Jb1/_CVV6yyJX/rzI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zkCOc.Jb1/_CVV6yyJX/rzI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/arm/mach-imx/pm-imx6.c between commit 80c0ecdce802 ("ARM: imx: add
standby mode support for suspend") from Linus' tree and commit
bb3274b6442d ("PM / sleep: Rename symbols, functions and variables
related to sleep") from the pm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/pm-imx6.c
index 5c3af8f993d0,fb4ae1244abd..000000000000
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@@ -342,22 -314,8 +342,22 @@@ static int imx6q_suspend_finish(unsigne
  static int imx6q_pm_enter(suspend_state_t state)
  {
  	switch (state) {
- 	case PM_SUSPEND_STANDBY:
++	case PM_SUSPEND_SHALLOW:
 +		imx6q_set_lpm(STOP_POWER_ON);
 +		imx6q_set_int_mem_clk_lpm(true);
 +		imx_gpc_pre_suspend(false);
 +		if (cpu_is_imx6sl())
 +			imx6sl_set_wait_clk(true);
 +		/* Zzz ... */
 +		cpu_do_idle();
 +		if (cpu_is_imx6sl())
 +			imx6sl_set_wait_clk(false);
 +		imx_gpc_post_resume();
 +		imx6q_set_lpm(WAIT_CLOCKED);
 +		break;
- 	case PM_SUSPEND_MEM:
+ 	case PM_SUSPEND_DEEP:
  		imx6q_set_lpm(STOP_POWER_OFF);
 +		imx6q_set_int_mem_clk_lpm(false);
  		imx6q_enable_wb(true);
  		/*
  		 * For suspend into ocram, asm code already take care of
@@@ -386,14 -343,9 +386,14 @@@
  	return 0;
  }
 =20
 +static int imx6q_pm_valid(suspend_state_t state)
 +{
- 	return (state =3D=3D PM_SUSPEND_STANDBY || state =3D=3D PM_SUSPEND_MEM);
++	return (state =3D=3D PM_SUSPEND_SHALLOW || state =3D=3D PM_SUSPEND_DEEP);
 +}
 +
  static const struct platform_suspend_ops imx6q_pm_ops =3D {
  	.enter =3D imx6q_pm_enter,
 -	.valid =3D suspend_valid_only_deep,
 +	.valid =3D imx6q_pm_valid,
  };
 =20
  void __init imx6q_pm_set_ccm_base(void __iomem *base)

--Sig_/zkCOc.Jb1/_CVV6yyJX/rzI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6B87AAoJEMDTa8Ir7ZwV8QkP/2/VCMczDr00KgJdJscy/7iY
7rJaJEna+H+FD9TtuHkXsXJYPtPE4PnnJ2dQWCLWDYfoKc5plrEARmzeslIT+viC
Gc20f9oYjKBitQ0HFDCyu8SlRxxvHE1ogGEsxlH2jGdePDbL+ksovn/7AMpwPrhV
NQOSEWpxLED6kIUAsxF+DFJ4nNYXgaWs8G/UKffxT5IvksiV9SlUblbebAgZGRhI
NEJF4SEiCKA5AQCs9A7u/Vll5Q30CmePZm5yPEbqgpEdPXg4eNdg4o7ncZlFdmRj
5azoIrVogQAtJWxiV0U1v5aGwGVWZwM9X7bEBTDZUh85adnEW2IJBu+QxlpjPzbX
ilYokE5sceJRRXunpFoi5ki2oDBVBhuAuuhsQMo2kA/GKU3yjtXxNtjprJF8P0Wn
LiZcpVc5KlPX03upCpOWsudZUD1JvIAa62BD15oo5nFi4XltDIDaN2vk8id0DWOF
HJTlHOmvUBJBN9gNSoldCXGvIweaRCSGXtTPlqPc3biiZn86Nm0nksiL4KkkEW76
sD43wmYUW4Ov1kJYnmB/PxBbMCpmBVdKdcqB6M8cCCQJubObC9i0PIe0XgEpX/jz
kZW57jpuM9zlx2NcjSlJFZJWCJPJHR7HtjEjuJ7q2WsT01RQjaZOyL/SwwuBGM8y
bhqBz3Un/91Eg70dbUEd
=rpzL
-----END PGP SIGNATURE-----

--Sig_/zkCOc.Jb1/_CVV6yyJX/rzI--
