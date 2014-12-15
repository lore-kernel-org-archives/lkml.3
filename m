Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaLOOjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:39:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaLOO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 128/168] [media] smiapp: Only some selection targets are settable
Date: Mon, 15 Dec 2014 14:26:22 +0000
Message-Id: <1418653622-21105-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@iki.fi>

commit b31eb901c4e5eeef4c83c43dfbc7fe0d4348cb21 upstream.

Setting a non-settable selection target caused BUG() to be called. The check
for valid selections only takes the selection target into account, but does
not tell whether it may be set, or only get. Fix the issue by simply
returning an error to the user.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 06fb03291d59..698219a9e538 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2138,7 +2138,7 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 		ret = smiapp_set_compose(subdev, fh, sel);
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 	}
 
 	mutex_unlock(&sensor->mutex);
-- 
2.1.3

