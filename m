Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaLNUZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:25:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaLNUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.17 23/47] media: smiapp: Only some selection targets are settable
Date: Sun, 14 Dec 2014 12:20:58 -0800
Message-Id: <20141214201819.352703395@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@iki.fi>

commit b31eb901c4e5eeef4c83c43dfbc7fe0d4348cb21 upstream.

Setting a non-settable selection target caused BUG() to be called. The check
for valid selections only takes the selection target into account, but does
not tell whether it may be set, or only get. Fix the issue by simply
returning an error to the user.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2133,7 +2133,7 @@ static int smiapp_set_selection(struct v
 		ret = smiapp_set_compose(subdev, fh, sel);
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 	}
 
 	mutex_unlock(&sensor->mutex);


