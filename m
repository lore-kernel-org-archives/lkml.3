Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaJIVYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:24:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59474 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699AbaJIVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Pointner <johannes.pointner@br-automation.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 069/163] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
Date: Thu,  9 Oct 2014 14:01:34 -0700
Message-Id: <1412888588-26755-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Pointner <johannes.pointner@gmail.com>

commit 872687f626e033b4ddfaec1e410057cfc6636d77 upstream.

Fixes: a2c12493ed7e ('iio: of_iio_channel_get_by_name() returns non-null pointers for error legs')

which improperly assumes that of_iio_channel_get_by_name must always
return NULL and thus now hides -EPROBE_DEFER.

Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 1e8e94d..4fc88e6 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -178,7 +178,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 			index = of_property_match_string(np, "io-channel-names",
 							 name);
 		chan = of_iio_channel_get(np, index);
-		if (!IS_ERR(chan))
+		if (!IS_ERR(chan) || PTR_ERR(chan) == -EPROBE_DEFER)
 			break;
 		else if (name && index >= 0) {
 			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
-- 
1.9.1

