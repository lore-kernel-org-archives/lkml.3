Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaLOIF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:05:56 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:11806 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbaLOIFz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:05:55 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'broonie@kernel.org'" <broonie@kernel.org>,
        "'linux-driver@qlogic.com'" <linux-driver@qlogic.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>
Date: Mon, 15 Dec 2014 16:05:50 +0800
Subject: [PATCH] regmap:change spinlock_flags into the union
Thread-Topic: [PATCH] regmap:change spinlock_flags into the union
Thread-Index: Ac/NmSfIko22QWRERAaJ/i5dugB5txKpFsuQ
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E148@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB01A@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103CDBFBFB01A@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch move struct regmap.spinlock_flags into the union of
spinlock, so that we can shrink struct regmap size.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 drivers/base/regmap/internal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 0da5865..8e94584 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -51,9 +51,11 @@ struct regmap_async {
 struct regmap {
 	union {
 		struct mutex mutex;
-		spinlock_t spinlock;
+		struct {
+			spinlock_t spinlock;
+			unsigned long spinlock_flags;
+		};
 	};
-	unsigned long spinlock_flags;
 	regmap_lock lock;
 	regmap_unlock unlock;
 	void *lock_arg; /* This is passed to lock/unlock functions */
-- 
2.1.3
