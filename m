Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3ESNAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 09:00:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35140 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab3ESNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 09:00:04 -0400
Date: Sun, 19 May 2013 15:59:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] gru: fix a sanity test in gru_set_context_option()
Message-ID: <20130519125950.GA17651@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"req.val1 == -1" is valid but it doesn't make sense to check
gru_base[-1].  gru_base[] is a global array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index c4acac7..e7c37b2 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -876,7 +876,8 @@ int gru_set_context_option(unsigned long arg)
 	switch (req.op) {
 	case sco_blade_chiplet:
 		/* Select blade/chiplet for GRU context */
-		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
+		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES ||
+		    (req.val1 != -1 && !gru_base[req.val1]) ||
 		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
 			ret = -EINVAL;
 		} else {
