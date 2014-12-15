Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaLOTsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:48:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaLOT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cristina Ciocan <cristina.ciocan@intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 38/96] iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask
Date: Mon, 15 Dec 2014 11:25:58 -0800
Message-Id: <1418671616-25482-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristina Ciocan <cristina.ciocan@intel.com>

commit ccf54555da9a5e91e454b909ca6a5303c7d6b910 upstream.

The direction field is set on 7 bits, thus we need to AND it with 0111 111 mask
in order to retrieve it, that is 0x7F, not 0xCF as it is now.

Fixes: ade7ef7ba (staging:iio: Differential channel handling)
Signed-off-by: Cristina Ciocan <cristina.ciocan@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/iio/events.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iio/events.h b/include/linux/iio/events.h
index 5dab2c4..c3ee817 100644
--- a/include/linux/iio/events.h
+++ b/include/linux/iio/events.h
@@ -76,7 +76,7 @@ struct iio_event_data {
 
 #define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
 
-#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0xCF)
+#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
 
 #define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
 
-- 
1.9.1

