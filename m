Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaLWCSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 21:18:01 -0500
Received: from ozlabs.org ([103.22.144.67]:39035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaLWCR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 21:17:59 -0500
Date: Tue, 23 Dec 2014 13:17:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: missing merge fix for the access_once tree
Message-ID: <20141223131749.78087632@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qLiucl.aJ_LaTPkYLOkWgQW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qLiucl.aJ_LaTPkYLOkWgQW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I have been carrying this merge fix patch for some time.  It should
have gone into the merge of the access_once tree.

From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Sun, 7 Dec 2014 22:01:59 +0100
Subject: [PATCH] x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D58145)

Change the p2m code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/xen/p2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8b5db51..08ddf91 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -554,7 +554,7 @@ static bool alloc_p2m(unsigned long pfn)
 		mid_mfn =3D NULL;
 	}
=20
-	p2m_pfn =3D pte_pfn(ACCESS_ONCE(*ptep));
+	p2m_pfn =3D pte_pfn(READ_ONCE(*ptep));
 	if (p2m_pfn =3D=3D PFN_DOWN(__pa(p2m_identity)) ||
 	    p2m_pfn =3D=3D PFN_DOWN(__pa(p2m_missing))) {
 		/* p2m leaf page is missing */
--=20
1.8.5.5

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/qLiucl.aJ_LaTPkYLOkWgQW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUmNDSAAoJEMDTa8Ir7ZwVAf4P/2f3c2K4almHPEGFn0tHrMFP
EY3wBiuUh1qgdxW5MGritGm3WlrsfN50uBxYR5Vil+HF1BnU4rw49PGz9A+F+M96
enC2Xg8FcUgfTFj5Efwg+U4MEfbV6JMHtlYMlDDypNvcY8r09lmHBkyh0GM3nn4x
q50UMQ7AC0knMO1ExGSys/rNuB0NgICF4vnegbirzHScwcFyquu9Z621HFECDR1o
IVOxN8Yqs3sbYEncF8KaYWClJVQ0zlM1Fuysr/rMxjU0L31GoLFPGcNhMFDt1c5W
qaXNMOd8e7qZ1jQJqPCg+KsR1mqcqjNGLCxmdH+PBhFd3tLIoUacXyQG3i0CjT4Y
6WMJje4QTTfLAO2+W1l8Ks5cOThY8h0QqjEfIi+mXEWz9u6mtyqmBmaOy0dX/q3/
VCVb1pn/KM0Os9nBMxFAYIiyjV4kfjWWK86xRRIUWDWZYeT6nbFEOvbOFuAUh9SZ
K3bumluc2PsyMgpyuL0Hbd6fhvxNvXn80MXEZWNJfBUHQT3b8qQYb2tcNF5FOfqk
i/nvFLSysmNUheafzeXs2mRQkQUhleCbPelTzOyszWTg3AfhWetz8LCabr2T1iWQ
3OYeqFC/ddBnZncNhD2zcSH+ttOx8sTJmZLkT4KhbyZJBjKcro1XT57jFobX/8oH
e+C6LDxlQJJSWx/aKr+l
=1yAo
-----END PGP SIGNATURE-----

--Sig_/qLiucl.aJ_LaTPkYLOkWgQW--
