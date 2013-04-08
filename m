Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638Ab3DHBPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:15:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49436 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526Ab3DHBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:15:30 -0400
Date: Mon, 8 Apr 2013 11:15:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20130408111513.da2fc33b28669ede50622d67@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_11_15_13_+1000_4T58_OzANPwy4rUA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_11_15_13_+1000_4T58_OzANPwy4rUA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_init':
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:2990:2: error: assignment of =
member 'owner' in read-only object
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:2991:2: error: assignment of =
member 'owner' in read-only object
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:2992:2: error: assignment of =
member 'owner' in read-only object

Caused by commit d612df096dce ("constify a bunch of struct
file_operations instances").  Grep is your friend ...

I have used the vfs tree from next-230130405 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_11_15_13_+1000_4T58_OzANPwy4rUA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYhohAAoJEECxmPOUX5FEKQQQAIEiUj6FN60ejBXbd0am+8XX
0P3wkuX5p0wr4npJTyzOoOgOFNCg+rO7QYr+BDCHYeYXsmYH5a1TyRWfstxnyZ0J
tpnJTlHobRf9k37j81StCOOfrbR3UK86pjKvJLhnfNn40UqymwvfsmJonf/tmaE2
rD2qg8KFQEwb2ez+7eIL8K4NaMysWnEOPHOtnaNYAbDRzI14StS315zJxg1ByhTy
gBrS8AR5jF3FAIH5CyEzO2u+b2ohPi7cWdPt1RQMi1bNZ+GZpjLxqNw1jyEidP6H
ly/FzBSpyTkXFdpgYP8yEgpFxO4S9rLVgAddUkN+4poycF11LqG034zQLeTnMTrF
niyiMXaQ6X+Xl9t8cdxI4QfPMeKkLL57Fox1CCIWsd2xbtd6q2HWXdGRa3kQ0ryC
+h0bbgbuSSoVSWtgldo8feJPoqmtuT6CSQjS8I/2JwRaz4LUnQunlxCJNKeJhb3r
5klKSNtAtBXpQxgeCNBVVAcA/ucVI3K63R7ezMilLTC7OfFGTScyXPN415ufa/r/
Zkth7QKSINvWXfFw98gtwqEjL1iUFRk3qVJxFUjfCMVO3S/lcT/Q1zlufGyaaXys
5ziYJAJ33Pork53W2a82UzkPTyjUZTagKpnY7sVThD2JPabPKFSOY6iwe/k622uQ
BiNqE4xA0vCdpwllkwxV
=XLU3
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_11_15_13_+1000_4T58_OzANPwy4rUA--
