Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3IWE3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:29:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48895 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IWE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:29:09 -0400
Date: Mon, 23 Sep 2013 14:29:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build warning after merge of the block tree
Message-Id: <20130923142901.46a29b6727d0b8b290ad942b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_14_29_01_+1000_4gZ/4rfAstXHXueU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_14_29_01_+1000_4gZ/4rfAstXHXueU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from include/linux/kernel.h:13:0,
                 from drivers/block/skd_main.c:19:
drivers/block/skd_main.c: In function 'skd_cons_skmsg':
drivers/block/skd_main.c:4562:33: warning: format '%u' expects argument of =
type 'unsigned int', but argument 5 has type 'long unsigned int' [-Wformat=
=3D]
   (unsigned long) sizeof(struct skd_fitmsg_context) *
                                 ^
include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                 ^
drivers/block/skd_main.c:4559:2: note: in expansion of macro 'VPRINTK'
  VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
  ^

and several more.

Introduced by commit 0e2c4a3a6c0c ("drivers/block/skd_main.c: fix a few
things, disable on 32-bit"). sizeof() needs %zu to print, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Sep_2013_14_29_01_+1000_4gZ/4rfAstXHXueU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP8OSAAoJEECxmPOUX5FElfUP/ic2TyVC4jgmJqOxQ036lMlW
snt0vSxrXxJcxEaDtOwk+pDXoNtt+yPRx7+8mb45YgckH/djUq6UaBwn0dx+7dhc
Oa8W17nGW8ey2Qc7zvh1JhAs/rxHISmR4BxdQtIbioYmHxn6yMIH+SJp7FOzh8lZ
v4ogGhOyn5ZmGtOf/pw3BHpsCBk2bLk3Qd3D1CfEOnLszCzIOOsNtyVxpEVJLXc1
YldBQptOeMpnxdhObxNhnB5TE9Knc/KvlMxdTlr2S0uvyzeyGxsgc9yICMK+vBok
dr1Jz9NzrFzi1mqDLU0wfeoNi5qB7X3MwiYp7bWtd9qLAXLactrbVFbpfx6lDPPv
Dfw0n6H9f23x/3i9pl4UAlP/YiIHZQjf/ozw67RbMX1VifJHjG5QFcU6wbALTgZg
YTMwc4LqUZV0Ne1NoQI0Hvyct4W0U9kuWuQBwOK2KJPQBpse3ukzmAEe/od1jExs
yIuKzHDmWLJoB7oduZlMilMDwtNlt5ha9nofKPG+ZS/OwcmGzuo97N1T4oAgHrDU
Xf2vfv2Y+jSbrt9u3KtaD8jjnRELPdXDNYbJGrTOgvIUnGsqkngATkDYI6lhHLMh
RRRKc0fiTXSBDjs05VynkgYSXCnelmdsuz5f5vQ8vi/Q6303/9dkpo2vnVYnI791
r+U/Y5ownsWtxc+u5v/3
=4iL1
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_14_29_01_+1000_4gZ/4rfAstXHXueU--
