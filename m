Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3LNNaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:30:16 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65500 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3LNNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:30:14 -0500
Date: Sat, 14 Dec 2013 19:00:06 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: hv: Mark the function hv_synic_free_cpu() as static
 in hv.c
Message-ID: <20131214133006.GA8773@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function hv_synic_free_cpu() as static in hv.c
because it is not used outside this file.

Thus, it also eliminates the following warning in hv.c:
drivers/hv/hv.c:304:6: warning: no previous prototype for ‘hv_synic_free_cpu’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/hv/hv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index f0c5e07..bcb4950 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -301,7 +301,7 @@ err:
 	return -ENOMEM;
 }
 
-void hv_synic_free_cpu(int cpu)
+static void hv_synic_free_cpu(int cpu)
 {
 	kfree(hv_context.event_dpc[cpu]);
 	if (hv_context.synic_event_page[cpu])
-- 
1.7.9.5

