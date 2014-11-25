Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaKYKnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaKYKnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 249/254] netfilter: xt_bpf: add mising opaque struct sk_filter definition
Date: Tue, 25 Nov 2014 10:39:59 +0000
Message-Id: <1416912004-5928-250-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira <pablo@netfilter.org>

commit e10038a8ec06ac819b7552bb67aaa6d2d6f850c1 upstream.

This structure is not exposed to userspace, so fix this by defining
struct sk_filter; so we skip the casting in kernelspace. This is safe
since userspace has no way to lurk with that internal pointer.

Fixes: e6f30c7 ("netfilter: x_tables: add xt_bpf match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.0

