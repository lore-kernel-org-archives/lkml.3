Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaCEIcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:32:14 -0500
Received: from [172.245.23.124] ([172.245.23.124]:59413 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaCEIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:32:12 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 03:32:12 EST
From: Fred Akers <knivey@botops.net>
To: greg@kroah.com, abbotti@mev.co.uk, hsweeten@visionengravers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fred Akers <knivey@botops.net>
Subject: [PATCH] Staging: comedi: range: tidy up comedi_check_chanlist()
Date: Wed,  5 Mar 2014 03:11:47 -0500
Message-Id: <1394007107-6219-1-git-send-email-knivey@botops.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor this function to remove an extra indent level

Signed-off-by: Fred Akers <knivey@botops.net>
---
 drivers/staging/comedi/range.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 46b3da6..c4bb13b 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -143,29 +143,28 @@ int comedi_check_chanlist(struct comedi_subdevice *s, int n,
 	unsigned int chanspec;
 	int chan, range_len, i;
 
-	if (s->range_table || s->range_table_list) {
-		for (i = 0; i < n; i++) {
-			chanspec = chanlist[i];
-			chan = CR_CHAN(chanspec);
-			if (s->range_table)
-				range_len = s->range_table->length;
-			else if (s->range_table_list && chan < s->n_chan)
-				range_len = s->range_table_list[chan]->length;
-			else
-				range_len = 0;
-			if (chan >= s->n_chan ||
-			    CR_RANGE(chanspec) >= range_len ||
-			    aref_invalid(s, chanspec)) {
-				dev_warn(dev->class_dev,
-					 "bad chanlist[%d]=0x%08x chan=%d range length=%d\n",
-					 i, chanspec, chan, range_len);
-				return -EINVAL;
-			}
-		}
-	} else {
+	if (!s->range_table && !s->range_table_list) {
 		dev_err(dev->class_dev, "(bug) no range type list!\n");
 		return -EINVAL;
 	}
+	for (i = 0; i < n; i++) {
+		chanspec = chanlist[i];
+		chan = CR_CHAN(chanspec);
+		if (s->range_table)
+			range_len = s->range_table->length;
+		else if (s->range_table_list && chan < s->n_chan)
+			range_len = s->range_table_list[chan]->length;
+		else
+			range_len = 0;
+		if (chan >= s->n_chan ||
+		    CR_RANGE(chanspec) >= range_len ||
+		    aref_invalid(s, chanspec)) {
+			dev_warn(dev->class_dev,
+				 "bad chanlist[%d]=0x%08x chan=%d range length=%d\n",
+				 i, chanspec, chan, range_len);
+			return -EINVAL;
+		}
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(comedi_check_chanlist);
-- 
1.8.5.3

