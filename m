Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3CDKQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:16:51 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58016 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab3CDKQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:16:49 -0500
Message-ID: <51347480.3040906@imgtec.com>
Date: Mon, 4 Mar 2013 10:16:32 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Al Viro <viro@ZenIV.linux.org.uk>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the signal tree with Linus' tree
References: <20130304130333.96ae5a2f223cca784bd1aa82@canb.auug.org.au>
In-Reply-To: <20130304130333.96ae5a2f223cca784bd1aa82@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigBFA7E7A32DFE42363562BC1C"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_04_10_16_43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigBFA7E7A32DFE42363562BC1C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/13 02:03, Stephen Rothwell wrote:
> Hi Al,
>=20
> Today's linux-next merge of the signal tree got a conflict in
> include/asm-generic/unistd.h between commit 4dd3c95940b8
> ("asm-generic/unistd.h: handle symbol prefixes in cond_syscall") from
> Linus' tree and commit 24a2641326f1 ("consolidate cond_syscall and
> SYSCALL_ALIAS declarations") from the signal tree.
>=20
> I fixed it up (I used the signal tree version as I think it supersedes
> the former) and can carry the fix as necessary (no action is required).=


Hi Stephen, Al,

It needs this change too, to match the change to arch/blackfin,
otherwise the build breaks for metag.

Cheers
James

diff --git a/arch/metag/include/asm/linkage.h b/arch/metag/include/asm/li=
nkage.h
index 73bf25b..79c69bb 100644
--- a/arch/metag/include/asm/linkage.h
+++ b/arch/metag/include/asm/linkage.h
@@ -4,4 +4,6 @@
 #define __ALIGN .p2align 2
 #define __ALIGN_STR ".p2align 2"
=20
+#define SYMBOL_NAME(_name_) _##_name_
+
 #endif


--------------enigBFA7E7A32DFE42363562BC1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRNHSJAAoJEKHZs+irPybfk1IP/Alq7w3AGEDJjBY5bgKvzyEw
1jYwRAq12P7uxBVA7D59VHU8utmFs7itYLi6PWLcMjROKqvuUZfTcZNC6enMn6EG
Z2p71jtrjfwDWWxfshfJS3tOEFTMzDHuEG9MeNJQBbF76RGgdpobvqa/KkpSjJLA
1CGvyevBrRbvO9xAMVrokUJMHrYsWI874jiz1JicGPFXIcuOLkrLJzID15H3Fg4K
U5EV6VlZPsqnhXj0JOL+C0vE+1rtp4LUEJAk14gDOFzQ2kQc7FJS8lGk+1ddRE+R
1s8y7kSG4UMRPQ/4/Ojg462vzrKlFciIn/xwzLltq5VMX+qFv8n/9pZOoR1mEFUf
h/25BWJryjauKn4EbnSzfeBYj54Igkazs5eXas+iEddaKcLPgSLqcdllm2jqJ1Z5
iFnu40BwOPQt4M4/tBAkwCRcfl1rp9rT0QRc6XhaoPhXll1WB81tyNGwg9rJuefH
sMVpt51LwYrrHgAe++bNHpes1yqTYxPg1ghwp2oH/wVJuP0HDfW0GokSQBRNYZ6U
Em/bNc7UHO8a/krtVRpR2fYktQEhDcKl3grcAerCfH7lcTmEn2h97K6MEZIVPCgZ
8qB7NvJxHsj2agWlAaCTC9aWfEYtwavwkafnjnBzGyEp5RmyvxokzU75+36JTplM
SQQemHVDt2ZcSEA9eY0F
=/pi/
-----END PGP SIGNATURE-----

--------------enigBFA7E7A32DFE42363562BC1C--

