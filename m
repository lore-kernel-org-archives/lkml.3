Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaE0As7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:48:59 -0400
Received: from ozlabs.org ([103.22.144.67]:40240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaE0Asz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:48:55 -0400
Date: Tue, 27 May 2014 10:48:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140527104847.1842b04e@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7ff1/s1J8EcOE=Uw2dmneDH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7ff1/s1J8EcOE=Uw2dmneDH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-rockchip/rockchip.c between commit fc2553457ccd ("ARM:
l2c: rockchip: convert to generic l2c OF initialisation") from the arm
tree and commit 26ab69cb4c1f ("ARM: rockchip: convert smp bringup to
CPU_METHOD_OF_DECLARE") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-rockchip/rockchip.c
index 138b9975313a,4499b0a31a27..000000000000
--- a/arch/arm/mach-rockchip/rockchip.c
+++ b/arch/arm/mach-rockchip/rockchip.c
@@@ -33,8 -39,6 +33,7 @@@ static const char * const rockchip_boar
  };
 =20
  DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
 -	.init_machine	=3D rockchip_dt_init,
 +	.l2c_aux_val	=3D 0,
 +	.l2c_aux_mask	=3D ~0,
- 	.smp		=3D smp_ops(rockchip_smp_ops),
  	.dt_compat	=3D rockchip_board_dt_compat,
  MACHINE_END

--Sig_/7ff1/s1J8EcOE=Uw2dmneDH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTg+D1AAoJEMDTa8Ir7ZwVpIsP/2PwjnL1uj3lKgx80CLTp7TQ
ClcPeqmtZbSSzllX8ibsTkXHZfO5DJUEqXkaS84M06cQ9gls3zV68R0U+b9AZk+8
hxiBDnLWmmKdRXdrTdrI+c8pnt0KgLufQPB7mezNHk4vlu5TX58rz2iqkaSII5D1
fgwCb7WGA52Q1JHo0ackD/4cMxU4bHncHX9M97Wq9uvBWMfW5Z9LyqA89ehNd78G
ye4NbZYIF1ux9jH7gZB067GXLOvsQZc9PAEqIsbZW9fy8KfewQluY5OOnHAiOZMG
mcD94zl55/+VdLtauVTL3f7RpqCeZyxmjS3AoxtV8LiCZUa68zjARLLOdVGLFcxB
jbB6UG4EYWsOFXYJ4d0eCMdVu+sYTh6vqoSbZA/ASCpBKiv/fILrHT9utDQr77UK
85VW+DAQI4nqhaXhYsgEtWXeiuD0RrfF4ckaD3L8OhJBx4LcdLrV0WdFaP+XTDsn
cqiaQTzd5yotB63oAUhn7Byt9VgXzXfTZtwvg1rikJNBGgQ3vjKeAOfmXdcGYK4b
lcOeQhC09n1ASYd+VIhfHrC1Ehf6qcIiC/OtZtXVl5SyCA3wu6rigLc/JQS7fZQd
uuYE6wblG8oAKd7KcEd+Z3DYWjhOf+zC5W+v94GzMqc3OgBJ/A8t/ThXJY0foUno
0oRVTBGmhC+vzUeF1W44
=+2K9
-----END PGP SIGNATURE-----

--Sig_/7ff1/s1J8EcOE=Uw2dmneDH--
