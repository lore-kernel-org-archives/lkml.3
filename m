Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaCFEAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:00:18 -0500
Received: from ozlabs.org ([203.10.76.45]:46314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaCFEAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:00:16 -0500
Date: Thu, 6 Mar 2014 15:00:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au>
In-Reply-To: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_15_00_10_+1100_/YkSXspJcxo7d8z6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_15_00_10_+1100_/YkSXspJcxo7d8z6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Feb 2014 15:17:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> After merging the tip tree, today's linux-next build (arm
> multi_v7_defconfig) produced this warning:
>=20
> drivers/irqchip/irq-armada-370-xp.c:415:1: warning: 'externally_visible' =
attribute have effect only on public objects [-Wattributes]
> drivers/irqchip/irq-sun4i.c:39:70: warning: 'externally_visible' attribut=
e have effect only on public objects [-Wattributes]
> drivers/irqchip/irq-sun4i.c:140:1: warning: 'externally_visible' attribut=
e have effect only on public objects [-Wattributes]
> drivers/irqchip/irq-gic.c:283:1: warning: 'externally_visible' attribute =
have effect only on public objects [-Wattributes]
> drivers/irqchip/irq-sirfsoc.c:51:1: warning: 'externally_visible' attribu=
te have effect only on public objects [-Wattributes]
> drivers/irqchip/irq-vt8500.c:183:1: warning: 'externally_visible' attribu=
te have effect only on public objects [-Wattributes]
>=20
> Probably introduced by commit 128ea04a9885 ("lto: Make asmlinkage __visib=
le").
>=20
> I guess that there may be more places where "asmlinkage" is used with
> "static" - I assume that they are all incorrect?
>=20
> $ git grep -l 'static.*asmlinkage'
> arch/x86/crypto/sha1_ssse3_glue.c
> arch/x86/crypto/sha256_ssse3_glue.c
> arch/x86/crypto/sha512_ssse3_glue.c
> drivers/irqchip/irq-armada-370-xp.c
> drivers/irqchip/irq-bcm2835.c
> drivers/irqchip/irq-gic.c
> drivers/irqchip/irq-mmp.c
> drivers/irqchip/irq-moxart.c
> drivers/irqchip/irq-orion.c
> drivers/irqchip/irq-sirfsoc.c
> drivers/irqchip/irq-sun4i.c
> drivers/irqchip/irq-vic.c
> drivers/irqchip/irq-vt8500.c
> drivers/irqchip/irq-zevio.c
> drivers/pnp/pnpbios/bioscalls.c
> scripts/checkpatch.pl
>=20
> (the last two don't matter)

Any resolution for this?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_15_00_10_+1100_/YkSXspJcxo7d8z6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTF/LOAAoJEMDTa8Ir7ZwVONkP/RJR0sGVmDwi4mgCf+4CKe0/
MNDZhx5HtQnPETgr5Lc1vqsc5B4o0VRUZfgQCoFMVP3KE8VFO8deVnWOjbHIrmpe
kc5va2Y4WOsUxFbpg2imnhku9Ol+WTrf7QPw1bwrSMnzPR8HmAa/AbKwD1mwMoZE
H0InqsfKkw5X91FEO78R+VDQ48Hq0ejBEUjzMK7iFVhlQrarK556lKEP9pn3mO+e
K2tiwyib2i0N9rzpJbEgVjU28dGDPFYkLBfYf1NhI5M7WE4/dS8wVE5ggYXWEziF
NkPOsvz5jDLor0T6zFj7ez16b5UzfpcT1S4GfU1hNWWCWNfKFVh4L6Ieztip4n+E
Oh60gyOpl4zWl9deBB6MFob5bE0YjBsfpEw+sJ39fvVYAbsdNxH7wMF6vfzaTbuV
94Pg6BMu2Gm6lwOZlV/nKPJZPo/BQ0rW5voQEILMVmKRbGgsLJGh1Iv1etNHh05w
XP1IU3MHm4rC4uWwBeoO2AAzEGmt03z+JhrZI6uan7bwjgsfGWycxPr+N/Q4MLA0
rT7MTpiSM10R6/71/8lUXB1Ode9mHMpD8Fvt8uolC5CwTfa88gb+6ot7799hFRCl
LrZx1jdxqqcGkd2q3mkAbBvcTXHkGTJCO//9ewj9Lt3fcVyl0vQniW5zxMdVBH8C
WUjQ36DFiQWXGzeRT1+x
=GmrB
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_15_00_10_+1100_/YkSXspJcxo7d8z6--
