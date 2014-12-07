Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaLGKWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:22:31 -0500
Received: from mout.web.de ([212.227.17.11]:63088 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbaLGKW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:22:29 -0500
Message-ID: <54842A61.5080006@web.de>
Date: Sun, 07 Dec 2014 11:22:25 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Disable unrestricted mode if ept=0
References: <jpg388s95zb.fsf@redhat.com>
In-Reply-To: <jpg388s95zb.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tnAe4I37OQdXeLG2SXP1FP80s71tudeI8"
X-Provags-ID: V03:K0:toXXxz26rxj406tbv+xmSJfuSKQkd6mthHZo7nqmkiNVHeFTKMY
 rSVVVeo1nXQbRU/bKrm8m3no0B27POlxjKutl8OPPsh7VhqGQMS96Z0SWyTqBaba8DbI5Eb
 HBXY2F0Eeqs7MHxTt9M5uArvTl5wU2Ks5MOcPEXInjik08DAkWr46Rt9EZy4cw1aT/MwThT
 7gvrY9N+4oSDOwLJOSTjA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tnAe4I37OQdXeLG2SXP1FP80s71tudeI8
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-12-06 16:02, Bandan Das wrote:
>=20
> If L0 has disabled EPT, don't advertise unrestricted
> mode at all since it depends on EPT to run real mode code.
>=20
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3e556c6..ed70394 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2377,12 +2377,12 @@ static __init void nested_vmx_setup_ctls_msrs(v=
oid)
>  	nested_vmx_secondary_ctls_low =3D 0;
>  	nested_vmx_secondary_ctls_high &=3D
>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> -		SECONDARY_EXEC_UNRESTRICTED_GUEST |
>  		SECONDARY_EXEC_WBINVD_EXITING;
> =20
>  	if (enable_ept) {
>  		/* nested EPT: emulate EPT also to L1 */
> -		nested_vmx_secondary_ctls_high |=3D SECONDARY_EXEC_ENABLE_EPT;
> +		nested_vmx_secondary_ctls_high |=3D SECONDARY_EXEC_ENABLE_EPT |
> +			SECONDARY_EXEC_UNRESTRICTED_GUEST;
>  		nested_vmx_ept_caps =3D VMX_EPT_PAGE_WALK_4_BIT |
>  			 VMX_EPTP_WB_BIT | VMX_EPT_2MB_PAGE_BIT |
>  			 VMX_EPT_INVEPT_BIT;
>=20

Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>

Jan



--tnAe4I37OQdXeLG2SXP1FP80s71tudeI8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlSEKmEACgkQitSsb3rl5xQehwCg6QOqwmMo6IoO55OMLRNh0pyg
UmMAoMUoPtMqYUuauAs7bHu+mrAF4286
=+v5/
-----END PGP SIGNATURE-----

--tnAe4I37OQdXeLG2SXP1FP80s71tudeI8--
