Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab3HMVan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:30:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321Ab3HMVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:30:40 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=j7RoTwKqi2oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=E0X6KhVPGBYA:10 a=DfNHnWVPAAAA:8 a=T5q-qxLmAozlUR78wNkA:9 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813213039.196836151@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 17:02:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 3/3] [PATCH 3/3] module/lsm: Have apparmor module parameters work with no
 args
References: <20130813210228.989279359@goodmis.org>
Content-Disposition: inline; filename=0003-module-lsm-Have-apparmor-module-parameters-work-with.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The apparmor module parameters for param_ops_aabool and
param_ops_aalockpolicy are both based off of the param_ops_bool,
and can handle a NULL value passed in as val. Have it enable the
new KERNEL_PARAM_FL_NOARGS flag to allow the parameters to be set
without having to state "=y" or "=1".

Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 security/apparmor/lsm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 2e2a0dd..e3a704c 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -666,6 +666,7 @@ static int param_set_aabool(const char *val, const struct kernel_param *kp);
 static int param_get_aabool(char *buffer, const struct kernel_param *kp);
 #define param_check_aabool param_check_bool
 static struct kernel_param_ops param_ops_aabool = {
+	.flags = KERNEL_PARAM_FL_NOARG,
 	.set = param_set_aabool,
 	.get = param_get_aabool
 };
@@ -682,6 +683,7 @@ static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp
 static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
 #define param_check_aalockpolicy param_check_bool
 static struct kernel_param_ops param_ops_aalockpolicy = {
+	.flags = KERNEL_PARAM_FL_NOARG,
 	.set = param_set_aalockpolicy,
 	.get = param_get_aalockpolicy
 };
-- 
1.7.10.4


