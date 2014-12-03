Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaLCJil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:38:41 -0500
Received: from ozlabs.org ([103.22.144.67]:53927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaLCJcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:32:18 -0500
Date: Wed, 3 Dec 2014 20:32:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: linux-next: manual merge of the kselftest tree with the
 kselftest-fixes tree
Message-ID: <20141203203210.2eef1e6c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VeMA0nfOXfMGEuCxeQyJA7F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VeMA0nfOXfMGEuCxeQyJA7F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Shuah,

Today's linux-next merge of the kselftest tree got a cselftests/kcmp:
Always try to build the testonflict in
tools/testing/selftests/kcmp/Makefile between commit 4c12df63f7ff ("")
from the kselftest-fixes tree and commit c0d8a9393efd
("selftests/kcmp: add install target to enable installing test") from
the kselftest tree.

I fixed it up (see below - probably some more could be done) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc tools/testing/selftests/kcmp/Makefile
index ff0eefdc6ceb,753890f8d3b7..000000000000
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@@ -1,10 -1,48 +1,30 @@@
 -uname_M :=3D $(shell uname -m 2>/dev/null || echo not)
 -ARCH ?=3D $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 -ifeq ($(ARCH),i386)
 -        ARCH :=3D x86
 -	CFLAGS :=3D -DCONFIG_X86_32 -D__i386__
 -endif
 -ifeq ($(ARCH),x86_64)
 -	ARCH :=3D x86
 -	CFLAGS :=3D -DCONFIG_X86_64 -D__x86_64__
 -endif
 -
 -CFLAGS +=3D -I../../../../arch/x86/include/generated/
 -CFLAGS +=3D -I../../../../include/
 +CC :=3D $(CROSS_COMPILE)$(CC)
  CFLAGS +=3D -I../../../../usr/include/
 -CFLAGS +=3D -I../../../../arch/x86/include/
 =20
+ TEST_STR =3D ./kcmp_test || echo kcmp_test: [FAIL]
+=20
 -all:
 -ifeq ($(ARCH),x86)
 -	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
 -else
 -	echo "Not an x86 target, can't build kcmp selftest"
 -endif
 +all: kcmp_test
 =20
+ install:
+ ifdef INSTALL_KSFT_PATH
+ ifeq ($(ARCH),x86)
+ 	install ./kcmp_test $(INSTALL_KSFT_PATH)
+ 	@echo echo Start kcmp test .... >> $(KSELFTEST)
+ 	@echo "$(TEST_STR)" >> $(KSELFTEST)
+ 	@echo rm -f kcmp-test-file >> $(KSELFTEST)
+ 	@echo echo End kcmp test .... >> $(KSELFTEST)
+ 	@echo echo =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D >> $(KSELFTEST)
+ else
+ 	@echo Not an x86 target, unable install kcmp selftests
+ endif
+ else
+ 	@echo Run make kselftest_install in top level source directory
+ endif
+=20
  run_tests: all
- 	@./kcmp_test || echo "kcmp_test: [FAIL]"
+ ifeq ($(ARCH),x86)
+ 	@$(TEST_STR)
+ endif
 =20
  clean:
  	$(RM) kcmp_test kcmp-test-file

--Sig_/VeMA0nfOXfMGEuCxeQyJA7F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUftifAAoJEMDTa8Ir7ZwVc0YQAJTRBwrSOjjAf/tE3rg3H2EU
J5qssGE6o71+ztAK2x1E6vfFDsK6ezD7tKAPTgvisabXwckHX6+JBD3jCY4Hrq++
eft2j7GHT7ZkNaJ1fEjg8eQ7542HepZ7ZrRsHtPG2Ay8L/ulEvhg/s3U6SIVOYtv
nvLyYSPsXPm6l+4gX1PP68/R9sZkIZtR2UWP7WWXxyoK7dBXFKDHKBo+d8XB5xDr
54zaB9dGJaHv+IFZX4RG2NUevLL7mICQ5CYbwJPcvIDrPc9PBpAegx3J8aMbsmEh
W6I+yht9+U/A/jK0BUtqzNTaV3KNm1QbTaBHZcHVuo1VwxDz4gSx/mgB2CxAsDZx
DMpuqBeGhOsHej0DmXWNjSagFv4z8xjo/RCypmCg+f7xkYhgdtSIICKUolI8smN1
bTEGMjpo9AJ8+MbYZLFFVQr1P+ZvE1a+9Nk3opfII/0b29sX4z4VV6TZvYDSIbb3
SxTa4YIwoJ15BqtPS9nZKsRQPkxyyFi/Eq15i/AuMQq3kjnlAo8LBPTgpXoO5oQ3
MUxOBjSU6wMvSFXsvsuZA4XuxOmFj9GMu7IUe7PTvqNVBRTSBBu0jzlnZW9NHtUV
VBEfuw5USrrusAyNGqCjKrSa72M5XKo2RqkgDQVEpNMgl/oxg42gl/ZKHDLkKnNq
w92xQsJYiZ95q3iIMOE8
=6LZg
-----END PGP SIGNATURE-----

--Sig_/VeMA0nfOXfMGEuCxeQyJA7F--
