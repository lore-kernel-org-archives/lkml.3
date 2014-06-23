Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaFWBMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:12:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30174 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaFWBMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:12:52 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-9c-53a77f12227e
From: Yongtaek Lee <ytk.lee@samsung.com>
To: rydberg@euromail.se, dmitry.torokhov@gmail.com, daniels@collabora.com,
        rientjes@google.com, dh.herrmann@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yongtaek Lee <ytk.lee@samsung.com>
Subject: [PATCH] Input: evdev - Fix incorrect kfree of err_free_client after
 vzalloc
Date: Mon, 23 Jun 2014 10:12:19 +0900
Message-id: <1403485939-2166-1-git-send-email-ytk.lee@samsung.com>
X-Mailer: git-send-email 1.7.1
In-reply-to: <CANq1E4T3v9DPnj8z7B3Qj0NT98M648r+KDWT7Os4SpbCjNxQ8A@mail.gmail.com>
References: <CANq1E4T3v9DPnj8z7B3Qj0NT98M648r+KDWT7Os4SpbCjNxQ8A@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zbV2h+uXBBovb+C029W9lt5jXepTF
	4vCiF4wWNz99Y7W4vGsOm0Xbko1MFlOmz2S0eLye24HDY8fdJYweBybfZPPYOesuu8eCTaUe
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlXHk9mHGglscFW0TpRoYp7N3MXJySAiYSGw4ugLK
	FpO4cG89WxcjF4eQwDJGiS2rG1hhiqbO/s0OkZjOKHF0dyeU84dRYlVzM1gVm4CGxM7OpSwg
	tohAucSsd3vAxjILJEus7/nLBGILC4RJHJ0/gQ3EZhFQlbi2/R8jiM0r4CRxfUo/M8Q2OYkd
	q5+A1XMKBEssaG0As4UEAiTuf30BtlhCYBG7xOrJd6EGCUh8m3wIaDEHUEJWYtMBqDmSEgdX
	3GCZwCi8gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZI2PfuYLx9wPoQYzLQuInMUqLJ
	+cC4ySuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTmAU
	hO2Qeh3/VeZ8/txbi9bX8Ml+2/y9zOE66zSHb36/RbM5Pfi2i3bJvLzT4vP1+0zJoKCnomu3
	fp7n8fxJacm2lX1BggkFtw4qFx5PNqmcn9OX9KrjzdtPzOk8rdutPBbMX8f5tyV6kvEpFiHP
	+eFLds2TvqhYO7usOyL0REGm4V3BcJtuhuuqSizFGYmGWsxFxYkAFjhAyZECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jQV2h+uXBBg8WcFts6t/KbjGv9SiL
	xeFFLxgtbn76xmpxedccNou2JRuZLKZMn8lo8Xg9twOHx467Sxg9Dky+yeaxc9Zddo8Fm0o9
	+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGkduHGQtu
	cVS0TZRqYJzO3sXIySEhYCIxdfZvKFtM4sK99WxdjFwcQgLTGSWO7u5kh3D+MEqsam5mBali
	E9CQ2Nm5lAXEFhEol5j1bg9YN7NAssT6nr9MILawQJjE0fkT2EBsFgFViWvb/zGC2LwCThLX
	p/QzQ2yTk9ix+glYPadAsMSC1gYwW0ggQOL+1xfsExh5FzAyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIjqpnUjsYVzZYHGIU4GBU4uHVcFseLMSaWFZcmXuIUYKDWUmE94QPUIg3JbGy
	KrUoP76oNCe1+BCjKdBVE5mlRJPzgRGfVxJvaGxiZmRpZGZsYm5srCTOe6DVOlBIID2xJDU7
	NbUgtQimj4mDExhyfjZO1m2Mj6JPcej+EWUQ9Z2+eUsNo+3ewGSzPdVz4t139G/R2rzIZetf
	5VWNjldenFBYcWrDzZkz3bQV67ad0LHu2sQlbvhkj/qH3Y9Cej3uds7IF2tLdrXJUWDWy9ln
	YDdH1vJc66bpjktLt80JkpBxtPtkXJzG2l8XWHXoCruD3VQHX2UlluKMREMt5qLiRADvSZzk
	wAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced by commit 92eb77d ("Input: evdev - fall back
to vmalloc for client event buffer").

vzalloc is used to alloc memory as fallback in case of failure
of kzalloc. But err_free_client was not considered on below case.
1. kzalloc fail
2. vzalloc success
3. evdev_open_device fail
4. kfree

So that address checking is needed to call correct free function.

Signed-off-by: Yongtaek Lee <ytk.lee@samsung.com>
Reviewed-by: Daniel Stone <daniels@collabora.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 drivers/input/evdev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index ce953d8..f60daa0 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -422,7 +422,10 @@ static int evdev_open(struct inode *inode, struct file *file)
 
  err_free_client:
 	evdev_detach_client(evdev, client);
-	kfree(client);
+	if (is_vmalloc_addr(client))
+		vfree(client);
+	else
+		kfree(client);
 	return error;
 }
 
-- 
1.7.1

