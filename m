Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3LWDqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:46:19 -0500
Received: from ozlabs.org ([203.10.76.45]:39041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab3LWDqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:46:03 -0500
Date: Mon, 23 Dec 2013 14:45:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the akpm-current tree with the pci tree
Message-Id: <20131223144558.d819a0eb17f17a0d353795e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Dec_2013_14_45_58_+1100_lZ2BYV96TUWlrmw="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Dec_2013_14_45_58_+1100_lZ2BYV96TUWlrmw=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
scripts/checkpatch.pl between commit 92e112fdbb3c ("PCI/checkpatch:
Deprecate DEFINE_PCI_DEVICE_TABLE") from the pci tree and commit
369353832de3 ("checkpatch.pl: check for function declarations without
arguments") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/checkpatch.pl
index 9fb30b15c9dc,8f3aecd3e27b..000000000000
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@@ -2634,13 -2630,19 +2630,22 @@@ sub process=20
  				$herecurr);
                 }
 =20
+ # check for function declarations without arguments like "int foo()"
+ 		if ($line =3D~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+ 			if (ERROR("FUNCTION_WITHOUT_ARGS",
+ 				  "Bad function definition - $1() should probably be $1(void)\n" . $h=
erecurr) &&
+ 			    $fix) {
+ 				$fixed[$linenr - 1] =3D~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(voi=
d)/;
+ 			}
+ 		}
+=20
 -# check for declarations of struct pci_device_id
 -		if ($line =3D~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=3D\s*\{/) {
 -			WARN("DEFINE_PCI_DEVICE_TABLE",
 -			     "Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herec=
urr);
 +# check for uses of DEFINE_PCI_DEVICE_TABLE
 +		if ($line =3D~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=3D/) {
 +			if (WARN("DEFINE_PCI_DEVICE_TABLE",
 +				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE=
\n" . $herecurr) &&
 +			    $fix) {
 +				$fixed[$linenr - 1] =3D~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*=
\(\s*(\w+)\s*\)\s*=3D\s*/static const struct pci_device_id $1\[\] =3D /;
 +			}
  		}
 =20
  # check for new typedefs, only function parameters and sparse annotations

--Signature=_Mon__23_Dec_2013_14_45_58_+1100_lZ2BYV96TUWlrmw=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSt7H6AAoJEMDTa8Ir7ZwVuJsQAJKjxhDBsPCBjdHRJawchDaN
KtiiAX6VPzt6MPzRppKxdTZrHUQ24KYDBmA3/1FmEtD+3+TfvZifRAuDlan8Tq4V
C2A9/jz2c16j8Wu8tlWlFrt1VPobrPPW6q4H5K1Gp6n22u0kV0EVQc6+8HBSW3x2
o/5yGkMUhw8rkbWXAvlTi++VGqhqS4xFCvbSvzaNueMQe1sJhY6kmthNJ8ozKCDg
3jB1AigKYiVsT9+jjCcM5bZ3ONUuBmZ6HXCGlub4aRlTmqR1cYx+/kwMKy+L3IjY
i00h5tkbs8qcjINxIFkKg0k/ccU0aqashCj1lhtzMaSIwcfHIlfFzytrp0Hke2pT
T/nY2LP/aq1yP+mQncrZoIB68vXRSxA3iyoD8QsFtPyXq4OcSrl2ZE3bP92QLPbh
LvtwaeAQrYB4nb6KababRajxt54v4+aMMCcrgn/Td5zhtSoR7s+bhNguln7uaUW9
YqK7FBu+7+G1xEY+owVKrnk4zOpjPqkC0A88pVWeC7LUqiRhDYXSbFyqfZC0A/7I
yfRppcTHP9AtTV1US/pjmo5uA7EcOjTz1f1fFbIagWAD0Euv31xu4dFxLzdu7sxP
HqehdbpFzfVJR4Z3N3GC4PNpabj92tphnY/5rkDxID+t5xrsxLsbZ8OBPX9d0xdU
jdxnIHiZAmva1uhCefim
=qB7E
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Dec_2013_14_45_58_+1100_lZ2BYV96TUWlrmw=--
