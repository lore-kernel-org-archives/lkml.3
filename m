Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaJIEJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:09:57 -0400
Received: from ozlabs.org ([103.22.144.67]:57397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaJIEJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:09:47 -0400
Date: Thu, 9 Oct 2014 15:09:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Subject: linux-next: manual merge of the tip tree with the mips tree
Message-ID: <20141009150939.263c6c75@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qwMyD_CsCJ31aNUu_T3o9pK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qwMyD_CsCJ31aNUu_T3o9pK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm64/include/asm/Kbuild between commit 2f06dbe4e4fc ("arm64: use
generic dma-contiguous.h") from the mips tree and commit c5c38ef3d703
("irq_work: Introduce arch_irq_work_has_interrupt()") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/Kbuild
index 55c179b32dd9,c1968475cc4e..000000000000
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@@ -9,9 -9,8 +9,9 @@@ generic-y +=3D current.
  generic-y +=3D delay.h
  generic-y +=3D div64.h
  generic-y +=3D dma.h
 +generic-y +=3D dma-contiguous.h
- generic-y +=3D emergency-restart.h
  generic-y +=3D early_ioremap.h
+ generic-y +=3D emergency-restart.h
  generic-y +=3D errno.h
  generic-y +=3D ftrace.h
  generic-y +=3D hash.h

--Sig_/qwMyD_CsCJ31aNUu_T3o9pK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNgqIAAoJEMDTa8Ir7ZwVwbEP/3Bb7K86ZtqzQx7/G/0vCDVD
f6L2tPbSb9MvhThP4gHx8CNgvrL2fgHz/Fc93aQdnhii6N6/YynUh+nmr6XuAfQI
uNZtzTCL2wISZhn1aGH4bwsqo0YsH7ihmGBwVhpmr/9wRbo1lt/J/YkmVQShFKhS
/M7CW4PpTC++OS03L5tEAk3xrjqeyQhovRTinghtXXGylhEn/kWjElNLg9NdZwbu
xaEU4AsVmc9IKIqy0J1MtUMthpbPaSSEtHieM13fRP20mMYcGU8gTJLcHftLdDOy
4/5mvz+cRp1MNgI6lQUmbTnw9e39Krf3ohw33E27+pTGtJnl4QG4/dOcUx6V5mYU
IMAtwLT4lauk9W2EbHea1QFFYlZJi09UhU0t4DAkBg5sVW8kSFCmWmzFDd7pagDm
IPJtBQBW8fqmYo63XcIVCoUPI0A8ZAse95gE3j+kTd9p/are0eqZcZVocBV0flGW
JLSW9a8RNd6uOPGVJtLq/wJyymUtgTY5NOb15dA1TxDEp3t7cJGbbxdXY8kUk/VH
ECKO2OSGPOKrsUCiyWmHsk0YOtkehC/E6gsOXg8OVd5R7rj2T4woHJLZje2GJu2v
D5E6F3jvqRCQ8dl57j1VSb8nyrtahBn+gP9zmEkHbrkJlRaDRiA9WouxiQaaVihZ
paBFyCslfFqfkFaT+Vm6
=4RyK
-----END PGP SIGNATURE-----

--Sig_/qwMyD_CsCJ31aNUu_T3o9pK--
