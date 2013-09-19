Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3ISTIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:08:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52662 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018Ab3ISTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:08:38 -0400
Date: Thu, 19 Sep 2013 15:08:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: lttng-dev@lists.lttng.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [lttng-modules commit] LTTng trace-clock: shrink kernel blacklist
Message-ID: <20130919190834.GA1478@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9998f5216f4641a79e158135c4c1658dcc6cd2d8
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Thu Sep 19 13:59:48 2013 -0500

    LTTng trace-clock: shrink kernel blacklist
    
    The lockup fix has been pulled into Linux master as:
    
    commit 7bd36014460f793c19e7d6c94dab67b0afcfcb7f
    Author: John Stultz <john.stultz@linaro.org>
    Date:   Wed Sep 11 16:50:56 2013 -0700
    
        timekeeping: Fix HRTICK related deadlock from ntp lock changes
    
    Guessing the stable kernel versions in which this fix will appear in
    3.10 and 3.11 stable. 3.12+ are OK.
    
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: John Stultz <john.stultz@linaro.org>

diff --git a/wrapper/trace-clock.h b/wrapper/trace-clock.h
index 4266f25..d31141d 100644
--- a/wrapper/trace-clock.h
+++ b/wrapper/trace-clock.h
@@ -33,10 +33,11 @@
 #include <linux/time.h>
 #include <linux/hrtimer.h>
 #include <linux/version.h>
+#include "../lttng-kernel-version.h"
 #include "random.h"
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0))
-#error "Linux kernels 3.10 and 3.11 introduce a deadlock in the timekeeping subsystem. See http://lkml.kernel.org/r/1378943457-27314-1-git-send-email-john.stultz@linaro.org for details. Awaiting patch merge into Linux master, stable-3.10 and stable-3.11 for fine-grained kernel version blacklisting."
+#if LTTNG_KERNEL_RANGE(3,10,0, 3,10,13) || LTTNG_KERNEL_RANGE(3,11,0, 3,11,2)
+#error "Linux kernels 3.10 and 3.11 introduce a deadlock in the timekeeping subsystem. Fixed by commit 7bd36014460f793c19e7d6c94dab67b0afcfcb7f \"timekeeping: Fix HRTICK related deadlock from ntp lock changes\" in Linux."
 #endif
 
 static inline u64 trace_clock_monotonic_wrapper(void)

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
