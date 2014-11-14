Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934892AbaKNB7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:59:53 -0500
Received: from ozlabs.org ([103.22.144.67]:59233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbaKNB7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:59:51 -0500
Date: Fri, 14 Nov 2014 12:59:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the idle tree with Linus' tree
Message-ID: <20141114125941.3e1f44ff@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SgKJekMxiiJvS6ezx96p_yL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SgKJekMxiiJvS6ezx96p_yL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the idle tree got a conflict in
arch/x86/include/uapi/asm/msr-index.h between commit 8c058d53f6f2
("intel_idle: Disable Baytrail Core and Module C6 auto-demotion") from
Linus' tree and commit a8b65b07d753 ("tools/power turbostat: decode
MSR_*_PERF_LIMIT_REASONS") from the idle tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/uapi/asm/msr-index.h
index e21331ce368f,c1cb18be540e..000000000000
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@@ -149,9 -149,10 +149,13 @@@
 =20
  #define MSR_CORE_C1_RES			0x00000660
 =20
 +#define MSR_CC6_DEMOTION_POLICY_CONFIG	0x00000668
 +#define MSR_MC6_DEMOTION_POLICY_CONFIG	0x00000669
 +
+ #define MSR_CORE_PERF_LIMIT_REASONS	0x00000690
+ #define MSR_GFX_PERF_LIMIT_REASONS	0x000006B0
+ #define MSR_RING_PERF_LIMIT_REASONS	0x000006B1
+=20
  #define MSR_AMD64_MC0_MASK		0xc0010044
 =20
  #define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))

--Sig_/SgKJekMxiiJvS6ezx96p_yL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUZWIUAAoJEMDTa8Ir7ZwVv/UP/2jlQbWPAP8YvGDYccucjm9V
Sxq9B0XGPaklMu9Rq45LeARN+XAXudbL/XwYFdDt1MZVSwwkTPwiCW1gjvhq2tp7
vtKgp+FN0TlrXwpEUb396lvoMmZ4+XZieNjz599ktIAb81VT/HbZ6MwzMTxxaSeQ
2i1vvvFdrW7Xwp5t9j6WauGnm6l5/yGxJBCOWI1bDQZgqZHs8/x/u0Yfpmv10Va0
RAeA3N4SshqJpOCdeZPrwjUx4//c8bix/+Og3XXCwdyVoC6qaUYEf2mFdzZaXlc1
wXHPVS5TmgNwaRmh080pONIQmmFBIlSS+bAhyfITbxaFTmtLk0i+42Rz5XNxmFX7
x9MAkFvdKl4PGWWYd9ZHtE6/XNTPkPQM8Bmlt4KXZmd7S4xumMnzE2/DGOlafsX5
O/aR3k7bcYKSfIokcKLNZbE3AU3gOjZAu0OxHoXnAC1oYEzE947BOZLHCgtTwX0a
hZHlZv/hxrHAOM7B1kNO5YfwKAbtcohDX84LXdB6PXpVrYksFmJ+IfidejDrX4dy
4dSW50GGXUBjC+W0grZYH4j+09v4e9Suo5rhqQPrSsMRsep25dpSSZBItuAlfGOF
actu+2Ozo9xVlKtOYNQSWrIqsQ+OMzIDCCNRu/I7oWgIf5jMsFXwim9ZZFWrIMSA
JD6qIcrRY75l8ojSsKdm
=v652
-----END PGP SIGNATURE-----

--Sig_/SgKJekMxiiJvS6ezx96p_yL--
