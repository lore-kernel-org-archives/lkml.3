Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaBNUUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:20:21 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:57735 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbaBNUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:20:16 -0500
Message-Id: <20140214201907.228035121@linux.com>
Date: Fri, 14 Feb 2014 14:19:12 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 31/48] uv: Replace __get_cpu_var
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=more_fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __this_cpu_read instead.

Cc: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
@@ -618,7 +618,7 @@
 };
 
 DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
-#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
+#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
 #define uv_hub_nmi			(uv_cpu_nmi.hub)
 #define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
 #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)

