Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaJNVyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:54:43 -0400
Received: from ozlabs.org ([103.22.144.67]:35146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbaJNVym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:54:42 -0400
Date: Wed, 15 Oct 2014 08:54:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Riku Voipio <riku.voipio@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gcov: add ARM64 to GCOV_PROFILE_ALL
Message-ID: <20141015085434.2c155706@canb.auug.org.au>
In-Reply-To: <20141014144048.e2bf1f5ec23c39d2a59700f6@linux-foundation.org>
References: <1412852099-23099-1-git-send-email-riku.voipio@linaro.org>
	<543694F4.3070306@linux.vnet.ibm.com>
	<20141014144048.e2bf1f5ec23c39d2a59700f6@linux-foundation.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YbvO8TqYHlX2lJ0tkAUMbjy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YbvO8TqYHlX2lJ0tkAUMbjy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 14 Oct 2014 14:40:48 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > > diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
> > > index cf66c5c..3b74087 100644
> > > --- a/kernel/gcov/Kconfig
> > > +++ b/kernel/gcov/Kconfig
> > > @@ -35,7 +35,7 @@ config GCOV_KERNEL
> > >  config GCOV_PROFILE_ALL
> > >  	bool "Profile entire Kernel"
> > >  	depends on GCOV_KERNEL
> > > -	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
> > > +	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM=
64
> > >  	default n
> > >  	---help---
> > >  	This options activates profiling for the entire kernel.
>=20
> gcov is doing this the wrong way.  There should be a `select
> GCOV_PROFILE_ALL' in each arch/*/Kconfig.

What they should actually do is select (say) ARCH_HAS_GCOV_PROFILE_ALL
and then GCOV_PROFILE_ALL should depend on that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/YbvO8TqYHlX2lJ0tkAUMbjy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUPZueAAoJEMDTa8Ir7ZwVpskP/1x9sAcZAvfsoW+xRDHJBQvD
zU7ejY9FNuOUjR6N6AQvWvvtws9TGUxodmCLeGMf9rFWnV8WvTHPdFcZo/cZoJHs
/BQA4OwnqNKmPinRJHChKUswhuAsqwyLeB+g86gwhCVx+k3C2PWc+BmLaFojxcO2
JIuIcGaTEkWPIARaO8NN/sZb33Ti6/rtuEWLihqW8imGhQIcGXkFUKw6f7ymWgeW
/nf+H1p+TTDm/tgZombqTiofbTm39LY7XWdUKzFilT5z3hMiYPwL0QZ/czOuP9JM
nM4+m7mT4Y765zOV+uJbI1NK53zuz7nXOtU8wLo/gOAlhRZvGIokaXguJnAOCz1a
Mka/F0pALwUdiAu/vQklE79ngWETwZw6mChgaT7vgwSHTtFadwxqCZHWKx/gzbZU
kWoj1vHf7QGXGOm0QslzgpzMQGDdrC75GEwD1U2cQ0U+2XCg+NBmU+mp7Hg4mXXs
KpjzcvzWunqNTl3q6tD6zetRs1+VL5tCKVl956/nS9CaPodjYBAgjNLZmpx4Lt9Q
8HCbzcdQiCkFSSQwYbEEyWHr1aIZ2Z4C0H3MdSANSIfX42eg9bdcXzCXQo9EggN5
Ov7H++k352+NShDIHPgsXK0ScNvYA6KicUqJUy2nUCRQr3qTZMpV4NIuaJGIbE6X
M/1LVmxX8X0PWcNK2DC2
=hUXw
-----END PGP SIGNATURE-----

--Sig_/YbvO8TqYHlX2lJ0tkAUMbjy--
