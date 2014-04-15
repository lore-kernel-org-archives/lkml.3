Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaDOSYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:24:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47956 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaDOSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:24:16 -0400
Date: Tue, 15 Apr 2014 14:24:12 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: Replace __get_cpu_var with this_cpu_ptr
Message-ID: <20140415182412.GH30990@htj.dyndns.org>
References: <alpine.DEB.2.10.1404151238340.27545@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404151238340.27545@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to percpu/for-3.16 with patch description updated.

Thanks.

--------- 8< ---------
>From fdb9c293decf7e06795f7d9ae409df907c7ae1b6 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <cl@linux.com>
Date: Tue, 15 Apr 2014 12:39:14 -0500

__this_cpu_ptr is being phased out.  Use raw_cpu_ptr instead which was
introduced in 3.15-rc1.  One case of using __get_cpu_var in the
get_cpu_var macro for address calculation was remaining in
include/linux/percpu.h.

tj: Updated patch description.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e7a0b95..539b3ca 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -29,7 +29,7 @@
  */
 #define get_cpu_var(var) (*({				\
 	preempt_disable();				\
-	&__get_cpu_var(var); }))
+	this_cpu_ptr(&var); }))
 
 /*
  * The weird & is necessary because sparse considers (void)(var) to be
-- 
1.9.0

