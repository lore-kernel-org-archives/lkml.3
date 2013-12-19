Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3LSPGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:06:54 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41602 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3LSPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:19 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 28/38] superhyway: intc: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:39 +0100
Message-Id: <1387465429-3568-29-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/sh/intc/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 8f32a13..c89768e 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -504,8 +504,10 @@ static int __init register_intc_devs(void)
 			if (error == 0)
 				error = device_create_file(&d->dev,
 							   &dev_attr_name);
-			if (error)
+			if (error) {
+				put_device(&d->dev);
 				break;
+			}
 		}
 	}
 
-- 
1.8.3.1

