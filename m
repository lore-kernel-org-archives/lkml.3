Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbbAPXe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:34:56 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63774 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAPXdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:36 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 7/8] module: add core_param_unsafe
Date: Fri, 16 Jan 2015 15:33:16 -0800
Message-Id: <1421451197-19723-8-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similarly to module_param_unsafe(), add the helper to be used by core
code wishing to expose unsafe debugging or testing parameters that taint
the kernel when set.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 include/linux/moduleparam.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 1392370..6480dca 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -310,6 +310,15 @@ static inline void __kernel_param_unlock(void)
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
 	__module_param_call("", name, &param_ops_##type, &var, perm, -1, 0)
+
+/**
+ * core_param_unsafe - same as core_param but taints kernel
+ */
+#define core_param_unsafe(name, var, type, perm)		\
+	param_check_##type(name, &(var));				\
+	__module_param_call("", name, &param_ops_##type, &var, perm,	\
+			    -1, KERNEL_PARAM_FL_UNSAFE)
+
 #endif /* !MODULE */
 
 /**
-- 
2.2.0.rc0.207.ga3a616c

