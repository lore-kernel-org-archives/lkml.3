Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbbAPLaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:30:13 -0500
Received: from www.osadl.org ([62.245.132.105]:48856 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbbAPLaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:30:11 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Bart Van Assche <bvanassche@acm.org>, Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@infradead.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] ib_srpt: wait_for_completion_timeout does not return negativ status
Date: Fri, 16 Jan 2015 12:20:17 +0100
Message-Id: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Patch is against 3.19.0-rc3 -next-20150109

Patch was compiletested only with x86_64_defconfig +
CONFIG_TARGET_CORE=m, CONFIG_INFINIBAND=m, CONFIG_INFINIBAND_SRPT=m

 drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index eb694dd..4e58c76 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3533,7 +3533,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	spin_unlock_irq(&sdev->spinlock);
 
 	res = wait_for_completion_timeout(&release_done, 60 * HZ);
-	WARN_ON(res <= 0);
+	WARN_ON(res == 0);
 }
 
 /**
-- 
1.7.10.4

