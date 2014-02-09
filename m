Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaBIQsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:48:23 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47139 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBIQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:48:22 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Michal Sekletar <msekleta@redhat.com>, Xi Wang <xi.wang@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chen Gang <gang.chen@asianux.com>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2005/13=5D=20net=3A=20Add=20prototype=20declaration=20to=20header=20file=20include/linux/filter=2Eh?=
Date: Sun,  9 Feb 2014 22:18:10 +0530
Message-Id: <16adc61b46636c04c585ab5bede1334d02b44c85.1391955924.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration to header file include/linux/filter.h
because it is used by more than one file.

This eliminates the following warning in core/filter.c:
net/core/filter.c:48:7: warning: no previous prototype for ‘bpf_internal_load_pointer_neg_helper’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

Changes since v1:
Incorrect Fix

 include/linux/filter.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index e568c8e..0d21259 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -53,6 +53,8 @@ extern int sk_chk_filter(struct sock_filter *filter, unsigned int flen);
 extern int sk_get_filter(struct sock *sk, struct sock_filter __user *filter, unsigned len);
 extern void sk_decode_filter(struct sock_filter *filt, struct sock_filter *to);
 
+void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size);
+
 #ifdef CONFIG_BPF_JIT
 #include <stdarg.h>
 #include <linux/linkage.h>
-- 
1.7.9.5

