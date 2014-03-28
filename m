Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaC1Fwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 01:52:47 -0400
Received: from ozlabs.org ([203.10.76.45]:36950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaC1Fwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 01:52:45 -0400
Date: Fri, 28 Mar 2014 16:52:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140328165238.7d9e0804a2781eaaa88a4fa5@canb.auug.org.au>
In-Reply-To: <20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
	<20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Mar_2014_16_52_38_+1100_65zhXI=U50JLGDgO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Mar_2014_16_52_38_+1100_65zhXI=U50JLGDgO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 6 Mar 2014 15:00:10 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 24 Feb 2014 15:17:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the tip tree, today's linux-next build (arm
> > multi_v7_defconfig) produced this warning:
> >=20
> > drivers/irqchip/irq-armada-370-xp.c:415:1: warning: 'externally_visible=
' attribute have effect only on public objects [-Wattributes]
> > drivers/irqchip/irq-sun4i.c:39:70: warning: 'externally_visible' attrib=
ute have effect only on public objects [-Wattributes]
> > drivers/irqchip/irq-sun4i.c:140:1: warning: 'externally_visible' attrib=
ute have effect only on public objects [-Wattributes]
> > drivers/irqchip/irq-gic.c:283:1: warning: 'externally_visible' attribut=
e have effect only on public objects [-Wattributes]
> > drivers/irqchip/irq-sirfsoc.c:51:1: warning: 'externally_visible' attri=
bute have effect only on public objects [-Wattributes]
> > drivers/irqchip/irq-vt8500.c:183:1: warning: 'externally_visible' attri=
bute have effect only on public objects [-Wattributes]
> >=20
> > Probably introduced by commit 128ea04a9885 ("lto: Make asmlinkage __vis=
ible").
> >=20
> > I guess that there may be more places where "asmlinkage" is used with
> > "static" - I assume that they are all incorrect?
> >=20
> > $ git grep -l 'static.*asmlinkage'
> > arch/x86/crypto/sha1_ssse3_glue.c
> > arch/x86/crypto/sha256_ssse3_glue.c
> > arch/x86/crypto/sha512_ssse3_glue.c
> > drivers/irqchip/irq-armada-370-xp.c
> > drivers/irqchip/irq-bcm2835.c
> > drivers/irqchip/irq-gic.c
> > drivers/irqchip/irq-mmp.c
> > drivers/irqchip/irq-moxart.c
> > drivers/irqchip/irq-orion.c
> > drivers/irqchip/irq-sirfsoc.c
> > drivers/irqchip/irq-sun4i.c
> > drivers/irqchip/irq-vic.c
> > drivers/irqchip/irq-vt8500.c
> > drivers/irqchip/irq-zevio.c
> > drivers/pnp/pnpbios/bioscalls.c
> > scripts/checkpatch.pl
> >=20
> > (the last two don't matter)
>=20
> Any resolution for this?

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Mar_2014_16_52_38_+1100_65zhXI=U50JLGDgO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTNQ4qAAoJEMDTa8Ir7ZwV0mMP/09Vwcmxl76eYdGlRcwD/mbs
PxIVmFBk6HdGzZfC0baa65aPwergoUHs97jmY97EL4pLEd8Wcwx+w7YPJ1TYOYJ0
vhuOHnlQN14C8GhWQV0YgyGX0Gt/LB++uPYkIm7ClUFo24pZABZZ/8AjuRiDOCid
hbo+FRXa5JUXov+68IKl6ufZ4Tu0mFvN9UxnN6X1QdhNge6zaSl8JN/u1wdkdkFL
HLlKCRgO9iSwfREL9CAqYI0rsVWls0q91hq6sbfEQzygAHwQ+zZ8lASmlOBgETpv
RN+DqODv0S2WfGZjXVipEKda2vJPp73sKbDM9RsgoWCzlUhvmyaT6k+Pn6j/NOCx
L78Le3n2pyuQ/nuFm7YzPwx/hEgq5VIz6MQZgXadimWnaGMPlrKhtWyBrPUiVtUf
SPdtJkWv9MzGbQoSI1ZROS+jVc+TK4x8aa09uPUARl/iCuGQdt6JPrwo8EAVxzYp
K5YIOn8Z6XEyrmh7S/9s/NgqtdYaktRR68P2wwAKvMkvXcEOmicNwBO08zq0fqrX
skWEAMOrIEmTCUWY7UCkDkiLee0cvDqlFM53kHeLK5t7B+DfLgMVnjuyWRmYxBMx
gwGjqeqz/saNh/Qrbi7RobmdtPZdH9hBoTu07KXcYFP3o8gbw0cK73vroxDxkkkp
iZUQ9l4+gRDufZg/AcFF
=T2Or
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Mar_2014_16_52_38_+1100_65zhXI=U50JLGDgO--
