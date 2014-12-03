Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaLCLq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:46:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaLCL13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pablo Neira <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/101] netfilter: xt_bpf: add mising opaque struct sk_filter definition
Date: Wed,  3 Dec 2014 12:26:26 +0100
Message-Id: <afdb2106cf94f193907304fd51dcaa5894926280.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pablo Neira <pablo@netfilter.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e10038a8ec06ac819b7552bb67aaa6d2d6f850c1 upstream.

This structure is not exposed to userspace, so fix this by defining
struct sk_filter; so we skip the casting in kernelspace. This is safe
since userspace has no way to lurk with that internal pointer.

Fixes: e6f30c7 ("netfilter: x_tables: add xt_bpf match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/netfilter/xt_bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_bpf.h b/include/uapi/linux/netfilter/xt_bpf.h
index 5dda450eb55b..2ec9fbcd06f9 100644
--- a/include/uapi/linux/netfilter/xt_bpf.h
+++ b/include/uapi/linux/netfilter/xt_bpf.h
@@ -6,6 +6,8 @@
 
 #define XT_BPF_MAX_NUM_INSTR	64
 
+struct sk_filter;
+
 struct xt_bpf_info {
 	__u16 bpf_program_num_elem;
 	struct sock_filter bpf_program[XT_BPF_MAX_NUM_INSTR];
-- 
2.1.3

