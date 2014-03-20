Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaCTDgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:36:14 -0400
Received: from ozlabs.org ([203.10.76.45]:52159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaCTDgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:36:12 -0400
Date: Thu, 20 Mar 2014 14:36:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140320143603.a2f82d77be61c09a7852cfe9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Mar_2014_14_36_03_+1100_vpOcCefY=.FU/wEF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2014_14_36_03_+1100_vpOcCefY=.FU/wEF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/mach-imx/pm-imx6q.c between commit 9cdde7217e92 ("ARM: imx6:
rename pm-imx6q.c to pm-imx6.c") from the arm-soc tree and commit
8435cf757632 ("arm: Replace various irq_desc accesses") from the tip tree.

I fixed it up (by applying the tip tree patch to the renamed file -
arch/arm/mach-imx/pm-imx6.c - see patch below) and can carry the fix as
necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 20 Mar 2014 14:33:26 +1100
Subject: [PATCH] arm: Replace various irq_desc accesses fix for file move

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-imx/pm-imx6.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index 16f0d249f6a7..9392a8f4ef24 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -241,7 +241,7 @@ static void imx6q_enable_wb(bool enable)
=20
 int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 {
-	struct irq_desc *iomuxc_irq_desc;
+	struct irq_data *iomuxc_irq_data =3D irq_get_irq_data(32);
 	u32 val =3D readl_relaxed(ccm_base + CLPCR);
=20
 	val &=3D ~BM_CLPCR_LPM;
@@ -288,10 +288,9 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 	 * 3) Software should mask IRQ #32 right after CCM Low-Power mode
 	 *    is set (set bits 0-1 of CCM_CLPCR).
 	 */
-	iomuxc_irq_desc =3D irq_to_desc(32);
-	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_unmask(iomuxc_irq_data);
 	writel_relaxed(val, ccm_base + CLPCR);
-	imx_gpc_irq_mask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_mask(iomuxc_irq_data);
=20
 	return 0;
 }
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Mar_2014_14_36_03_+1100_vpOcCefY=.FU/wEF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKmIoAAoJEMDTa8Ir7ZwVsRoQAI9/6fKYMFWzMuXUFeJMuHeT
+jpJBxh3K+nMFISN2QlgYljhO6inhJMfPn5O2wG6i3aHFcRZG4YnkZ7LezCF50OT
MPUKv/IjYr0C03PU6FtOZG2B8crL+BeMvv7nO/rSr56fELcozdqMrQGBTBmJjlVD
qXofQyju5qyeq41Ic1LiBpjj0pX9CHV6mOll3t28QE3H0k/MTGsYqRABClk9WNLE
N8NYXhWfZ/jqU5Ws2pPtZm3Opn8EG24j0s8wknVOMmB/cuSyJjT6pEIILioJRhJ3
QcNW8K1S2e1IoYq50RH2sRq4f5d4IEO5covnr581y37SD2gol5ctaPvEvykXmkg2
HIDir/kphUelp4uyy/ZVHTpYrtV6SLB+GRn712hOU9J2mMJrwtjZ4TxzZQ2Qvo6C
BfbUZznCGUJBgf1doayHZn5Zh4D+VbqKc4yLXU78oxrNRnqMj1TH6dN9SJn3IJtp
HEPrGFJ07pfg37A2mAtIb+CZ8Kfzq7tyWKHcD5aTKIIF26Zz5+EnB/V4A/NpklQB
QzJe3IgeVjPudLFymLMLjwa12fSL5hpILTdvChY9m/H/NnhQzGp8MVbPhRGaVwi+
NjTnR+lJffDj746I3e38tEQ+blHtEWi1mJaiEdng6vGEdm++c+ZMontbB6VlsU09
yD7jVi4HuXqGPB5A89sh
=Mseq
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2014_14_36_03_+1100_vpOcCefY=.FU/wEF--
