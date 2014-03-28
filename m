Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaC1VDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:03:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaC1VDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:03:43 -0400
Message-ID: <5335E3AC.8080401@infradead.org>
Date: Fri, 28 Mar 2014 14:03:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH -next] infiniband: fix iser_verbs.c format warning
References: <20140328180950.322d12920ce31e0ad3dace59@canb.auug.org.au>
In-Reply-To: <20140328180950.322d12920ce31e0ad3dace59@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix pr_err (printk) format warning:

drivers/infiniband/ulp/iser/iser_verbs.c:1181:4: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'sector_t' [-Wformat]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Or Gerlitz <ogerlitz@mellanox.com>
Cc:	Roi Dayan <roid@mellanox.com>
Cc:	linux-rdma@vger.kernel.org
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20140328.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-next-20140328/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1178,9 +1178,10 @@ u8 iser_check_task_pi_status(struct iscs
 			do_div(sector_off, sector_size + 8);
 			*sector = scsi_get_lba(iser_task->sc) + sector_off;
 
-			pr_err("PI error found type %d at sector %lx "
+			pr_err("PI error found type %d at sector %llx "
 			       "expected %x vs actual %x\n",
-			       mr_status.sig_err.err_type, *sector,
+			       mr_status.sig_err.err_type,
+			       (unsigned long long)*sector,
 			       mr_status.sig_err.expected,
 			       mr_status.sig_err.actual);
 
