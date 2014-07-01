Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbaGATNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:13:35 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:43733 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbaGATNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:13:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsHAJgHs1NbsGsk/2dsb2JhbABagw2sYwUBbplbgQ4XdYQxLyOBGjeIRgGzBpVfF4VviExkHYQtBZpmi0WIPoNEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1] firmware: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
Date: Tue,  1 Jul 2014 21:13:30 +0200
Message-Id: <1404242010-19560-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33..bfe8086 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -718,7 +718,7 @@ out:
 static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 {
 	struct firmware_buf *buf = fw_priv->buf;
-	int pages_needed = ALIGN(min_size, PAGE_SIZE) >> PAGE_SHIFT;
+	int pages_needed = PAGE_ALIGN(min_size) >> PAGE_SHIFT;
 
 	/* If the array of pages is too small, grow it... */
 	if (buf->page_array_size < pages_needed) {
-- 
1.9.1

