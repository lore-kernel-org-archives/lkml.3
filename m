Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3IWHdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:33:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35236 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWHdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:33:42 -0400
Date: Mon, 23 Sep 2013 17:33:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (random
 tree related)
Message-Id: <20130923173321.9139c9a3d895faff75b31e4e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_17_33_21_+1000_G3ThOsjB.kPmEAOe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_17_33_21_+1000_G3ThOsjB.kPmEAOe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

In file included from include/linux/sched.h:17:0,
                 from arch/arm/kernel/asm-offsets.c:13:
include/linux/timex.h: In function 'random_get_entropy':
include/linux/timex.h:80:2: error: implicit declaration of function 'read_c=
urrent_timer' [-Werror=3Dimplicit-function-declaration]

Caused by commit 5030b0ad98ec ("random: allow architectures to optionally
define random_get_entropy()") from the random tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Sep_2013_17_33_21_+1000_G3ThOsjB.kPmEAOe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP+7HAAoJEECxmPOUX5FEyecQAJZRyJEXiOCf7VTKSB5CvcLS
EQcGbH1FfBMDwNUF1j4G1Z+3+C6Zzj7uOPSFDR9hUFA8d4ZIWbKXjZu/SQilqsf3
tANoPKAOkUj2Duii30Ve/dzdutEtcdBT9fWunKAUDicKRxMgjKxXrAXPE2FELy02
rv2yQ9+scOva6aQgz6/+RJXAkpvliplk6hgQg307UF2aSaVIEDVGpSKOLB/xaAlT
QNJeurymlzCvU1i02KR4lBlBuO/z9loP+AunNkupskzbyYcUGOxIXIb+YSzFarBW
uhnpA7gfwPtBewAtC1QY2i3PoD16pHRiKQxdnpf0KJp3Wh0xEzonQf1Zrl5iYZ6N
eXh+Uh8/MI+KSkkby3QJvRwkU8MIfxnsT2j+jitBHq4vR0LXLADHnRi+gt4lE8L2
CYPFg8l86H/fuTWVSsUAIgOs/LC2hWL5L2n8RPqaWCD1u7LxPPmcdtwK3JH+RMNk
I6yGTIDVOba9QLs4BBmH3R6gIdlTnEV/vNqn0NkN7+EowR2bBDs9pDUKigMOaHsY
CouQKCGWWQ6YuDBn4FwfMNqa1v0MbXGCskmUstVBm3zL8NC02O/MnlISAcB5NUpc
jvNKbuCWzYudDjhRfsQpJ8BRHZ6zqf8e92Z6DdwhvzJErUpQetcbBNBKqxEKNr9V
mS9WKdNVDzJ52hNNOu1e
=rmn8
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_17_33_21_+1000_G3ThOsjB.kPmEAOe--
