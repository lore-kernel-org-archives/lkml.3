Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3CDDLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:11:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51288 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3CDDLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:11:03 -0500
Date: Mon, 4 Mar 2013 14:10:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130304141051.a630590df1007f2d349a2d8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_14_10_51_+1100_fMAxWi3o1Wu1Kw/e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_14_10_51_+1100_fMAxWi3o1Wu1Kw/e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/built-in.o: In function `setup_arch':
(.init.text+0xc38): undefined reference to `early_console'
arch/sparc/built-in.o: In function `setup_arch':
(.init.text+0xc44): undefined reference to `early_console'

Caused by commit 16ac99bd7acd ("early_printk: consolidate random copies
of identical code").  This build does not have CONFIG_EARLY_PRINTK defined.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_14_10_51_+1100_fMAxWi3o1Wu1Kw/e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNBC7AAoJEECxmPOUX5FE2wQQAJcgrA8vC7iM6YQmLHKMo5t8
YP/cc0ebTzT/huytRH1qClkrCyeFoFxjEYRqtrSX9Cb35KTd2jDoONm7W9NRfgSV
0tXFids2sdmNtRMSf/5fBdqmAmzBMJB1kgEbeo+O1JE09HZq9w1+IWCUFAmRkwvc
Wu04KAEOUff5714f7CpBaYwJ+voxIpIUJZ2xR8UFty0rjaJuVhaVNVREMoTTFiTR
lBJr5b/LnaRXxCt873JgW2UfSErT2jpAqDP3Gg41bsPqX7PttVieyp2rZnQyC5Rw
4TRky1s9VtNyAcv+WHj+kpBeO0818ViC4Dr82hv0hLPXd7QcRZv8TMqvG1h295Qc
V+PQapht66PTPtjaeJ494ahZQL5y1asBrF3QHKnOAcGGX3RTKsFGOyK4H/wOJKeo
zvAmZTb/n8EppwIxOdqWXES0zZvsfdqOb6u1QLCyCRkdGRRMDmIFofA98ldmF/Pt
vgXXxG+9EYLQwcoUp3v2KSxD1nLhw47M3SSNdZWEK4Ue8EheC4RFBp19bZ0KTZw0
9CvgZGnNpraKRddeGkqoVH0iXYiZc5Zp7s9ufPTvXA9CQxpnOFB9hQX9GTng8Bsd
FPoqSQrh0g73OifzmKfpvm1aiGf2NM0SHXyFH5fWfprr68sIP+d0/JD+a/zIxkHB
awDczXOpSGPEyEz+oT8R
=8mbw
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_14_10_51_+1100_fMAxWi3o1Wu1Kw/e--
