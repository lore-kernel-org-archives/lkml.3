Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaCQJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:26:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaCQJ0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:26:23 -0400
Date: Mon, 17 Mar 2014 20:26:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: manual merge of the akpm-current tree with the audit
 tree
Message-Id: <20140317202616.b9553da1bbcea707e13cb678@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_20_26_16_+1100_DKz_h/_xALMrnBhe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_20_26_16_+1100_DKz_h/_xALMrnBhe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/ia64/Kconfig between commit b4df597ae51f ("audit: Add
CONFIG_HAVE_ARCH_AUDITSYSCALL") from the audit tree and commit
a13978c6e0ba ("ia64: select CONFIG_TTY for use of tty_write_message in
unaligned") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/Kconfig
index 5409bf46cb83,6b83c66f51b1..000000000000
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@@ -44,7 -44,7 +44,8 @@@ config IA6
  	select HAVE_MOD_ARCH_SPECIFIC
  	select MODULES_USE_ELF_RELA
  	select ARCH_USE_CMPXCHG_LOCKREF
 +	select HAVE_ARCH_AUDITSYSCALL
+ 	select TTY
  	default y
  	help
  	  The Itanium Processor Family is Intel's 64-bit successor to

--Signature=_Mon__17_Mar_2014_20_26_16_+1100_DKz_h/_xALMrnBhe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJr+8AAoJEMDTa8Ir7ZwV72sP/2e0qIGz14L1JucVzfzekCXR
LjLoV7033+FPH8ecryqyafhtvX552NpoKsnJ4Xbzvnca48kbc68swA40Y6LneBPD
dXReYScY5H7A1TrKk623Chso0m3ROqJT0WAMXRFYNPOOjPsClOVGlCHhN2h8bGGy
ky0yg/zovAVXPqyAel8ss+1gQpmktLVJzJTssWLIvvEW58zl4nmvtdScrchCNquU
xaavkboIx1jN4c8VOdDa59LbVAWUWSWOGTaTQXh0L8SOI2qAflsbcposoTo9wfUC
8DxZZuA8WTJvdjr9q14JZDt5TE/FPHLger11dMNUYxTlCNIbecIOpjnwrsgb0qXY
TRz51PJVMEnxc0twMw666xJwZRCX1Hflm0mi1A8jgzYfBTvlPLd80d9EDMdeWoma
2nUjOu7F0HRf2wSczz80u8g7+3NoBZ3MOspAoZFYCxzDshJWOgewTvMmPJ3lhtIu
Uw+E/037Otx4bKP2mLjihnQPMqDiXdVWr61TwKU40f6VQ+BK4Vg1KBmVAilSftVz
BCUqUNaFAmeSwharEl3VBLodyB6BtGBFqadHkLC7yguS9WQh86hKFI5Bi9I33aUi
pgAiVd7cOUBDvA3wpoXY+FzgrmvITQqUo8Kr/z7s5Ljk0vCPDFkp5pGbfkueKKKQ
lB8wDI8zT9Xj1FKBOP3K
=WpW6
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_20_26_16_+1100_DKz_h/_xALMrnBhe--
