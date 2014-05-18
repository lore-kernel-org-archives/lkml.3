Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaERXh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:37:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56765 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbaERXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:37:27 -0400
Message-ID: <1400456236.17377.10.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] x86: relocs: Make per_cpu_load_addr static
From: Ben Hutchings <ben@decadent.org.uk>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Michael Tautschnig <mt@debian.org>,
        748577@bugs.debian.org
Date: Mon, 19 May 2014 00:37:16 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lylj5EeaUcrO1mTSSLcn"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lylj5EeaUcrO1mTSSLcn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

per_cpu_load_addr is only used for 64-bit relocations, but is declared
in both configurations of relocs.c - with different types.  This has
undefined behaviour in general.  GNU ld is documented to use the
larger size in this case, but other tools may differ and some warn
about this.

References: https://bugs.debian.org/748577
Reported-by: Michael Tautschnig <mt@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/tools/relocs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index bbb1d22..a5efb21 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -695,7 +695,7 @@ static void walk_relocs(int (*process)(struct section *=
sec, Elf_Rel *rel,
  *
  */
 static int per_cpu_shndx	=3D -1;
-Elf_Addr per_cpu_load_addr;
+static Elf_Addr per_cpu_load_addr;
=20
 static void percpu_init(void)
 {

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-lylj5EeaUcrO1mTSSLcn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU3lEMee/yOyVhhEJAQojFw/8D+PQWWhbVYRxjU+dLQPhUOShTkcs3qaa
pwGNM7eZPRefjyfKpVboM1Od1Cqp6wDGFEneE5LMeHUWG7319DxNPmHkZkWyaAVm
4fd9n/+hChauFScd45Vwig8IL4ZrLzomx6xiVlHGikJrOGBd7Muv540GzKU/kAiH
lO9Q8Cl5ZVguFQS3RIxu3so0PNRXXKaT4bpTszjttmFluKHAp5e6xAkpV6JJIBZD
2/BbJ3yGpzMfGkotDSIc8r53gl21RUtwb2dFH5nj+iVEvlQxKp7wd1WFsXViNVK5
LearYnG+zaxVqoXYIGi1fAaGXkmz2LdNvCazo0m/9mbc2fUXHbF+CrVTtsG4HkqL
mHLEME58EX0ZM6xDtV7Sqv7KSQsIFnFDfA5bG4xGA+NbRUN3gJ3UrAclHA4BnmMC
fevMrTabzpQngFdIJ/swsvSr1QxKenjnCUqah2Uk4jvqQgv9l8iMyBVkl1iRMmlI
Dew44bQoeL3LnBq70lsruxjfP62q7jAMkdJ7d9B8WtfqiKe26lKpkx8xzF2lRXrz
hPTuHoGWePDAk1VYvBozenBH4CTno17MUkTlm7qi/p6KJKQ9iT2ldA2ZZUQ6Hu71
LF1aUkyN/1MZFBCumDN7RI4yQSyr6keOM4/OVUKrzrdVkys72AUifApKVdG6b5xJ
r1Xrj0Ijqsg=
=hhSO
-----END PGP SIGNATURE-----

--=-lylj5EeaUcrO1mTSSLcn--
