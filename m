Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422711Ab3LTNwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:52:16 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37565 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422681Ab3LTNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:52:13 -0500
From: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
To: michael.hoefler@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rupert Muchembled <rupert@rmuch.net>, Chad Williamson <chad@dahc.us>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 1/3] silicom: fix whitespace issues in bypass.c
Date: Fri, 20 Dec 2013 14:51:11 +0100
Message-Id: <1387547475-7135-2-git-send-email-michael.hoefler@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
References: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses several problems in bypass.c found by checkpatch.
Furthermore it removes/adds some empty lines to make the code more readable.

The following problems are fixed:
 - line over 80 characters
 - space after logical operator !
 - spaces instead of tabs
 - missing empty line after local declarations
 - empty line after {

The empty line issues were not discovered by checkpatch but in my opinion these
changes make perfect sense in terms of readability.

Signed-off-by: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Signed-off-by: Christoph Kohl <christoph.kohl@t-online.de>
---
 drivers/staging/silicom/bypasslib/bypass.c | 111 ++++++++++++++++-------------
 1 file changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index dda1b2a..14721a9 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -7,11 +7,11 @@
 /* the Free Software Foundation, located in the file LICENSE.                 */
 /*                                                                            */
 /*                                                                            */
-/* bypass.c                                                                    */
+/* bypass.c                                                                   */
 /*                                                                            */
 /******************************************************************************/
 
-#if defined(CONFIG_SMP) && ! defined(__SMP__)
+#if defined(CONFIG_SMP) && !defined(__SMP__)
 #define __SMP__
 #endif
 
@@ -66,13 +66,12 @@ static int doit(int cmd, int if_index, int *data)
 	int ret = -1;
 	struct net_device *dev;
 	struct net_device *n;
-	for_each_netdev_safe(&init_net, dev, n) {
 
+	for_each_netdev_safe(&init_net, dev, n) {
 		if (dev->ifindex == if_index) {
 			ret = do_cmd(dev, &ifr, cmd, data);
 			if (ret < 0)
 				ret = -1;
-
 		}
 	}
 
@@ -82,50 +81,59 @@ static int doit(int cmd, int if_index, int *data)
 #define bp_symbol_get(fn_name) symbol_get(fn_name)
 #define bp_symbol_put(fn_name) symbol_put(fn_name)
 
-#define SET_BPLIB_INT_FN(fn_name, arg_type, arg, ret) \
-    ({ int (* fn_ex)(arg_type)=NULL; \
-    fn_ex=bp_symbol_get(fn_name##_sd); \
-       if(fn_ex) {  \
-        ret= fn_ex(arg); \
-       bp_symbol_put(fn_name##_sd); \
-       } else ret=-1; \
-    })
-
-#define  SET_BPLIB_INT_FN2(fn_name, arg_type, arg, arg_type1, arg1, ret) \
-    ({ int (* fn_ex)(arg_type,arg_type1)=NULL; \
-        fn_ex=bp_symbol_get(fn_name##_sd); \
-       if(fn_ex) {  \
-        ret= fn_ex(arg,arg1); \
-        bp_symbol_put(fn_name##_sd); \
-       } else ret=-1; \
-    })
-#define SET_BPLIB_INT_FN3(fn_name, arg_type, arg, arg_type1, arg1,arg_type2, arg2, ret) \
-    ({ int (* fn_ex)(arg_type,arg_type1, arg_type2)=NULL; \
-        fn_ex=bp_symbol_get(fn_name##_sd); \
-       if(fn_ex) {  \
-        ret= fn_ex(arg,arg1,arg2); \
-        bp_symbol_put(fn_name##_sd); \
-       } else ret=-1; \
-    })
-
-#define DO_BPLIB_GET_ARG_FN(fn_name,ioctl_val, if_index) \
-    ({    int data, ret=0; \
-            if(is_dev_sd(if_index)){ \
-            SET_BPLIB_INT_FN(fn_name, int, if_index, ret); \
-            return ret; \
-            }  \
-            return doit(ioctl_val,if_index, &data); \
-    })
-
-#define DO_BPLIB_SET_ARG_FN(fn_name,ioctl_val,if_index,arg) \
-    ({    int data, ret=0; \
-            if(is_dev_sd(if_index)){ \
-            SET_BPLIB_INT_FN2(fn_name, int, if_index, int, arg, ret); \
-            return ret; \
-            }  \
-	    data=arg; \
-            return doit(ioctl_val,if_index, &data); \
-    })
+#define SET_BPLIB_INT_FN(fn_name, arg_type, arg, ret)	\
+({	int (*fn_ex)(arg_type) = NULL;			\
+	fn_ex = bp_symbol_get(fn_name##_sd);		\
+	if (fn_ex) {					\
+		ret = fn_ex(arg);			\
+		bp_symbol_put(fn_name##_sd);		\
+	} else {					\
+		ret = -1;				\
+	}						\
+})
+
+#define  SET_BPLIB_INT_FN2(fn_name, arg_type, arg, arg_type1, arg1, ret)\
+({	int (*fn_ex)(arg_type, arg_type1) = NULL;			\
+	fn_ex = bp_symbol_get(fn_name##_sd);				\
+	if (fn_ex) {							\
+		ret = fn_ex(arg, arg1);					\
+		bp_symbol_put(fn_name##_sd);				\
+	} else {							\
+		ret = -1;						\
+	}								\
+})
+
+#define SET_BPLIB_INT_FN3(fn_name, arg_type, arg, arg_type1, arg1,	\
+			  arg_type2, arg2, ret)				\
+({	int (*fn_ex)(arg_type, arg_type1, arg_type2) = NULL;		\
+	fn_ex = bp_symbol_get(fn_name##_sd);				\
+	if (fn_ex) {							\
+		ret = fn_ex(arg, arg1, arg2);				\
+		bp_symbol_put(fn_name##_sd);				\
+	} else {							\
+		ret = -1;						\
+	}								\
+})
+
+#define DO_BPLIB_GET_ARG_FN(fn_name, ioctl_val, if_index)	\
+({	int data, ret = 0;					\
+	if (is_dev_sd(if_index)) {				\
+		SET_BPLIB_INT_FN(fn_name, int, if_index, ret);	\
+		return ret;					\
+	}							\
+	return doit(ioctl_val, if_index, &data);		\
+})
+
+#define DO_BPLIB_SET_ARG_FN(fn_name, ioctl_val, if_index, arg)	\
+({	int data, ret = 0;					\
+	if (is_dev_sd(if_index)) {				\
+		SET_BPLIB_INT_FN2(fn_name, int, if_index, int,	\
+				  arg, ret);			\
+		return ret;					\
+	}							\
+	data = arg;						\
+	return doit(ioctl_val, if_index, &data);		\
+})
 
 static int is_dev_sd(int if_index)
 {
@@ -268,6 +276,7 @@ EXPORT_SYMBOL(get_bypass_pwup);
 static int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
 {
 	int data = ms_timeout, ret = 0;
+
 	if (is_dev_sd(if_index))
 		SET_BPLIB_INT_FN3(set_bypass_wd, int, if_index, int, ms_timeout,
 				  int *, ms_timeout_set, ret);
@@ -285,6 +294,7 @@ EXPORT_SYMBOL(set_bypass_wd);
 static int get_bypass_wd(int if_index, int *ms_timeout_set)
 {
 	int *data = ms_timeout_set, ret = 0;
+
 	if (is_dev_sd(if_index))
 		SET_BPLIB_INT_FN2(get_bypass_wd, int, if_index, int *,
 				  ms_timeout_set, ret);
@@ -297,6 +307,7 @@ EXPORT_SYMBOL(get_bypass_wd);
 static int get_wd_expire_time(int if_index, int *ms_time_left)
 {
 	int *data = ms_time_left, ret = 0;
+
 	if (is_dev_sd(if_index))
 		SET_BPLIB_INT_FN2(get_wd_expire_time, int, if_index, int *,
 				  ms_time_left, ret);
@@ -476,13 +487,14 @@ EXPORT_SYMBOL(get_bp_hw_reset);
 static int get_bypass_info(int if_index, struct bp_info *bp_info)
 {
 	int ret = 0;
+
 	if (is_dev_sd(if_index)) {
 		SET_BPLIB_INT_FN2(get_bypass_info, int, if_index,
 				  struct bp_info *, bp_info, ret);
 	} else {
 		struct net_device *dev;
-
 		struct net_device *n;
+
 		for_each_netdev_safe(&init_net, dev, n) {
 			if (dev->ifindex == if_index) {
 				struct if_bypass_info *bypass_cb;
@@ -514,7 +526,6 @@ EXPORT_SYMBOL(get_bypass_info);
 
 int init_lib_module(void)
 {
-
 	printk(VERSION);
 	return 0;
 }
-- 
1.8.1.2

