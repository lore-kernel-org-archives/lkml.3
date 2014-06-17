Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbaFQQWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:22:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbaFQQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:22:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 097/121] s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH
Date: Tue, 17 Jun 2014 09:17:55 -0700
Message-Id: <1403021899-16708-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 6e0de817594c61f3b392a9245deeb09609ec707d upstream.

The A register needs to be initialized to zero in the prolog if the
first instruction of the BPF program is BPF_S_LDX_B_MSH to prevent
leaking the content of %r5 to user space.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/net/bpf_jit_comp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 5e92f47..ab9e3f4 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -242,7 +242,6 @@ static void bpf_jit_noleaks(struct bpf_jit *jit, struct sock_filter *filter)
 	case BPF_S_LD_W_IND:
 	case BPF_S_LD_H_IND:
 	case BPF_S_LD_B_IND:
-	case BPF_S_LDX_B_MSH:
 	case BPF_S_LD_IMM:
 	case BPF_S_LD_MEM:
 	case BPF_S_MISC_TXA:
-- 
1.9.1

