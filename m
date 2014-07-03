Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaGCJd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:33:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030491AbaGCJYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Kocialkowski <contact@paulk.fr>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 168/198] twl4030-madc: Request processed values in twl4030_get_madc_conversion
Date: Thu,  3 Jul 2014 10:20:11 +0100
Message-Id: <1404379241-8590-169-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <contact@paulk.fr>

commit e0326be0cded13dfc3a24cbeece1f1ae64348a0e upstream.

Not setting the raw parameter in the request causes it to be randomly
initialized to a value that might be different from zero or zero. This leads to
values that are randomly either raw or processed, making it very difficult to
make reliable use of the values.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[ luis: backported to 3.11:
  - file rename: drivers/iio/adc/twl4030-madc.c -> drivers/mfd/twl4030-madc.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/twl4030-madc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 1ea54d4d003a..10588120e294 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -614,6 +614,7 @@ int twl4030_get_madc_conversion(int channel_no)
 	req.channels = (1 << channel_no);
 	req.method = TWL4030_MADC_SW2;
 	req.active = 0;
+	req.raw = 0;
 	req.func_cb = NULL;
 	ret = twl4030_madc_conversion(&req);
 	if (ret < 0)
-- 
1.9.1

