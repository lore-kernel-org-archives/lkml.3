Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaIKIUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:20:08 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:14222 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbaIKIUC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:20:02 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'broonie@kernel.org'" <broonie@kernel.org>,
        "'linux-driver@qlogic.com'" <linux-driver@qlogic.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>
Date: Thu, 11 Sep 2014 16:19:49 +0800
Subject: [PATCH] regmap:change struct regmap's internal locks as union
Thread-Topic: [PATCH] regmap:change struct regmap's internal locks as union
Thread-Index: Ac/NmSfIko22QWRERAaJ/i5dugB5tw==
Message-ID: <35FD53F367049845BC99AC72306C23D103CDBFBFB01A@CNBJMBX05.corpusers.net>
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

this patch change struct regmap->mutex and struct regmap->spinlock
as an union, because these 2 members are only used one of them,
we change it to shrink the struct size.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 drivers/base/regmap/internal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index bfc90b8..0da5865 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -49,8 +49,10 @@ struct regmap_async {
 };
 
 struct regmap {
-	struct mutex mutex;
-	spinlock_t spinlock;
+	union {
+		struct mutex mutex;
+		spinlock_t spinlock;
+	};
 	unsigned long spinlock_flags;
 	regmap_lock lock;
 	regmap_unlock unlock;
-- 
2.1.0

