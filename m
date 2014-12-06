Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaLFPNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:13:54 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47746 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752327AbaLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cristina Ciocan <cristina.ciocan@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 32/66] iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask
Date: Sat,  6 Dec 2014 16:07:24 +0100
Message-Id: <7abd18f7bad812dbab0bca2492d55a9800dcd479.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cristina Ciocan <cristina.ciocan@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ccf54555da9a5e91e454b909ca6a5303c7d6b910 upstream.

The direction field is set on 7 bits, thus we need to AND it with 0111 111 mask
in order to retrieve it, that is 0x7F, not 0xCF as it is now.

Fixes: ade7ef7ba (staging:iio: Differential channel handling)
Signed-off-by: Cristina Ciocan <cristina.ciocan@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/iio/events.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iio/events.h b/include/linux/iio/events.h
index 13ce220c7003..593ae7ce07c7 100644
--- a/include/linux/iio/events.h
+++ b/include/linux/iio/events.h
@@ -90,7 +90,7 @@ enum iio_event_direction {
 
 #define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
 
-#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0xCF)
+#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
 
 #define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
 
-- 
2.1.3

