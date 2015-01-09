Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbbAIOb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:31:26 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:60879 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbbAIObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:31:25 -0500
From: "George G. Davis" <ggdavisiv@gmail.com>
X-Google-Original-From: "George G. Davis" <george_davis@mentor.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "George G. Davis" <george_davis@mentor.com>
Subject: [PATCH] drivers: of: Export of_reserved_mem_device_{init,release}
Date: Fri,  9 Jan 2015 09:29:05 -0500
Message-Id: <1420813745-130341-1-git-send-email-george_davis@mentor.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export of_reserved_mem_device_{init,release} so that modules
can initialize and release their assigned per-device cma_area.

Signed-off-by: George G. Davis <george_davis@mentor.com>
---
 drivers/of/of_reserved_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index dc566b3..5eeb5b2 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -265,6 +265,7 @@ int of_reserved_mem_device_init(struct device *dev)
 
 	return ret;
 }
+EXPORT_SYMBOL(of_reserved_mem_device_init);
 
 /**
  * of_reserved_mem_device_release() - release reserved memory device structures
@@ -289,3 +290,4 @@ void of_reserved_mem_device_release(struct device *dev)
 
 	rmem->ops->device_release(rmem, dev);
 }
+EXPORT_SYMBOL(of_reserved_mem_device_release);
-- 
1.9.3

