Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaDAA0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:26:45 -0400
Received: from ozlabs.org ([203.10.76.45]:43754 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaDAA0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:26:44 -0400
Date: Tue, 1 Apr 2014 11:26:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140401112637.454be94f789d5fd9db729dcd@canb.auug.org.au>
In-Reply-To: <20140331215743.a357aa685a63c06ea303dbba@canb.auug.org.au>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
	<20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au>
	<20140328165238.7d9e0804a2781eaaa88a4fa5@canb.auug.org.au>
	<alpine.DEB.2.02.1403311140180.14882@ionos.tec.linutronix.de>
	<20140331215743.a357aa685a63c06ea303dbba@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Apr_2014_11_26_37_+1100_jMLsp+WHsGAlKwQs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Apr_2014_11_26_37_+1100_jMLsp+WHsGAlKwQs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Mon, 31 Mar 2014 21:57:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 31 Mar 2014 11:45:24 +0200 (CEST) Thomas Gleixner <tglx@linutroni=
x.de> wrote:
> >
> > commit 8783dd3a37a5853689e1a8fa728827a50905b912
> > Author: Stephen Boyd <sboyd@codeaurora.org>
> > Date:   Tue Mar 4 16:40:30 2014 -0800
> >=20
> >     irqchip: Remove asmlinkage from static functions
> >=20
> > which is in the tip tree since March 12th.
>=20
> Thanks for that.
>=20
> An i386_defconfig produces this:
>=20
> arch/x86/kernel/syscall_32.c:14:1: warning: 'externally_visible' attribut=
e ignored [-Wattributes]
> arch/x86/kernel/machine_kexec_32.c: In function 'machine_kexec':
> arch/x86/kernel/machine_kexec_32.c:191:12: warning: 'externally_visible' =
attribute have effect only on public objects [-Wattributes]

And today from Linus' tree I get these:

x86_64_allmodconfig:

arch/x86/crypto/sha1_ssse3_glue.c:43:1: warning: 'externally_visible' attri=
bute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha1_transform_asm)(u32 *, const char *, unsigned=
 int);
 ^
arch/x86/crypto/sha256_ssse3_glue.c:56:1: warning: 'externally_visible' att=
ribute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
 ^
arch/x86/crypto/sha512_ssse3_glue.c:55:1: warning: 'externally_visible' att=
ribute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
 ^

arm_multi_v7_defconfig:

drivers/irqchip/irq-sun4i.c:39:70: warning: 'externally_visible' attribute =
have effect only on public objects [-Wattributes]
drivers/irqchip/irq-sun4i.c:140:1: warning: 'externally_visible' attribute =
have effect only on public objects [-Wattributes]
drivers/irqchip/irq-armada-370-xp.c:357:1: warning: 'externally_visible' at=
tribute have effect only on public objects [-Wattributes]
drivers/irqchip/irq-gic.c:283:1: warning: 'externally_visible' attribute ha=
ve effect only on public objects [-Wattributes]
drivers/irqchip/irq-sirfsoc.c:51:1: warning: 'externally_visible' attribute=
 have effect only on public objects [-Wattributes]
drivers/irqchip/irq-vt8500.c:183:1: warning: 'externally_visible' attribute=
 have effect only on public objects [-Wattributes]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__1_Apr_2014_11_26_37_+1100_jMLsp+WHsGAlKwQs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOgfBAAoJEMDTa8Ir7ZwVSTIP/1DD53qaPxb5YLtLfmOLjh+W
M6XZ4vazvBEikM8vAvOpgD3NyN0gugRpE72mJIVFE846PheGOUnFQHUIHqJXWPA/
ghCXIetEAgOgU+Vcv6bgvTKPv3vMjzfvGnKCYm5ZgbMKFLhyUKGLEcGVlW+RSgd6
Q8K5rt0jGrxy2NSrg9xPdVsVvWiYifQXtfxCPG5Srtm8/ve0ss30h936y9frw9iX
TjsvhXK5sKGVUxRp/ix2phIxNyqLr5vG1f7Df9xrRJ3zEyxD813k9ZgMFoMRU4qK
58P1AGs2hQYX7WYn3nSG2BejXpoCyMUMhxLFoX2Xp2OT3CgD9Eex5kY3AuBMmSHk
3RAJo88cQAOqeIWnMBVCHd4xupSlQtMZtUUcADLJz00X4BRhAh6v0TGfOpiHrLPG
HgicSUmqbxT9sy4plUitNWKMizThZdlCuBV4MXOpPNMmugVoz6/Bh1UH0RuQlSb+
D6ModmCJC7xirM3tdXAjQSp+g3mAy2GkR0Pag5d6ngkm1r10eGD775m5Z6DieQsF
2R+mjpJJhSKoh35QL1UREIDJyZHU8yXfYPxL+ZxU4PGmLLGMKYJ13TYseR9OE/x/
skbuaF7AbBB+Ai54Rh+dRTbf7BKKh6cYiaP9+kJCAU+0U2gEIBph06pWDID4XpvZ
gQNMY6DEe45fREG/a5jm
=+bEw
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Apr_2014_11_26_37_+1100_jMLsp+WHsGAlKwQs--
