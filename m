Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaBXERk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 23:17:40 -0500
Received: from ozlabs.org ([203.10.76.45]:45926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaBXERi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 23:17:38 -0500
Date: Mon, 24 Feb 2014 15:17:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_15_17_32_+1100_jAcTd3W8BKDJ.4+b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_15_17_32_+1100_jAcTd3W8BKDJ.4+b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

drivers/irqchip/irq-armada-370-xp.c:415:1: warning: 'externally_visible' at=
tribute have effect only on public objects [-Wattributes]
drivers/irqchip/irq-sun4i.c:39:70: warning: 'externally_visible' attribute =
have effect only on public objects [-Wattributes]
drivers/irqchip/irq-sun4i.c:140:1: warning: 'externally_visible' attribute =
have effect only on public objects [-Wattributes]
drivers/irqchip/irq-gic.c:283:1: warning: 'externally_visible' attribute ha=
ve effect only on public objects [-Wattributes]
drivers/irqchip/irq-sirfsoc.c:51:1: warning: 'externally_visible' attribute=
 have effect only on public objects [-Wattributes]
drivers/irqchip/irq-vt8500.c:183:1: warning: 'externally_visible' attribute=
 have effect only on public objects [-Wattributes]

Probably introduced by commit 128ea04a9885 ("lto: Make asmlinkage __visible=
").

I guess that there may be more places where "asmlinkage" is used with
"static" - I assume that they are all incorrect?

$ git grep -l 'static.*asmlinkage'
arch/x86/crypto/sha1_ssse3_glue.c
arch/x86/crypto/sha256_ssse3_glue.c
arch/x86/crypto/sha512_ssse3_glue.c
drivers/irqchip/irq-armada-370-xp.c
drivers/irqchip/irq-bcm2835.c
drivers/irqchip/irq-gic.c
drivers/irqchip/irq-mmp.c
drivers/irqchip/irq-moxart.c
drivers/irqchip/irq-orion.c
drivers/irqchip/irq-sirfsoc.c
drivers/irqchip/irq-sun4i.c
drivers/irqchip/irq-vic.c
drivers/irqchip/irq-vt8500.c
drivers/irqchip/irq-zevio.c
drivers/pnp/pnpbios/bioscalls.c
scripts/checkpatch.pl

(the last two don't matter)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Feb_2014_15_17_32_+1100_jAcTd3W8BKDJ.4+b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCsfhAAoJEMDTa8Ir7ZwV0UIP/RdE98ABLeYb+nr8ngSOXp/5
eb6cxK8iBiCu80NEIV1oAL2JV+3ESmRgonvhN+6CXG1DUYMlvxNoWYkEY3Cs8C9f
+OFSGYVokHugOLOye/sdAqFWonDMjaflXcEHKPI0ZgbiWdocj975tzI6botxV4vU
KEleOOJcj0UpxzaMFHvGv9N9noBoB2FHhBuwJxPExKKWwP/WBDp0XZ3/R0rQXk3i
XFCKJlAM29qYFMlZ4xt7upsGqIosIedSuc+G1irA7h38uNBfBZ8f1KBE59812XVY
bHOQ02GnpDbh3royohPcctGK5qAQ8cC/5PAgDQ92kvP/RTv1VVmtSqJjAH7UtXHk
m6Ugpsw2dfH0HQ7cylGSQGhD6a+JRXePq66m7X8FQMU+G8nOMH8rR3tfCORej8fk
1tfTP7XziL4oMTNZdglDShT2s19ep87I8l+cnw2ZG61vkVI+AM9gEf/AfUnlxo1i
w5wFxKdc0yna0epIPr8X61FNTgbVolrrztLRJVXyJ5SQDar+41jEp2x2FxXXSkcq
RKG3PVEWKNW3oPjPNAoddnzuivE8sZ1GB4PQgzh1iEWkFSIad9ANHgi98rwng4DE
3UjR1AqJ4HieRqYciKZx2zvgd3F1KtKv/Ot3Tpr3MOpWxKM09dCHlm9aO7JBVhl/
VDmoD9CJeeHybWcH5ut3
=Wq7u
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_15_17_32_+1100_jAcTd3W8BKDJ.4+b--
