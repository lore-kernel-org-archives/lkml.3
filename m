Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965882AbaLLGpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:45:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758886AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Cristina Ciocan" <cristina.ciocan@intel.com>,
        "Jonathan Cameron" <jic23@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.474998945@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 129/164] iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cristina Ciocan <cristina.ciocan@intel.com>

commit ccf54555da9a5e91e454b909ca6a5303c7d6b910 upstream.

The direction field is set on 7 bits, thus we need to AND it with 0111 111 mask
in order to retrieve it, that is 0x7F, not 0xCF as it is now.

Fixes: ade7ef7ba (staging:iio: Differential channel handling)
Signed-off-by: Cristina Ciocan <cristina.ciocan@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/sysfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/sysfs.h
+++ b/drivers/staging/iio/sysfs.h
@@ -147,7 +147,7 @@ enum iio_event_direction {
 
 #define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
 
-#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0xCF)
+#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
 
 #define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
 

