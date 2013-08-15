Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3HOHz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:55:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39141 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3HOHzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:55:24 -0400
Date: Thu, 15 Aug 2013 10:55:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] PM / devfreq: create_freezable_workqueue() doesn't return an
 ERR_PTR
Message-ID: <20130815075509.GB19280@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The create_freezable_workqueue() function returns a NULL on error and
not an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index e94e619..5088523 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -983,10 +983,10 @@ static int __init devfreq_init(void)
 	}
 
 	devfreq_wq = create_freezable_workqueue("devfreq_wq");
-	if (IS_ERR(devfreq_wq)) {
+	if (!devfreq_wq) {
 		class_destroy(devfreq_class);
 		pr_err("%s: couldn't create workqueue\n", __FILE__);
-		return PTR_ERR(devfreq_wq);
+		return -ENOMEM;
 	}
 	devfreq_class->dev_attrs = devfreq_attrs;
 
