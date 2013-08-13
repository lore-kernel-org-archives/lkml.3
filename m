Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab3HMVap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:30:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320Ab3HMVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:30:40 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=mJpPKtiIRDsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AAnaCIy5bMAA:10 a=TbT2I7Sl6OSbTtfK72QA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813213039.061000633@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 17:02:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] [PATCH 2/3] module: Add NOARG flag for ops with
 param_set_bool_enable_only() set function
References: <20130813210228.989279359@goodmis.org>
Content-Disposition: inline; filename=0002-module-Add-NOARG-flag-for-ops-with-param_set_bool_en.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ops that uses param_set_bool_enable_only() as its set function can
easily handle being used without an argument. There's no reason to
fail the loading of the module if it does not have one.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/module.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/module.c b/kernel/module.c
index 2069158..4eb26b6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -136,6 +136,7 @@ static int param_set_bool_enable_only(const char *val,
 }
 
 static const struct kernel_param_ops param_ops_bool_enable_only = {
+	.flags = KERNEL_PARAM_FL_NOARG,
 	.set = param_set_bool_enable_only,
 	.get = param_get_bool,
 };
-- 
1.7.10.4


