Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3IZH4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:56:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab3IZH4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:56:38 -0400
X-IronPort-AV: E=Sophos;i="4.90,983,1371052800"; 
   d="scan'208";a="8627541"
Message-ID: <5243E86D.6090802@cn.fujitsu.com>
Date: Thu, 26 Sep 2013 15:55:25 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: balbi@ti.com, gregkh@linuxfoundation.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/26 15:54:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/26 15:54:52,
	Serialize complete at 2013/09/26 15:54:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/usb/gadget/configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 8f0d614..1bfacbf 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -557,7 +557,7 @@ static struct config_group *function_make(
 
 	fi = usb_get_function_instance(func_name);
 	if (IS_ERR(fi))
-		return ERR_PTR(PTR_ERR(fi));
+		return ERR_CAST(fi);
 
 	ret = config_item_set_name(&fi->group.cg_item, name);
 	if (ret) {
-- 
1.8.3.1
