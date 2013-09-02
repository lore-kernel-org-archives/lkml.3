Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3IBI23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:28:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46314 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3IBI22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:28:28 -0400
Date: Mon, 2 Sep 2013 18:28:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Santosh Y <santoshsy@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: linux-next: build warning after merge of the scsi tree
Message-Id: <20130902182817.87a961aa251604b630620028@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Sep_2013_18_28_17_+1000_o071bEmKDPejQMai"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Sep_2013_18_28_17_+1000_o071bEmKDPejQMai
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/scsi/ufs/ufshcd.c: In function 'ufshcd_eh_host_reset_handler':
drivers/scsi/ufs/ufshcd.c:2740:3: warning: 'flush_work_sync' is deprecated =
(declared at /scratch/sfr/next/include/linux/workqueue.h:624) [-Wdeprecated=
-declarations]
   flush_work_sync(&hba->eh_work);
   ^

Introduced by commit c1e846ab4422 ("[SCSI] ufs: Fix device and host reset
methods").  flush_work_sync was deprecated by commit 43829731dd37
("workqueue: deprecate flush[_delayed]_work_sync()") before v3.7-rc1.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Sep_2013_18_28_17_+1000_o071bEmKDPejQMai
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJEwmAAoJEECxmPOUX5FE9y0P/jgYYAkYVqFb8KDS1bxNbeNt
eJR7JkwoEokG26uCPt3NdFjC3IAcycHKNMdgKVzRzrHv07XCvmc6F12JM7/ZFhaE
e4DEUA5ZfvVdeKgokB/a43RltK636JQxypEyTTWb0JmY6r5M7fV5Sn1shL3wb8BV
weNwZg7+/ZEGJsz6QP7rxYgqVz5hUT6qiZ84J9TF161dwA0vTvOKdKBPn4mdUZxI
H1ZQWOdwGBwP2JlO2Mwdx0OMtEwaxRNEcGthUeh8pZzicRgsmk0qai8sBLjrL4iM
lWmz3kFREYHM7dwN2hFnAkVvUQiftUvcoEFjmgYKQjoyN3rGvGk3U585frXKvcgs
r3y5HhzbVqQAnVA+mh4H/nzT0NbVnV5ZuVJV2hRxgcwEociZ4Lw+bdji+UMTS5PV
qPWxRVPKhyJ9Z+it1JlQAEP5f7yHv4fN2+m1Rp3VXqIwJ643/TMJGyYS6zEcRa9j
RBVGv1d5PGI0qIZy+Ej7mGQFNa9U5drzX2hD+mbiw/vNQ0iXjiN1bCcVOO4kx8gq
VnfdggwA1HaKdRqOp4NnbL8z3JUGjEPHgbsBvU2ZRMOSmpaQjbOnpDGlGAtUDuBh
5S775Jm1vzzGClmySlVFg9tU5cJ2Wxe4Wy9LnrKjJZIKbgBW8D9dRocxV7SE+fMM
eaJiaifYmSoyIopnw1xc
=no8s
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Sep_2013_18_28_17_+1000_o071bEmKDPejQMai--
