Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaIXMa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:30:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41642 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbaIXMaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:30:24 -0400
Message-ID: <1411561812.3659.23.camel@decadent.org.uk>
Subject: [PATCH RESEND] x86: relocs: Make per_cpu_load_addr static
From: Ben Hutchings <ben@decadent.org.uk>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Michael Tautschnig <mt@debian.org>,
        748577@bugs.debian.org
Date: Wed, 24 Sep 2014 13:30:12 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OlBFkx11ktPdinX29JLI"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OlBFkx11ktPdinX29JLI
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
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-OlBFkx11ktPdinX29JLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVCK5Wee/yOyVhhEJAQranA//YAN2Nt/diSthIWyrkAkdUaUMRBFb52VA
3FnFqeQv6DjCB0FQ1nRLvf5rL4EOMhaWg1Iy8ykqQpD2VctIgc9PR7xHlkAwTAFw
fin6E/KDV1Mx8tGHr05fTsAGMxdwbsuEay431I3iV69UM3BWW9ohUBoj7pYljtin
jHeCxVMfj9KVx99LVWCwzaN+FILrCknq+PIDdI8gmmjfoNzQZ8U8h7PQMBfyMUTW
qB6buBUwM9LJfd5L7J0riuxb9Ot260umST7/xqD3dSuPKiSA8P4CZSN7G8VE6aPZ
1jFRpbhm4pckFxPbFtov6Jetks8ravzsL+F/7se9XTJeKO4OOVigzP9B5u9pQa09
K2Cf+LrMy/u29Xr4H9RfCVZ9fnNr1jPk0L2ShMI4vvhpnADwAa3QYsw1cdMmGhqf
1tdsQODap2qEu9TyJfiJTR2MrFrjb7+/1CEH7vhT7DpH/WrmCjzFqKxBOHhSfQfM
/L50bTyxzbuUd9ioKazbx1AeuoyDObGWCZ+i5hizf35t8bzR3Z9u1FpR6VNb23CK
R90BcxXxcw8jBs0dq8V1u8OFucVjgh8H2VALUTCDLqkF+KpLGfbjqckf37VcO/tR
+L6lU2VcYap14/q2yBNHxfQTGntDRsboOHm/11FEhVafpgpt1u98Pyu68rob1Ond
kpja7hL7yLM=
=rURe
-----END PGP SIGNATURE-----

--=-OlBFkx11ktPdinX29JLI--
