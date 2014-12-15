Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaLOTlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:41:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaLOTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:31:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 69/96] [media] smiapp: Only some selection targets are settable
Date: Mon, 15 Dec 2014 11:26:29 -0800
Message-Id: <1418671616-25482-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@iki.fi>

commit b31eb901c4e5eeef4c83c43dfbc7fe0d4348cb21 upstream.

Setting a non-settable selection target caused BUG() to be called. The check
for valid selections only takes the selection target into account, but does
not tell whether it may be set, or only get. Fix the issue by simply
returning an error to the user.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index ae66d91..371ca22 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2139,7 +2139,7 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 		ret = smiapp_set_compose(subdev, fh, sel);
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 	}
 
 	mutex_unlock(&sensor->mutex);
-- 
1.9.1

