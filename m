Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3APWIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:08:02 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36840 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab3APWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:08:00 -0500
Date: Wed, 16 Jan 2013 23:01:54 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] sparc: kernel/sbus.c: fix memory leakage
Message-ID: <20130116220153.GD18593@gmail.com>
References: <1358199372-11976-1-git-send-email-dinggnu@gmail.com>
 <20130116211309.GA13993@merkur.ravnborg.org>
 <20130116211725.GC18593@gmail.com>
 <20130116220018.GA14063@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116220018.GA14063@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable iommu and strbuf are not freed if it goes to error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/sparc/kernel/sbus.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
index 1271b3a..78aa26b 100644
--- a/arch/sparc/kernel/sbus.c
+++ b/arch/sparc/kernel/sbus.c
@@ -656,6 +656,8 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	return;
 
 fatal_memory_error:
+	kfree(strbuf);
+	kfree(iommu);
 	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
 }
 
-- 
1.7.10.4

