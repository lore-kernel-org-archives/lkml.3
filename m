Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaHYIXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:23:11 -0400
Received: from ozlabs.org ([103.22.144.67]:40519 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbaHYIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:23:09 -0400
Date: Mon, 25 Aug 2014 18:23:07 +1000
From: Anton Blanchard <anton@samba.org>
To: sukadev@linux.vnet.ibm.com, mpe@ellerman.id.au, acme@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf powerpc: Skip callchain code must include
 util/debug.h
Message-ID: <20140825182307.49774a04@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a compile error, the prototype for pr_debug could not be found.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
===================================================================
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -15,6 +15,7 @@
 
 #include "util/thread.h"
 #include "util/callchain.h"
+#include "util/debug.h"
 
 /*
  * When saving the callchain on Power, the kernel conservatively saves
