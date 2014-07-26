Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaGZTSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:18:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaGZTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 038/109] net: filter: fix upper BPF instruction limit
Date: Sat, 26 Jul 2014 12:02:00 -0700
Message-Id: <20140726190224.984769091@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 6f9a093b66ce7cacc110d8737c03686e80ecfda6 ]

The original checks (via sk_chk_filter) for instruction count uses ">",
not ">=", so changing this in sk_convert_filter has the potential to break
existing seccomp filters that used exactly BPF_MAXINSNS many instructions.

Fixes: bd4cf0ed331a ("net: filter: rework/optimize internal BPF interpreter's instruction set")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org # v3.15+
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -872,7 +872,7 @@ int sk_convert_filter(struct sock_filter
 	BUILD_BUG_ON(BPF_MEMWORDS * sizeof(u32) > MAX_BPF_STACK);
 	BUILD_BUG_ON(FP_REG + 1 != MAX_BPF_REG);
 
-	if (len <= 0 || len >= BPF_MAXINSNS)
+	if (len <= 0 || len > BPF_MAXINSNS)
 		return -EINVAL;
 
 	if (new_prog) {


