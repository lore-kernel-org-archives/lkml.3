Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaADNUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 08:20:44 -0500
Received: from smtp03.stone-is.org ([87.238.162.66]:36967 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaADNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 08:20:42 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52C80AA4.7070008@acm.org>
Date: Sat, 04 Jan 2014 14:20:36 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <greg@kroah.com>
CC: Ming Lei <ming.lei@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] firmware loader: Add sparse annotation
References: <52C80A50.3000602@acm.org>
In-Reply-To: <52C80A50.3000602@acm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid that sparse reports the following warning on __fw_free_buf():

drivers/base/firmware_class.c:230:9: warning: context imbalance in '__fw_free_buf' - unexpected unlock

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index eb8fb94..c2e4540 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -219,6 +219,7 @@ static int fw_lookup_and_allocate_buf(const char *fw_name,
 }
 
 static void __fw_free_buf(struct kref *ref)
+	__releases(&fwc->lock)
 {
 	struct firmware_buf *buf = to_fwbuf(ref);
 	struct firmware_cache *fwc = buf->fwc;
-- 
1.8.1.4

