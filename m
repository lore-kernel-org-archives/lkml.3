Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaHDGzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:55:50 -0400
Received: from ozlabs.org ([103.22.144.67]:58027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaHDGzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:55:49 -0400
Date: Mon, 4 Aug 2014 16:55:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-ID: <20140804165541.592d51fb@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/phG03f/j_RwoW_Ck_zsPrYd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/phG03f/j_RwoW_Ck_zsPrYd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/Kconfig between commit 8a1664be0b92 ("ACPI: add config for
BIOS table scan") from the pm tree and commit 44a69f619562 ("acpi, apei,
ghes: Make NMI error notification to be GHES architecture extension")
from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index ac5a788d2432,4559c4e114d1..000000000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -133,7 -132,8 +133,9 @@@ config X8
  	select GENERIC_CPU_AUTOPROBE
  	select HAVE_ARCH_AUDITSYSCALL
  	select ARCH_SUPPORTS_ATOMIC_RMW
 +	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
+ 	select HAVE_ACPI_APEI if ACPI
+ 	select HAVE_ACPI_APEI_NMI if ACPI
 =20
  config INSTRUCTION_DECODER
  	def_bool y

--Sig_/phG03f/j_RwoW_Ck_zsPrYd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3y5zAAoJEMDTa8Ir7ZwVhBgP/0P+sCzKxxOPZ9cUhuVpywn/
8uJH1cYJcMerdHS6R4bLccEI0itOqFRRVguM4cl2MHqKnIeNSgN13ofI2gKO5ZcA
qQmZDqOJFTOGQ4W9Lf0EIfPVxiI11Hp8FyIR0qmWUYSizRtB+RhOvTvTiOIwqyIC
zg2ljn6EBDgIK77tz8Bp9eJRvp+eoHaG+S2Oc2AkIIGcgxo8Hh2ymZ7xAWuYTTUf
IO1yRq654v7k1b7BXXpQAc9zCxdEBh0AmYe2vGMU18+6hdWAApdXm4GaCsAYNJDg
53U2mu041VniBVl9+xga//g5BC4lCIZeqAOCgCxUpFxfm28xNq4BIggQfWrXhjJz
KQ/3dWfEISqO6pXB8m3j5P+hD1VChf4CO42ubWvWmv3OGLz0FwbtM9624ceCvc0o
UHK3WrWdpu1FP+gYmxfw7YUabiND8D4oZh0H+60GfJuLUPE3+3VCVwoKMKmfALas
yH+Rlv5vk3B0cNrM9H/qDld6+jOV6dLbnZoLtI+RlrlGww1J9DsV9neCRj6OEEnV
iJrTnaqhtxYvR7wjjCNHervJ8A2Vs6/CdS/57vNEWJ3wGvso3P/5xpbnjQBXyEo+
3cri+H0+N+RraRFaxe2+Gd5TDjbVuQ58+sTBp1aJrGg2wvYtxg/2twL9U4HRAA2D
b7BMrSTHnRJhDaiHR2QG
=bF74
-----END PGP SIGNATURE-----

--Sig_/phG03f/j_RwoW_Ck_zsPrYd--
