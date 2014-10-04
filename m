Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaJDBlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 21:41:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47800 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbaJDBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 21:41:03 -0400
Message-ID: <1412386843.9388.176.camel@decadent.org.uk>
Subject: Re: [PATCH RESEND] x86: Reject x32 executables if x32 ABI not
 supported
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 04 Oct 2014 02:40:43 +0100
In-Reply-To: <1410120305.6822.9.camel@decadent.org.uk>
References: <1410120305.6822.9.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-U5xrF+QWqln4v7v+sJrs"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:95ce:e7:6b54:9022
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U5xrF+QWqln4v7v+sJrs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Can one of you please respond to this patch?

Ben.

On Sun, 2014-09-07 at 21:05 +0100, Ben Hutchings wrote:
> It is currently possible to execve() an x32 executable on an x86_64
> kernel that has only ia32 compat enabled.  However all its syscalls
> will fail, even _exit().  This usually causes it to segfault.
>=20
> Change the ELF compat architecture check so that x32 executables are
> rejected if we don't support the x32 ABI.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/x86/include/asm/elf.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index 1a055c8..ca3347a 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -160,8 +160,9 @@ do {						\
>  #define elf_check_arch(x)			\
>  	((x)->e_machine =3D=3D EM_X86_64)
> =20
> -#define compat_elf_check_arch(x)		\
> -	(elf_check_arch_ia32(x) || (x)->e_machine =3D=3D EM_X86_64)
> +#define compat_elf_check_arch(x)					\
> +	(elf_check_arch_ia32(x) ||					\
> +	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine =3D=3D EM_X86_64))
> =20
>  #if __USER32_DS !=3D __USER_DS
>  # error "The following code assumes __USER32_DS =3D=3D __USER_DS"
>=20
>=20

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-U5xrF+QWqln4v7v+sJrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVC9QH+e/yOyVhhEJAQrOoQ/8Dn7REkGdwvcZfPVVdubILt6WEjfXrBTb
TAaXTVot3L62iYi8vbnclYdPs2sILE3zQ0cP+Wqv7LIxQdB8CPa615RlnDRwhIid
TTgRtZU4+n/19yldNh3RPM5yCJObymtLu0SGsiZ4Vs/rZEcf3tVcZKJDRalb4x4b
onUAYH4dpj8ldDiH7GicEtMwWiY9kmb6dYv0W8Zp2xbQBwPhI5QvZ4Zqsq9i9w0Y
Z0yvbOZ4AthfKrBIUe3cPLbibcsj3s7H3e0BKoUNlYvkBp4cg9467+xmOEHwbSHo
0JIiDC20wys+8k4c+BGgLyFtpf3wayC83OKKl1MtSbEZIpImVxmWmbOcK2AFq3nj
SGHGdJQv0Ckj/GwRGsXyKCrIYSUiSMF374PbqOFn1OYbuOReYjMlUmywlxEAp6da
R0PIJbmnHWQuFd275ofbY6K6htFhmfUUx3qoi+6uvgg0tE+c2wil6iURss4reme5
FyJUneb7xzSwYKYebOjsDqZuQu2SMDpQgV8kgVVevZlxBHArDRlKxPw08UbYn3qM
iPPSgmniKpbdcfUDcWDDpQBsUOz25aqOwIN12FjqGZD9e7Q9tJwAQkBfROC4mpic
Ax9Ll1v75eMAim0yWH3Po7A/tYUQK+WupI4JxYZwX7kHhCih9egLP6FSNHxfpvKc
1P+e8l7Oo74=
=bDai
-----END PGP SIGNATURE-----

--=-U5xrF+QWqln4v7v+sJrs--
