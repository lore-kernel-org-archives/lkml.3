Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3GCF7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:59:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40995 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3GCF7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:59:19 -0400
Date: Wed, 3 Jul 2013 15:59:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the xen-two tree with the tip tree
Message-Id: <20130703155914.cc0f48d817f4ca02e3bb18a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_15_59_14_+1000_iPetikXqMBA42b9j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_15_59_14_+1000_iPetikXqMBA42b9j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the xen-two tree got a conflict in
arch/x86/xen/time.c between commit 5584880e44e4 ("x86: xen: Sync the
wallclock when the system time is set") from the tip tree and commit
c9d76a24a289 ("xen/time: Don't leak interrupt name when offlining") from
the xen-two tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/xen/time.c
index 7a5671b,a690868..0000000
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@@ -14,7 -14,7 +14,8 @@@
  #include <linux/kernel_stat.h>
  #include <linux/math64.h>
  #include <linux/gfp.h>
 +#include <linux/pvclock_gtod.h>
+ #include <linux/slab.h>
 =20
  #include <asm/pvclock.h>
  #include <asm/xen/hypervisor.h>

--Signature=_Wed__3_Jul_2013_15_59_14_+1000_iPetikXqMBA42b9j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR072yAAoJEECxmPOUX5FEarIQAI6oq2lav83Hu12YVhrgA734
I6GhYNDPKGk2djx8nVFJKwg7YshSNfdP4MMSV3x53UyOtA4qS/l45MI55qPyq3CJ
geeayQRmqG+mE+2wUlt0ZBGR0zUYcTcMVTg1mvBG2znFrDx1dup5uKbF34cl7vnh
vb9ux1c5zutF33msosTsyLg9PndUXzYo5EMGI5+Xv3yDVBlrxupaXPzpPltVyzCc
ouCunIjalycMUgSikR/iiJnZBCuSv2aVnuE6/PcWpO2PCdoLYePKoKaN8V33wruw
QCMxni8/F6yhz0PukH+A1CLYNY9qRBkl92v6hsGl3rXWD57xd0Rra5jMiHHpoCcJ
1+LJQFAIFrTpvwGo9wDYCIE901NjQPTZAwfK/lZBc39at6ev7MPU79vf9OIux5vB
lBCanyCN3mgN6fifYvljaYNYMSp6pxC0aKfL9QCmq6QqFeVV3s6Fp9Mx/Zf0Ht1N
CjJv9P5ECfvyc5ia6nx/D/Y+YvrVk7oCDYBJC4oXbXKi8FS76in+wNvWyhNnjjdG
EPe9qomTxMkdo5XUPk48takz1Ngx9ybVbcd6T3XPDq7joH5aK+FYbtmrVHvgrRyI
4i0OcvhzJrDTuJxlZxMiIql3AH2+dwS3YNxRBAj4EfXJTctd5LqUgoiWjrdgwfIC
LekYn7DAGzUsSrD8E/Mu
=RR9t
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_15_59_14_+1000_iPetikXqMBA42b9j--
