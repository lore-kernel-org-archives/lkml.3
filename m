Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBRVrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:47:00 -0500
Received: from mailout.micron.com ([137.201.242.129]:45133 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaBRVq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:46:57 -0500
Message-ID: <5303D4CB.8070804@micron.com>
Date: Tue, 18 Feb 2014 13:46:51 -0800
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Thunderbird/27.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: Reduce the number of unaligned writes to 2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20512.000
X-TM-AS-Result: No-8.417800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please include this for 3.14. It is a trivial change, hope it should be ok.

--
Regards,
Asai


After several experiments, deduced the the optimal number of unaligned
writes to be 2. Changing the value accordingly.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.h
b/drivers/block/mtip32xx/mtip32xx.h
index b52e9a6..54174cb 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -53,7 +53,7 @@
 #define MTIP_FTL_REBUILD_TIMEOUT_MS    2400000

 /* unaligned IO handling */
-#define MTIP_MAX_UNALIGNED_SLOTS       8
+#define MTIP_MAX_UNALIGNED_SLOTS       2

 /* Macro to extract the tag bit number from a tag value. */
 #define MTIP_TAG_BIT(tag)      (tag & 0x1F)
--
1.7.1
