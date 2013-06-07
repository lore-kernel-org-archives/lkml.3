Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3FGGcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:32:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50348 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab3FGGcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:32:18 -0400
Message-ID: <1370586735.3693.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 056/184] KVM: x86: relax MSR_KVM_SYSTEM_TIME alignment check
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Date: Fri, 07 Jun 2013 07:32:15 +0100
In-Reply-To: <20130604172132.630488257@1wt.eu>
References: <20130604172132.630488257@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-H2BjimdKcvPe+l3UMgEk"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H2BjimdKcvPe+l3UMgEk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Marcelo Tosatti <mtosatti@redhat.com>

This was fixed by commit 8f964525a121f2ff2df948dac908dcc65be21b5b
upstream.  This alternate fix avoids the need for extensive backporting.

Ben.

> RHEL5 i386 guests register non 32-byte aligned addresses:
>=20
> kvm-clock: cpu 1, msr 0:3018aa5, secondary cpu clock
> kvm-clock: cpu 2, msr 0:301f8e9, secondary cpu clock
> kvm-clock: cpu 3, msr 0:302672d, secondary cpu clock
>=20
> Check for an address+len that would cross page boundary
> instead.
>=20
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> [dannf: backported to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  arch/x86/kvm/x86.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e24e9ce..79905f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -925,9 +925,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 ms=
r, u64 data)
>  		/* ...but clean it before doing the actual write */
>  		vcpu->arch.time_offset =3D data & ~(PAGE_MASK | 1);
> =20
> -		/* Check that the address is 32-byte aligned. */
> -		if (vcpu->arch.time_offset &
> -				(sizeof(struct pvclock_vcpu_time_info) - 1))
> +		/* Check that address+len does not cross page boundary */
> +		if ((vcpu->arch.time_offset +=20
> +			sizeof(struct pvclock_vcpu_time_info) - 1)
> +			& PAGE_MASK)
>  			break;
> =20
>  		vcpu->arch.time_page =3D

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-H2BjimdKcvPe+l3UMgEk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF+b+e/yOyVhhEJAQo0KBAAgHsOb6gABEqrHJ/6vnrbHQ9eQHTTe1Nr
+KWqkYE+j2NRBjMRTGLF6vPZmp17jCXBIZUUUkAhEMIs8CFX41Txnww/ysXPPahf
6+xl5FgZIWbueQ3pDB8V6AfwT5D2hK03pKVP//RIqQg578b4O22Dj+SCCgojkedQ
U+/wgCSOBycizq5duSLlQ/YccDPZh5BC2XpfpplKcnHQVtg7UQp2LqpdBvOJldEf
RL11GcxFbqnSYf7SwkDwaqgPEOj5z3xPwk2KXKVMIBq/DJkTmGw97XBkIMBPMz9v
vKzarZofZs6txcYLTimdtgfhu4imVODHatuf35H/4SKGR+TbHIWECueTjxYKMrfW
R5TKGo4742GjlFbAo3KA4Ydd+wGW0s17ogzZibyXm5Cm8HBGdLZYUcfvkR00hhFL
31P9BhQXScc0pLFyCh7+iUq+dOp6XUzV0hDXvhd2H5ecaMofCC6BlpmDwJMMCX76
iU2Q4rB4mrXSO6KemcgFpEz/6JVOFRcRaGVkhx4CZxdr7l6UkUrkzpfvmS7tDDEz
n1quQJ4ETrG2GN09gnFOO7hE9CzVBTCScmEQVA1dWiOmbZmtuEJaWxeZqWpuUdHD
yUbp03ye8WlFUwhLe+xe7SLMfRpaTlwoRB8iY8mhl4YyJdFn2+YOAhAqipYlt0E5
ifjXrSNLC6g=
=Bgue
-----END PGP SIGNATURE-----

--=-H2BjimdKcvPe+l3UMgEk--
