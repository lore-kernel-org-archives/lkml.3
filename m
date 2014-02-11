Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaBKABm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:01:42 -0500
Received: from ozlabs.org ([203.10.76.45]:38758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaBKAB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:01:28 -0500
Date: Tue, 11 Feb 2014 11:01:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: Disable CONFIG_X86_DECODER_SELFTEST in
 allmod/allyesconfigs
Message-Id: <20140211110117.3da57b1728c80ad2af6baeab@canb.auug.org.au>
In-Reply-To: <20140205055137.GB30094@gmail.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
	<alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
	<CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
	<20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
	<alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
	<20140204090809.GA19156@gmail.com>
	<CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
	<87fvny238i.fsf@tassilo.jf.intel.com>
	<CA+55aFzDp70dv=eCwuOr=gAPVBKaDVUyvFbqedrRJXhUDeHnfQ@mail.gmail.com>
	<20140205055137.GB30094@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Feb_2014_11_01_17_+1100_V_Mt2i1X.dIZ3i1t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Feb_2014_11_01_17_+1100_V_Mt2i1X.dIZ3i1t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Wed, 5 Feb 2014 06:51:37 +0100 Ingo Molnar <mingo@kernel.org> wrote:
>
>=20
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
> > > BTW you probably also want to do the same for the x86 instruction=20
> > > decoder test. It seems to be the biggest compile time waster in=20
> > > allyesconfig and I usually disable it too.
> >=20
> > Agreed, that should be disabled too by default. Although in that=20
> > case I think the COMPILE_TEST combination makes more sense, since=20
> > it's a coverage issue.
>=20
> I'd say randconfig will cover it often enough, and the failure is also=20
> borderline build coverage related: you cannot really make the decoder=20
> test fail via source level changes, only with changes in the build=20
> environment, so I agree with Andi that we can disable this one too -=20
> via the patch below.
>=20
> Thanks,
>=20
> 	Ingo
>=20
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>=20
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 0f3621e..f0fca39 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -184,6 +184,11 @@ config HAVE_MMIOTRACE_SUPPORT
>  config X86_DECODER_SELFTEST
>  	bool "x86 instruction decoder selftest"
>  	depends on DEBUG_KERNEL && KPROBES
> +	#
> +	# It can take some time to validate the image,
> +	# make sure {allyes|allmod}config doesn't enable it:
> +	#
> +	depends on !COMPILE_TEST
>  	---help---
>  	 Perform x86 instruction decoder selftests at build time.
>  	 This option is useful for checking the sanity of x86 instruction

When this got applied to the tip tree, Linus had already applied an
earlier version as commit f8f202348208, and this one (commit
8c778d541bec) now duplicates the actual dependency in !COMPILE_TEST (but
does add a useful comment) ...

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Tue__11_Feb_2014_11_01_17_+1100_V_Mt2i1X.dIZ3i1t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+WhRAAoJEMDTa8Ir7ZwVn50P/jK3+f0r4SDqKLMnCsM9v2Z6
KL72BZLv3cBqVMZLgzYTb9NwIbZXeMlT7E7v4eTt7zkZtJ3zVMX0J8EN9BCBiN4h
doIQnvUSbTn9D2LEQCCqkQRtGOCAiO2MPHVYZcboyfR9BEd7dHsyRhIdkNTCNcF5
6FpRBEuOIl7ar4YJUnTngnDZURJCRZHkN923f0CTR4Fk8Etn0y0uikQ2h2E4if7i
wjrS3hpvWeGUzNozzMsbLn7PCt/nlDqgGXYH79Zf8Ueh1snKJdqtonF7ke6r1VjF
JYUtDc0Ig6oHi5zheJlwPO9N4dYtrCezpGtushFLqVjFN92+yUV1moVBc2QJJ/pB
LbMSwge5D5wlFMkKvyJHxoR8KmJYF526/qUp9OLP2fF4xJB5nWWuMNENOu6AuzXW
D1uWgw4iXWAy0ylJx8wJXUvLvpp9nbcMB2zFndMEiSA0UAHOaZ5sVN7qUZaw2n7W
9pIpMo8FifNBtIGQZ7n4MrgUqxmAMj2lRpJLOspXBe0ozBPUDJAXUXJInMI1roIF
mV1tvM61yNIZurSH6Uxvg1NVjr7NYWDdxTGChHAE/4CfDMstMlN621V7RXadEvbM
Z2whAb/QJqatKDZ5crL7d4oIN1o6+HgJxrxh6+KaYcPCOpI9TqUgmm7qhMu0zyGv
2cQ5PJyiIMAx09WlhyLE
=9FJN
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Feb_2014_11_01_17_+1100_V_Mt2i1X.dIZ3i1t--
