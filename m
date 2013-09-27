Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3I0K3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:29:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20329 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3I0K3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:29:09 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a9-52455df4f644
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        b.zolnierkie@samsung.com, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] USB: gadget: f_fs: fix error handling
Date: Fri, 27 Sep 2013 12:28:54 +0200
Message-id: <1380277734-17590-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xgO6XWNcgg6d7+CxmvWxnsdg4Yz2r
	xcH79RbNi9ezWVzeNYfNYtGyVmaLtUfuslssON7CavHg8E52B06P/XPXsHus+/OKyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJXxatpCtoLzbBV7T99kbWBcwdrFyMEhIWAi0Xva
	t4uRE8gUk7hwbz1bFyMXh5DAIkaJIxdOs0I47UwSRw+9ZAWpYhPQkdjyfQIjiC0iICCx/sUl
	dpAiZoHHjBKHH19lAUkIC5hJ7FizmR3EZhFQlZjfOZcNxOYVcJVYPPcX1GYFiTmTbCYwci9g
	ZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERw2z6R3MK5qsDjEKMDBqMTDm5HlEiTEmlhW
	XJl7iFGCg1lJhHeBp2uQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalF
	MFkmDk6pBkYOW8k9MUqnjOYHqZcqF3TdyZZeFTat1fjezqbXdXuyD9uGLt84ZaOc4cmmYytv
	73dPz4xJF7l+/lDv7tzEyyHfmvYsl7nu+v/sg+r/R6Zk7pG/sk6fM9LBZLFowtm5TdFxtZej
	vvyqfr7edsFnI49oF/3anEj3C9F7I91vMVgUpftqM1ft0lBiKc5INNRiLipOBAD5/T8HFwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add missing error check in ffs_func_bind() function, after
ffs_do_descs() funcion call for hs descriptors. Without this check it's
possible that the module will try dereference incorrect pointer.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/f_fs.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 1a66c5b..fe7d532 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -2264,7 +2264,10 @@ static int ffs_func_bind(struct usb_configuration *c,
 				   data->raw_descs + ret,
 				   (sizeof data->raw_descs) - ret,
 				   __ffs_func_bind_do_descs, func);
+		if (unlikely(ret < 0))
+			goto error;
 	}
+	
 
 	/*
 	 * Now handle interface numbers allocation and interface and
-- 
1.7.9.5

