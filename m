Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaEMT6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:58:08 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:65396 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaEMT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:57:58 -0400
Date: Tue, 13 May 2014 12:57:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "David S. Miller" <davem@davemloft.net>
cc: Alexei Starovoitov <ast@plumgrid.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] net, filter: make new test_bpf depend on networking
Message-ID: <alpine.DEB.2.02.1405131255380.3392@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_TEST_BPF depends on CONFIG_NET, otherwise the build fails:

ERROR: "sk_unattached_filter_destroy" [lib/test_bpf.ko] undefined!
ERROR: "kfree_skb" [lib/test_bpf.ko] undefined!
ERROR: "sk_unattached_filter_create" [lib/test_bpf.ko] undefined!
ERROR: "sk_run_filter_int_skb" [lib/test_bpf.ko] undefined!
ERROR: "__alloc_skb" [lib/test_bpf.ko] undefined!

Add the dependency.

Cc: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1639,6 +1639,7 @@ config TEST_USER_COPY
 config TEST_BPF
 	tristate "Test BPF filter functionality"
 	default n
+	depends on NET
 	depends on m
 	help
 	  This builds the "test_bpf" module that runs various test vectors
