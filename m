Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3JXJ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36715 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JXJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:15 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 01/11] Export __smp_call_function_single()
Date: Thu, 24 Oct 2013 10:25:54 +0100
Message-Id: <1382606764-8309-2-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk-mq core and the blk-mq null driver uses it.

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571..9de461e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -340,6 +340,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
 	}
 	put_cpu();
 }
+EXPORT_SYMBOL(__smp_call_function_single);
 
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
-- 
1.8.1.2

