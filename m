Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaE0Api (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:45:38 -0400
Received: from ozlabs.org ([103.22.144.67]:34053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaE0Apf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:45:35 -0400
Date: Tue, 27 May 2014 10:45:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-ID: <20140527104526.5c6f819e@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ivaa.BKnR3Ym=la4DL_QjHQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ivaa.BKnR3Ym=la4DL_QjHQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/omap-mpuss-lowpower.c between commit 4e4bb5c72f6b
("ARM: l2c: omap2: avoid reading directly from the L2 registers in
platform code") from the arm tree and commit edfaf05c2fcb ("ARM:
OMAP2+: raw read and write endian fix") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 61cb77f8cf12,eb76e47091ad..000000000000
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@@ -187,15 -187,19 +187,15 @@@ static void l2x0_pwrst_prepare(unsigne
   * in every restore MPUSS OFF path.
   */
  #ifdef CONFIG_CACHE_L2X0
 -static void save_l2x0_context(void)
 +static void __init save_l2x0_context(void)
  {
- 	__raw_writel(l2x0_saved_regs.aux_ctrl,
- 		     sar_base + L2X0_AUXCTRL_OFFSET);
- 	__raw_writel(l2x0_saved_regs.prefetch_ctrl,
- 		     sar_base + L2X0_PREFETCH_CTRL_OFFSET);
 -	u32 val;
 -	void __iomem *l2x0_base =3D omap4_get_l2cache_base();
 -	if (l2x0_base) {
 -		val =3D readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 -		writel_relaxed(val, sar_base + L2X0_AUXCTRL_OFFSET);
 -		val =3D readl_relaxed(l2x0_base + L2X0_PREFETCH_CTRL);
 -		writel_relaxed(val, sar_base + L2X0_PREFETCH_CTRL_OFFSET);
 -	}
++	writel_relaxed(l2x0_saved_regs.aux_ctrl,
++		       sar_base + L2X0_AUXCTRL_OFFSET);
++	writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
++		       sar_base + L2X0_PREFETCH_CTRL_OFFSET);
  }
  #else
 -static void save_l2x0_context(void)
 +static void __init save_l2x0_context(void)
  {}
  #endif
 =20

--Sig_/ivaa.BKnR3Ym=la4DL_QjHQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTg+ArAAoJEMDTa8Ir7ZwVYwMP/2zQrKNYvo/wfw+HDDGxT5xl
04oXCsxDoPA1WS7yJWVtn6qfX4WXuGa5RbZnY/uN49IfvRNQQGUzrt5tc9QYUXr5
Jp7CpIc21Xvtme1Grz65zPlnjWU+ESL6AwvKCAGzQqauPKaqOCyC7+4DTQDGCbxO
dkmGTRMsueAo3WFJ5QtN4/5/HmCeQ3XR8bmvJpquL47rqMkhRq1oX/bBJ1WOiagK
4okreSOId1PC0xzmnhccYVyBVC002mee8DAIDZ15LSQ/W4zODo9U1AmML7T59f5s
BqiSRQaSLvIjA1amSA9LIWCRUx2Ot3ZLkiP1RA5g2bh5B3djX2tGlzl0o8F0KP6Z
aDGfhtShyX4hSQd8+cWkxglR8XwOoLKgMjZ6kgU6BjERAX2qOjErV4Miz9lW8UKV
ON/1sbRaaQNy6fMed+jWKeJnzfoU7iu1GoxZ2GO8d5ZSUS0FXY6O1yl/wP/9U2+c
V8GZJAXLFwzMBOXboM2ys0QSW4f7g4GK6C8NcsB6UaNj7+K9nMbqy89/UeJdpBOK
5TzN3Q2MV7jy6MuIGmLFZ4vkAxtKQRK9FarhBNUNl08vQ6zLRvQPABAWo0WUq/fJ
x3anDIXZ9i/oJmFECVfSny1tStnc6LuB1uKfyjaFRfgq9NabasrJUOKYt/FiaasT
IH1el1aM0hF0c+bFlwMI
=RLkn
-----END PGP SIGNATURE-----

--Sig_/ivaa.BKnR3Ym=la4DL_QjHQ--
