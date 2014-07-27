Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaG0V65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 17:58:57 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54127 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaG0V64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 17:58:56 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_1DEAC5A6-993B-43B4-BF50-2E978DFFE30A"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] arch: x86: ia32: ia32_aout.c:  Cleaning up missing null-terminate in conjunction with strncpy
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <1406411423-6964-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 27 Jul 2014 14:58:53 -0700
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Message-Id: <AFFEFE7F-D89B-4289-AB28-0B068C2C15AA@gmail.com>
References: <1406411423-6964-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_1DEAC5A6-993B-43B4-BF50-2E978DFFE30A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Rickard,

On Jul 26, 2014, at 2:50 PM, Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se> wrote:

> Replacing strncpy with strlcpy to avoid strings that lacks null =
terminate.
> And use the sizeof on the to string rather than the from string.
>=20
> Signed-off-by: Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se>
> ---
> arch/x86/ia32/ia32_aout.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
> index d21ff89..1a5eb43 100644
> --- a/arch/x86/ia32/ia32_aout.c
> +++ b/arch/x86/ia32/ia32_aout.c
> @@ -156,7 +156,7 @@ static int aout_core_dump(struct coredump_params =
*cprm)
> 	fs =3D get_fs();
> 	set_fs(KERNEL_DS);
> 	has_dumped =3D 1;
> -	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
> +	strlcpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
> 	dump.u_ar0 =3D offsetof(struct user32, regs);
> 	dump.signal =3D cprm->siginfo->si_signo;
> 	dump_thread32(cprm->regs, &dump);

This patch appears to introduce an information leakage as well. The dump =
structure is on the stack and not cleared, so changing to strlcpy leaves =
part of the u_comm field holding unintialized data which is then written =
into the dump. The sizeof in the 3rd argument of the original is really =
an incorrect reference, as you corrected. A question to consider in this =
case: is the string in that structure expected to always be =
null-terminated or not. It is not the case that all such character =
arrays are expected to be. I don't happen to know in this case.

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_1DEAC5A6-993B-43B4-BF50-2E978DFFE30A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT1XYdAAoJEDwO/+eO4+5uwwUQAKIeb1JFN8vNzkMoXXkgacgi
vttH0SMsqSeDB1YzfpqM6UomzgINo2Rs2/9W12SPhxLbDysptX/OGp7lN3vNF7s9
ns+zI3N+gh7eMsKpOyeMnCAcQTjZ8KC2qcOXDekbGDR6B2OdOlicLo/VhUyU9sBf
lx4nBLPjqH17qwf6fHxOyAc+CtQgJKZ2QwNPVMu4/02I+TYh+IktYQ4iCSos/7U6
v4EGPAbC9HdP8A5wW6Z5AmF4LDP6sm9gAPq5Qich5t59LX2i/3IMnwAePapy2vvF
tvjQZn9A9X3/49g8hkWs5TiH3KsANVLKhnW88fi82v4fqcO15/07Um2WTPMjxwmp
dwYLxmUOEapOQQVVumHojj4BgHJpP+btZdrj7/3BWLfCI5Isji6g3bDZJFrOYsKo
jc186d3va29ntg1hQHiVV69oeDZMt3F7bCrWX7ZlT7MXFDsXAPLr06s5D54sOr+W
UaEUST6K4Je7JjU7J5onhQx1IEeUwKZMgHazsr0GSHlxPjOvDaonDGBjsf9Il7qX
w/Ltc8eNbhpMnJPB/twiA/xVG6TAonST3MfoTwRNQoLqgkH/Qk0TP1fRTZ0kZ0VN
veLY9LnQV4CkZiF2p9CaoOKM1kiB1jV47EPJXN2VBX3O4LnlHFkWSzyMggJ1B1GX
BUIneGxX6CbS/NCsIOxD
=XSZC
-----END PGP SIGNATURE-----

--Apple-Mail=_1DEAC5A6-993B-43B4-BF50-2E978DFFE30A--
