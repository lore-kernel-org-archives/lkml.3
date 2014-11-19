Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbaKSVDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:03:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbaKSVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 127/141] netfilter: xt_bpf: add mising opaque struct sk_filter definition
Date: Wed, 19 Nov 2014 12:52:30 -0800
Message-Id: <20141119205154.979499441@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/netfilter/xt_bpf.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/uapi/linux/netfilter/xt_bpf.h
+++ b/include/uapi/linux/netfilter/xt_bpf.h
@@ -8,6 +8,8 @@
 
 struct bpf_prog;
 
+struct sk_filter;
+
 struct xt_bpf_info {
 	__u16 bpf_program_num_elem;
 	struct sock_filter bpf_program[XT_BPF_MAX_NUM_INSTR];


