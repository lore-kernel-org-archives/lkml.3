Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaEJKuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:50:06 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:11027 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbaEJKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:50:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkWAAQDblNXQCSg/2dsb2JhbABZgwaCQXypFwoFAZoVAgKBFxd0glMTHCMYgQIkE4hFAdFNhVaIGGSERwEDjyWKIgGTB4M4O4Ew
Date: Sat, 10 May 2014 12:49:58 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1 RESEND] drivers/scsi/sd.c: remove positive test on
 unsigned value
Message-Id: <20140510124958.b231a1d64d12ecdf97aff393@skynet.be>
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

