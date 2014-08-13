Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaHMOVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:21:39 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:46135 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHMOVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:21:38 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_316B1F83-C7E5-4EE4-BA0F-487C9E3BC87B"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] KVM: x86: Avoid emulating instructions on #UD mistakenly
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1407937813-1461-1-git-send-email-namit@cs.technion.ac.il>
Date: Wed, 13 Aug 2014 17:21:29 +0300
Cc: gleb@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Message-Id: <B8075446-5721-4D41-99A1-19B729691F42@gmail.com>
References: <1407937813-1461-1-git-send-email-namit@cs.technion.ac.il>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_316B1F83-C7E5-4EE4-BA0F-487C9E3BC87B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Correction: the word =93never=94 in the message is too harsh.
Nonetheless, there is a regression bug. I encountered it with =93wrfsbase=94=
 instruction.

Nadav

On Aug 13, 2014, at 4:50 PM, Nadav Amit <namit@cs.technion.ac.il> wrote:

> Commit d40a6898e5 mistakenly caused instructions which are not marked =
as
> EmulateOnUD to be emulated upon #UD exception. The commit caused the =
check of
> whether the instruction flags include EmulateOnUD to never be =
evaluated. As a
> result instructions whose emulation is broken may be emulated.  This =
fix moves
> the evaluation of EmulateOnUD so it would be evaluated.
>=20
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
> arch/x86/kvm/emulate.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 56657b0..37a83b2 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4394,6 +4394,9 @@ done_prefixes:
>=20
>  	ctxt->execute =3D opcode.u.execute;
>=20
> +	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
> +		return EMULATION_FAILED;
> +
>  	if (unlikely(ctxt->d &
>  		     =
(NotImpl|EmulateOnUD|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
>  		/*
> @@ -4406,9 +4409,6 @@ done_prefixes:
>  		if (ctxt->d & NotImpl)
>  			return EMULATION_FAILED;
>=20
> -		if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
> -			return EMULATION_FAILED;
> -
>  		if (mode =3D=3D X86EMUL_MODE_PROT64 && (ctxt->d & =
Stack))
>  			ctxt->op_bytes =3D 8;
>=20
> --=20
> 1.9.1
>=20


--Apple-Mail=_316B1F83-C7E5-4EE4-BA0F-487C9E3BC87B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQEcBAEBCgAGBQJT63RpAAoJEHlOP0Zr1lTYWa0H/jJIjGEJvdDN6rSeq01W95it
SoWEaPGpgPnrbG3v1s6IXhxV0jEvh28inZWgYm9rpvf1IyNfQjE51TRlUAnAEuZX
CRnkiHW/3OE4oiSZeh67t7exmryJcKxeMXB0veOAMUSJtblAnF/0dw2ZwRC5acAX
G3HqXexF2Bzix8TVHDMy3uSJgSCMlOaNZxjSlk3edikJ11FaxAPVT2wDaRdxsL8b
MKrSH2BVtdshmhQz4v6H9oOyyE7N9NPaDbNCBjrG7i/+QXqCN1k/Uyo89fnMhPum
sDt2RH0+aQx7nEJmaAc+3B2+5xAAAgzUVr/ZSfTwwkYGLEqpi4U+gi+Fvr/0QVw=
=Hf5H
-----END PGP SIGNATURE-----

--Apple-Mail=_316B1F83-C7E5-4EE4-BA0F-487C9E3BC87B--
