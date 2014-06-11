Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaFKNXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:23:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:48925 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaFKNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:23:33 -0400
Date: Wed, 11 Jun 2014 09:23:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>, tim.bird@sonymobile.com,
        gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: [PATCH] arm/ftrace: Fix function_return_addr() to
 function_return_address()
Message-ID: <20140611092330.7930eff2@gandalf.local.home>
In-Reply-To: <CAMuHMdWs9i4pBNbn-RTpv_-K5W7YGED=KtEtFSci=7YHdNKpfw@mail.gmail.com>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
	<CAMuHMdWs9i4pBNbn-RTpv_-K5W7YGED=KtEtFSci=7YHdNKpfw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clean up of CALLER_ADDR*() functions required the archs to either
use the default __builtin_return_address(X) (where X > 0) or override
it with something the arch can use. To override it, the arch would
define function_return_address(x).

The arm architecture requires this to be redefined but instead of
defining function_return_address(x) it defined function_return_addr(x).

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
----
diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index eb577f4..39eb16b 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -52,7 +52,7 @@ extern inline void *return_address(unsigned int level)
 
 #endif
 
-#define ftrace_return_addr(n) return_address(n)
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* ifndef __ASSEMBLY__ */
 
