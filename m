Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750777Ab3HSE0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:26:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41676 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3HSE0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:26:42 -0400
Date: Mon, 19 Aug 2013 14:26:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_14_26_33_+1000_3oZC2P4HQ_zcx3UF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_14_26_33_+1000_3oZC2P4HQ_zcx3UF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/kernel/paravirt.c:66:0: warning: "DEF_NATIVE" redefined [enabled b=
y default]
 #define DEF_NATIVE(ops, name, code)     \
 ^
In file included from arch/x86/include/asm/ptrace.h:65:0,
                 from arch/x86/include/asm/alternative.h:8,
                 from arch/x86/include/asm/bitops.h:16,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from arch/x86/kernel/paravirt.c:22:
arch/x86/include/asm/paravirt_types.h:391:0: note: this is the location of =
the previous definition
 #define DEF_NATIVE(ops, name, code)      \
 ^

Introduced by commit 9a55fdbe941e ("x86, asmlinkage, paravirt: Add
__visible/asmlinkage to xen paravirt ops").  The 2 definitions used to be
identical ... maybe there should be only one.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Aug_2013_14_26_33_+1000_3oZC2P4HQ_zcx3UF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEZ5+AAoJEECxmPOUX5FE8Z4P/i6vg13dI1gcRvsSMJIznPVI
A1G3xLrjg/TvqRyuNxilN97LnLR/Y855lELBZ7VbE/XLRBLUsa95E/KVw+BMAkig
KixLY/czBdbYo6Z5fykTmqTY8X9GlqNzznPKgm1X69vcwjJxZa2oyKa4bN9MPx0q
3+j5qszT/gnICtGfJEcq4Ua31AciRAEzoFevrMRQB1X/DtQY2jMV8qolF3OeHpsD
VgFfk/umj15n4pv5aIvdM++TQgLputaompoKQ4kbgl/VhhboNFVnJlgsGc2809tM
CFKEyoVkkGrVscah1hxMpJ5VR1i0ojjwrq5YrPsj0T0DcHmjvnoe9t6jEDuSEFzA
W3uyl6BNiv7YJFylUk8KjneoTdRLdTL/H2a+EZwSIqrLLTux3KV9xYnsCRMRS16F
rdPfJyr+wi8zB7f3jVHIg+AWhPeiW+W6Aifdfb3VmltBJVWK/TjRio+Fo6oSVga6
QeqX0xkAYRXdgA9l//TrmhXYVhZ+xFhghGWdazlhlsFZDSTG9YXvIdUkEOib+pkt
eULbgpSlTFdiwDxxpj7erAUlqLkrWBbEru0pz9IbbvKxLtHPu0Kp+K3rjPjGqxGE
VefQqu36yONA3IKBwwyDxqXkbe+sPbBh/PItF7+NH0eK4CR6tiK+B+QmDS4OxK3z
zXxaf1ufSBG8dU41bTi5
=ekZl
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_14_26_33_+1000_3oZC2P4HQ_zcx3UF--
