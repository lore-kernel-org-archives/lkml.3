Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab3BHDTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:19:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56997 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3BHDTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:19:42 -0500
Date: Fri, 8 Feb 2013 14:19:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] cputime: restore CPU_ACCOUNTING config defaults for PPC64
Message-Id: <20130208141938.f31b7b9e1acac5bbe769ee4c@canb.auug.org.au>
In-Reply-To: <20130208141447.03914013db9a5f7308fc1675@canb.auug.org.au>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359399845-10568-5-git-send-email-fweisbec@gmail.com>
	<20130208140749.5a094f271e529dacfb962b51@canb.auug.org.au>
	<20130208141447.03914013db9a5f7308fc1675@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_14_19_38_+1100_SOsdWr+lcL4ZGI3j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_14_19_38_+1100_SOsdWr+lcL4ZGI3j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit abf917cd91cb ("cputime: Generic on-demand virtual cputime
accounting") inadvertantly changed the default CPU_ACCOUNTING config
for PPC64.  Repair that.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index ed24d1b..ccd1ca5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -301,7 +301,7 @@ config VIRT_CPU_ACCOUNTING
 choice
 	prompt "Cputime accounting"
 	default TICK_CPU_ACCOUNTING if !PPC64
-	default VIRT_CPU_ACCOUNTING if PPC64
+	default VIRT_CPU_ACCOUNTING_NATIVE if PPC64
=20
 # Kind of a stub config for the pure tick based cputime accounting
 config TICK_CPU_ACCOUNTING
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Feb_2013_14_19_38_+1100_SOsdWr+lcL4ZGI3j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFG7KAAoJEECxmPOUX5FEYBQP/1Y+sPcxnQBMukH+ihkbh+0a
HUvw5GupbBaOGFDq4nrdKd6zb3crZiEOxDNpJM2gEoDRurhFusgbulwBfch4PvBm
5U2XGGxgJbr7WyGjZi4l+VE5Z/OiGV/nG9R7aYHMX7ts0ivOKSPLRUT3xCfWZGf/
gM4UB1ZpIr+q6LVMErFTLH7pzdk/Iudy3Wa6Xay33XEenuj5RI46Csycj1Flv7IS
DCgiq9pJXePdGewrXR49rxJAOL0DU4sayvg+CaSrXQw2/S3kcjgufWdz0mKZYVUx
v7Cuh/pZw7r5Er7ibVRocopjRArZfZq86tHxG84akGkmtIQotnaVtX2LBU8BEpv2
lx6KXQalZuRfwT/jrfyCGPadMs4FaeAUMa0BfHms+saP+czmsSkNfcowbWLLtKt2
CR961xL//SBgaEryjJS1pqTSe1pSMf9xiPULW1bcuK5xcXoS+IMOz32XRUxv4P3T
FCmoU4dBep91uS3ge7sRwlVwgoClgbn5+A+K4ZKEQRoUljY1DqbVLDOFFXPo/lQ4
XiKM2QQ1/1EXdrx6TB55mWa3m3ClXnDaAIr3V70J0QfA+5+CCz+cjdYa745aqGIS
YMw+evJYSqvjzoj7LK/yon/2CGqhx9pVidxczJsLUQ2hUMN2Rd/5+Ix93IwqiOlS
2ZChrri8Pv2p07UtuaqI
=xG5S
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_14_19_38_+1100_SOsdWr+lcL4ZGI3j--
