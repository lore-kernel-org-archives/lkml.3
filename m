Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaLJHJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:09:44 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48593 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaLJHJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:09:43 -0500
Date: Tue, 9 Dec 2014 23:09:17 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michaele@au1.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, dev@codyps.com
Subject: [PATCH 2/2] perf/power/hv-24x7: Use kmem_cache_free() instead of
 kfree
Message-ID: <20141210070917.GB27377@us.ibm.com>
References: <20141210070637.GA27377@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210070637.GA27377@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121007-0025-0000-0000-000006CB7418
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 982bf5a660ae33fbe2f9187187caa6752c66783d Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 10 Dec 2014 01:43:34 -0500
Subject: [PATCH 2/2] power/perf: hv-24x7: Use kmem_cache_free() instead of
 kfree

Use kmem_cache_free() to free a buffer allocated with kmem_cache_alloc().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

p#	set2.log
---
 arch/powerpc/perf/hv-24x7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 18e1f49..a2c6211 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -177,7 +177,7 @@ static ssize_t _name##_show(struct device *dev,			\
 	}							\
 	ret = sprintf(buf, _fmt, _expr);			\
 e_free:								\
-	kfree(page);						\
+	kmem_cache_free(hv_page_cache, page);			\
 	return ret;						\
 }								\
 static DEVICE_ATTR_RO(_name)
-- 
1.8.3.1

