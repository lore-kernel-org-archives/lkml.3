Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3J1DBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:01:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:20705 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3J1DBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:01:43 -0400
X-Spam-Score: -100.8
Message-ID: <526DD356.5020101@asianux.com>
Date: Mon, 28 Oct 2013 11:00:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Richard Kuo <rkuo@codeaurora.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: export symbol for save_stack_trace() in stacktrace.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need export its symbol just like other architectures done, or can not
pass compiling with allmodconfig, the related error:

    MODPOST 2994 modules
  ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
  ERROR: "save_stack_trace" [drivers/md/persistent-data/dm-persistent-data.ko] undefined!


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/kernel/stacktrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index f8b7d88..607c6e4 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -244,4 +244,5 @@ void save_stack_trace(struct stack_trace *trace)
 {
 	arc_unwind_core(current, NULL, __collect_all, trace);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
-- 
1.7.7.6
