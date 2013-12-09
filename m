Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab3LIGdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:33:04 -0500
Received: from ozlabs.org ([203.10.76.45]:56267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760582Ab3LIGdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:33:01 -0500
Date: Mon, 9 Dec 2013 17:32:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: linux-next: build failure after merge of the final tree (powerpc
 tree related)
Message-Id: <20131209173255.599c63da380bafbdcd98d47f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Dec_2013_17_32_55_+1100_IJEOCgQFQSR2n416"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Dec_2013_17_32_55_+1100_IJEOCgQFQSR2n416
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:958: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:959: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:983: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:984: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:1003: Error: attempt to move .org back=
wards
arch/powerpc/kernel/exceptions-64s.S:1013: Error: attempt to move .org back=
wards
arch/powerpc/kernel/exceptions-64s.S:1014: Error: attempt to move .org back=
wards
arch/powerpc/kernel/exceptions-64s.S:1015: Error: attempt to move .org back=
wards
arch/powerpc/kernel/exceptions-64s.S:1016: Error: attempt to move .org back=
wards
arch/powerpc/kernel/exceptions-64s.S:1017: Error: attempt to move .org back=
wards
arch/powerpc/kernel/exceptions-64s.S:1018: Error: attempt to move .org back=
wards

Caused by commit 1e9b4507ed98 ("powerpc/book3s: handle machine check in
Linux host").

I have reverted these commits (possibly some of these reverts are
unnecessary):

b63a0ffe35de "powerpc/powernv: Machine check exception handling"
28446de2ce99 "powerpc/powernv: Remove machine check handling in OPAL"
b5ff4211a829 "powerpc/book3s: Queue up and process delayed MCE events"
36df96f8acaf "powerpc/book3s: Decode and save machine check event"
ae744f3432d3 "powerpc/book3s: Flush SLB/TLBs if we get SLB/TLB machine chec=
k errors on power8"
e22a22740c1a "powerpc/book3s: Flush SLB/TLBs if we get SLB/TLB machine chec=
k errors on power7"
0440705049b0 "powerpc/book3s: Add flush_tlb operation in cpu_spec"
4c703416efc0 "powerpc/book3s: Introduce a early machine check hook in cpu_s=
pec"
1c51089f777b "powerpc/book3s: Return from interrupt if coming from evil con=
text"
1e9b4507ed98 "powerpc/book3s: handle machine check in Linux host"

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Mon__9_Dec_2013_17_32_55_+1100_IJEOCgQFQSR2n416
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpWQbAAoJEMDTa8Ir7ZwVbDsP/igqKWHTyjYzHuL3fWutUSw4
9VpPjC3q6bCLnBV/UcBLl2BVqepMSwsJsGZkQPvPaNTJpCbAZZZkFlXIaE2VQAUd
Cml9gRVAy+BuqppTTuuj5wfeTBAMuO1oIs1+ysnLUKRe4nDmhzMahWmTn5ZpkZ0n
0MWVsZA9BhNaqYuDibl2FpsoZVxBGa/p81LxQCuMnUkZ/YCvmEjhskUlwACh8GXg
iPCD1PJ6O6/pZuCz6z7atmWgBC+okmtsKLtGicBHCEpIPu5acXbchKRi4dNgl9sC
ZtKWKyl3nz7e75Epm6u8IYznCs9sLoBtzR/XVZQw6azugwAIAiAtK6sah9c8iipl
aRlAhHpiceOqESmRSq6dbjqwBumuT3v5wd4aOJQkQ7M5O8aiLFnJ/G9a0iVCF93/
09MIWRiv9ARWLYMhK3HBJ2QKfclqPyv6H7AGsIv5bkguP1DnzGRnQzW029OTHX9r
iXW36EvEO3LWLass6U7vbGRwhDNxQ8ToYSJP6kgMJnxPtstKcFeEIbSsV1TrseG/
OSD544lQMktKzMvpOUnpsk7utRizy4PBOjmg6ocJD9iipLWcs15cjTccUKIv3g45
o1cXOwbVDJVxb4kdyABmhoLMOxw3jNztblaGW87ed91237jlxjNrhFcem9scc1+/
FZAd4SYGMHLsLWPrYHC1
=TDqO
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Dec_2013_17_32_55_+1100_IJEOCgQFQSR2n416--
