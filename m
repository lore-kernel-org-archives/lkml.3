Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3I3JmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:42:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33021 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3I3JmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:42:04 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-4e-5249476ab4b3
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, mina86@mina86.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] USB: gadget: f_fs: fix error handling
Date: Mon, 30 Sep 2013 11:41:41 +0200
Message-id: <1380534101-23956-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoG6Wu2eQwcapShazXrazWGycsZ7V
	4uD9eovmxevZLC7vmsNmsWhZK7PF2iN32S0WHG9htXhweCe7A6fH/rlr2D3W/XnF5NG3ZRWj
	x/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4MqY33iRpeAUR8WBfUuZGxi/snUxcnJICJhIXFj2
	hxHCFpO4cG89UJyLQ0hgOqPEvl0XmSCcdiaJb9vnMIFUsQnoSGz5PgGsQ0RAQGL9i0vsIEXM
	Ao8ZJd6eescCkhAWsJS4MGsjM4jNIqAqMaN7OlgDr4CrxNlpr4DiHEDrFCTmTLKZwMi9gJFh
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw4DyT3sG4qsHiEKMAB6MSD6/FUo8gIdbEsuLK
	3EOMEhzMSiK8X/k8g4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJ
	MnFwSjUwejx5XSASlH/GbO7POxe4SpdtiBBI9TnOz/tFRdJqj4ggQ7n17C4GztusLzYkvJxX
	5ba/929wE+9CRuH5SjHl+qYq7w5ZiXSJbfK/+nUSY41TBePX5guN10KYSy6sbntdH9CwT0yN
	VTd72+X7X9quvar1OOagK+o4pyqd5V7+W9ZpXr3L4ryVWIozEg21mIuKEwHTRVIJGAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is update for my patch fixing error handling in functionfs module.
I have fixed typos from previous version, and changed description for greater
clearity as Sergei Shtylyov suggested.

This patch add missing error check in ffs_func_bind() function, after
ffs_do_descs() function call for high speed descriptors. Without this check
it's possible that the module will try to dereference incorrect pointer.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Changelog:

v2:
- fix typos
- expand patch desctiprion

v1: https://lkml.org/lkml/2013/9/27/128
---
 drivers/usb/gadget/f_fs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 1a66c5b..0da66ba 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -2264,6 +2264,8 @@ static int ffs_func_bind(struct usb_configuration *c,
 				   data->raw_descs + ret,
 				   (sizeof data->raw_descs) - ret,
 				   __ffs_func_bind_do_descs, func);
+		if (unlikely(ret < 0))
+			goto error;
 	}
 
 	/*
-- 
1.7.9.5

