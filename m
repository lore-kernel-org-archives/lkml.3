Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaHMPEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaHMPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:04:09 -0400
Date: Wed, 13 Aug 2014 11:03:57 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: lib: turn CONFIG_STACKTRACE into an actual option.
Message-ID: <20140813150357.GA12025@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
	Andrew Morton <akpm@linux-foundation.org>
References: <20140714192416.GA30293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714192416.GA30293@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was puzzled why /proc/$$/stack had disappeared, until I figured out
I had disabled the last debug option that did a 'select STACKTRACE'.
This patch makes the option show up at config time, so it can be
enabled without enabling any of the more heavyweight debug options.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa3545b..96c64beac12a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1008,8 +1008,13 @@ config TRACE_IRQFLAGS
 	  either tracing or lock debugging.
 
 config STACKTRACE
-	bool
+	bool "Stack backtrace support"
 	depends on STACKTRACE_SUPPORT
+	help
+	  This option causes the kernel to create a /proc/pid/stack for
+	  every process, showing its current stack trace.
+	  It is also used by various kernel debugging features that require
+	  stack trace generation.
 
 config DEBUG_KOBJECT
 	bool "kobject debugging"

