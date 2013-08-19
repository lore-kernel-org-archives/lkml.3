Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784Ab3HSEJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:09:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38558 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3HSEJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:09:37 -0400
Date: Mon, 19 Aug 2013 14:09:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jason Wang <jasowang@redhat.com>
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-Id: <20130819140921.7c43b398fdc9eb6e53b631ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_14_09_21_+1000_B=zTrAtOf3MlJasK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_14_09_21_+1000_B=zTrAtOf3MlJasK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/include/asm/processor.h between commit 61c63e5ed3b9 ("cpufreq:
Remove unused APERF/MPERF support") from the pm tree and commit
96e39ac0e9d1 ("x86: Introduce hypervisor_cpuid_base()") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/processor.h
index 4f4a3d9,61a5533..0000000
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@@ -942,6 -942,50 +942,21 @@@ extern int set_tsc_mode(unsigned int va
 =20
  extern u16 amd_get_nb_id(int cpu);
 =20
 -struct aperfmperf {
 -	u64 aperf, mperf;
 -};
 -
 -static inline void get_aperfmperf(struct aperfmperf *am)
 -{
 -	WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_APERFMPERF));
 -
 -	rdmsrl(MSR_IA32_APERF, am->aperf);
 -	rdmsrl(MSR_IA32_MPERF, am->mperf);
 -}
 -
 -#define APERFMPERF_SHIFT 10
 -
 -static inline
 -unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 -				    struct aperfmperf *new)
 -{
 -	u64 aperf =3D new->aperf - old->aperf;
 -	u64 mperf =3D new->mperf - old->mperf;
 -	unsigned long ratio =3D aperf;
 -
 -	mperf >>=3D APERFMPERF_SHIFT;
 -	if (mperf)
 -		ratio =3D div64_u64(aperf, mperf);
 -
 -	return ratio;
 -}
 -
+ static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t le=
aves)
+ {
+ 	uint32_t base, eax, signature[3];
+=20
+ 	for (base =3D 0x40000000; base < 0x40010000; base +=3D 0x100) {
+ 		cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);
+=20
+ 		if (!memcmp(sig, signature, 12) &&
+ 		    (leaves =3D=3D 0 || ((eax - base) >=3D leaves)))
+ 			return base;
+ 	}
+=20
+ 	return 0;
+ }
+=20
  extern unsigned long arch_align_stack(unsigned long sp);
  extern void free_init_pages(char *what, unsigned long begin, unsigned lon=
g end);
 =20

--Signature=_Mon__19_Aug_2013_14_09_21_+1000_B=zTrAtOf3MlJasK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEZp1AAoJEECxmPOUX5FE2tcP/R05/uNPDZiPcFbcRd7CfMIX
rv9Gdk/vW9pGkYyI7XhjL1qlr3VWeWGNPMkY/5GsuS82MOxI+wJgZy61MeC7oNk6
0sxY5KEOU66w6/GsjnuRzSmLQ1OQRKfVxfk4lSX4dz3ez4yTO63euICFrY3Dr6Ir
EXNdBJFLvQkibkb1tdlX+fMNJ6P6RHiWYJcO8m/O2criMm6QjkGgbMgwWOcXPoPM
EktZztgJelhb5TbpXlL4Q+4KdPkhsXPyOgzPvVri428WyhFjiEBik+g054+Ilcqb
OEvQ6w6YvF3kR8n7/rVsAGgnz+8Y6ecIT/Z5Hl5E1uBGAUsuMW6usVqYAnnmeK+h
368Rr6W+NhvdsEi2pOSVy7LswA0Y3QvM2RECtXDg1M/OkohfRxGU97thnppdNbyg
LMXWklXgqmmF07do/ygOyHBkb2kth45J52gEitFpVKDQIRdNtt6yvYe8lh6qIH4+
EbxHoLkKkX7XKHA5U2Kx5AbQLugrVk6J8B6H3EGvSBO5i7hEyNaSyWRmZ6gMRUhI
XFXS5GQkGkQOCjiWa/4XDxxc6ZnTm81Sb1cXnn58qdnXVFUX9+flSzfyO8QRCv7+
THCChsyrCaJZac//y2ySjEJZVij5jVIcqJ1kt36hWraU0FUj9exsXaS2gdZT3Tw8
ZWa2fnfqyesTuIHqRx9t
=8QhQ
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_14_09_21_+1000_B=zTrAtOf3MlJasK--
