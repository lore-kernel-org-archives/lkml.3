Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3G2BIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:08:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56747 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3G2BI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:08:27 -0400
Date: Mon, 29 Jul 2013 11:08:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_11_08_16_+1000_Z8xgwJTr2m.QLQB2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_11_08_16_+1000_Z8xgwJTr2m.QLQB2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

After merging the ext4 tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/ext4/ialloc.c: In function '__ext4_new_inode':
fs/ext4/ialloc.c:817:1: warning: label 'next_ino' defined but not used [-Wu=
nused-label]
 next_ino:
 ^
fs/ext4/ialloc.c:792:4: error: label 'next_inode' used but not defined
    goto next_inode;
    ^

Hmm ...

Caused by commit 4a8603ef197a ("ext4: avoid reusing recently deleted
inodes in no journal mode").

I have used the ext4 tree from next-20130726 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_11_08_16_+1000_Z8xgwJTr2m.QLQB2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9cCEAAoJEECxmPOUX5FEHqMQAICPjFfpLpx6DelsXRQVmAiP
xJOLJpt4vC7LRXfT6+aR6m0rDjh/g3wbNbsTtqhE7q0QkKTKOU2WwpdXWRBBg2yS
FimEPty61ry8m0cpvw44eKNvCjt0j7b+A3HXdfurgc3J8xzZuvdMMEcIcrZAYHdn
+2zOk3rnNW/mmfqFJoDtR6A8zhUjcGI9u+SO9ecNsPJf257Jm8v5IVfpAAyuj3hs
9hb2hGxp0xhwhC0RvqKrZCZ0pZX5pHLUvTrSQiojMNiCf5PunDxXDxivuGxNdrRz
YvhmtMUqNoRzJCWtHR0tts80L8zAuVtUy4Hye5cVXL60l8b43zmJoAO5ScQuT1NK
1cX8RnzD/6KiZe33v7VBohXQWHjt2vVFqHTbd/Gpo8n+4vFOG7cwFDwZIulPcWVm
OsIKSnTOY8331hjWB4qi2onxCFllFR7fKkV/XQU4/0Y9mtA7AX3Ts18ILE1k3OHl
4ETyLJs3sBJZ6a2Y6Z12LvgqNc/iCuYZiavgUbrTEAHbmHUFVUH7BRd2RtjX8N9+
6zyNe0mqvoC9dsc3xSGEeL0Ih3BCV+GhPLGdONgTxn5Q6jbjwHi7Fis7CFSxWIBw
YJFRl3PNPCrJFkEukoCdcBJTLCHz/j5QAL7RBqGxPn36lD7Ua2il6ulYRf1FBqPi
SBGWjm/dyDdb1ERGToUk
=4T0I
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_11_08_16_+1000_Z8xgwJTr2m.QLQB2--
