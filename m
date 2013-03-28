Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3C1F7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:59:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:11599 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3C1F7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:59:48 -0400
X-Spam-Score: -100.8
Message-ID: <5153DC24.4010104@asianux.com>
Date: Thu, 28 Mar 2013 13:59:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: edumazet@google.com, dborkman@redhat.com, wad@chromium.org,
        eparis@redhat.com
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux: printk is needed in filter.h when CONFIG_BPF_JIT
 is defined
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for make V=1 EXTRA_CFLAGS=-W ARCH=arm allmodconfig
    printk is need when CONFIG_BPF_JIT is defined
    or it will report pr_err and print_hex_dump are implicit declaration

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/filter.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index d7d2508..d1248f4 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -48,6 +48,9 @@ extern int sk_chk_filter(struct sock_filter *filter, unsigned int flen);
 extern int sk_get_filter(struct sock *sk, struct sock_filter __user *filter, unsigned len);
 
 #ifdef CONFIG_BPF_JIT
+#include <linux/linkage.h>
+#include <linux/printk.h>
+
 extern void bpf_jit_compile(struct sk_filter *fp);
 extern void bpf_jit_free(struct sk_filter *fp);
 
-- 
1.7.7.6
