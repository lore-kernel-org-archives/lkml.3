Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab3IHDTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56061 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228Ab3IHDSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.448145107@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [022/121] NFSv4.1: integer overflow in decode_cb_sequence_args()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0439f31c35d1da0b28988b308ea455e38e6a350d upstream.

This seems like it could overflow on 32 bits.  Use kmalloc_array() which
has overflow protection built in.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/callback_xdr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -451,9 +451,9 @@ static __be32 decode_cb_sequence_args(st
 	args->csa_nrclists = ntohl(*p++);
 	args->csa_rclists = NULL;
 	if (args->csa_nrclists) {
-		args->csa_rclists = kmalloc(args->csa_nrclists *
-					    sizeof(*args->csa_rclists),
-					    GFP_KERNEL);
+		args->csa_rclists = kmalloc_array(args->csa_nrclists,
+						  sizeof(*args->csa_rclists),
+						  GFP_KERNEL);
 		if (unlikely(args->csa_rclists == NULL))
 			goto out;
 

