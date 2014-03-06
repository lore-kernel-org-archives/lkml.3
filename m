Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaCFG6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:58:01 -0500
Received: from [172.245.23.124] ([172.245.23.124]:44940 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaCFG6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:58:00 -0500
From: Fred Akers <knivey@botops.net>
To: greg@kroah.com, abbotti@mev.co.uk, hsweeten@visionengravers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fred Akers <knivey@botops.net>
Subject: [PATCH v2 2/2] Staging: comedi: range: remove unnecessary sanity check
Date: Thu,  6 Mar 2014 01:57:19 -0500
Message-Id: <1394089039-12408-2-git-send-email-knivey@botops.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140306062333.GA19862@kroah.com>
References: <20140306062333.GA19862@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check is unnecessary because range_table will always be
initialized to range_unknown by comedi_device_postconfig() for
drivers that do not initialize range_table or range_table_list

Signed-off-by: Fred Akers <knivey@botops.net>
---
 drivers/staging/comedi/range.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index c4bb13b..b684954 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -143,10 +143,6 @@ int comedi_check_chanlist(struct comedi_subdevice *s, int n,
 	unsigned int chanspec;
 	int chan, range_len, i;
 
-	if (!s->range_table && !s->range_table_list) {
-		dev_err(dev->class_dev, "(bug) no range type list!\n");
-		return -EINVAL;
-	}
 	for (i = 0; i < n; i++) {
 		chanspec = chanlist[i];
 		chan = CR_CHAN(chanspec);
-- 
1.8.5.3

