Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaDYULX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:11:23 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:33095 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbaDYULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:11:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIWANzAWlNXQASl/2dsb2JhbABZgwaCQKkSmXACAoETF3SCUxMcIxiBAiQTiEUBykKFWogbZIRAAQOOdooOAZJcgzM7gSw
Date: Fri, 25 Apr 2014 22:13:22 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/scsi/sd.c: remove positive test on unsigned
 value
Message-Id: <20140425221322.4ee6e11dac3be4d42f27fc88@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

val is unsigned.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..b54d4f8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -296,7 +296,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
-	if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
+	if (val <= SD_DIF_TYPE3_PROTECTION)
 		sdkp->protection_type = val;
 
 	return count;
-- 
1.8.4.5

