Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3HVFHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:07:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3HVFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:07:09 -0400
Date: Thu, 22 Aug 2013 15:07:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Libin <huawei.libin@huawei.com>
Subject: linux-next: manual merge of the workqueues tree with the trivial
 tree
Message-Id: <20130822150703.88405aaf749c77c01dfc5712@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Aug_2013_15_07_03_+1000_Fa4Lt5/x3a=Nt/0U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Aug_2013_15_07_03_+1000_Fa4Lt5/x3a=Nt/0U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/workqueue.c between commit d185af300fe4 ("workqueue: fix some
scripts/kernel-doc warnings") from the trivial tree and commit
2d498db9814c ("workqueue: Fix manage_workers() RETURNS description") from
the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index c60de8e,34b139a..0000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -2038,9 -2033,12 +2039,12 @@@ static bool maybe_destroy_workers(struc
   * spin_lock_irq(pool->lock) which may be released and regrabbed
   * multiple times.  Does GFP_KERNEL allocations.
   *
 - * RETURNS:
 + * Return:
-  * spin_lock_irq(pool->lock) which may be released and regrabbed
-  * multiple times.  Does GFP_KERNEL allocations.
+  * %false if the pool don't need management and the caller can safely sta=
rt
+  * processing works, %true indicates that the function released pool->lock
+  * and reacquired it to perform some management function and that the
+  * conditions that the caller verified while holding the lock before
+  * calling the function might no longer be true.
   */
  static bool manage_workers(struct worker *worker)
  {

--Signature=_Thu__22_Aug_2013_15_07_03_+1000_Fa4Lt5/x3a=Nt/0U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFZx6AAoJEECxmPOUX5FE0iIP/34ia2aOZs6zoWUX3yOYcbv+
ymXvTUEUoq/H6tX9iUC2R6YaxAi2jt6zbB3LDsi/m+JIV96VdaIC9UNEYYHtaQke
e6Dwcqs6xXQNOEROCs1CflvAmKJgsKI58mgYJeAK7o+5C0vrqKNq/8wAkhiXFZn5
B1RC0QmR+kSclbsghkn+RGMdBl5cKxxdSnnHMDMtwSQ1pwx1Rws0mBIC31TafqNy
+sc+8CC3lX4wuh0kivSywa1DEQrPrXyVebvIDV8+2En6vQ5VUrymJkTH5hOYLS+T
cwk29H/qnqxrSGPXpay86xHtQA8zuDApnmbCFkk+02PZgVVnXVIpQMLyZFoUVA63
0o/akVcxSCVnz1tuE1lyl925RnZPFxMzdrhVAOl6dLkx7HULW1uCzF//A1naOXTu
k5SIVxn5Zcl3V5Jcn1Aj8nn/dhVVMBfXMS+av0P4MxLqkbW4VrW5OKozz8HaPlRE
wWL0dYeUHyZ/UPut0ssLYv5mlC+vLzMpxxwUAoQKpqvpMMCTtuXBp/BUMWriLosH
gDVbiXKoCKCPgM55KbiEB34CqFnLvUP+rRzit45a0xI3+TBDiTy/PqyN5iyvt2u5
IpeMSz86dymvdhOPxi37dv8T6CTCubyrgfP2sti7ATvpoMrRMhab+Btf7BncDK+g
wqAWnV55jQavIKobgHKF
=t/2z
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Aug_2013_15_07_03_+1000_Fa4Lt5/x3a=Nt/0U--
