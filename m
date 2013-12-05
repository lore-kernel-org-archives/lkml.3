Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3LENaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:30:23 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59636 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3LENaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:30:18 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-ee-52a07fe85ebb
Subject: [PATCH 2/2] ARM64: fix framepointer check in unwind_frame
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Date: Thu, 05 Dec 2013 17:30:16 +0400
Message-id: <20131205133016.16410.42062.stgit@buzz>
In-reply-to: <20131205133010.16410.96824.stgit@buzz>
References: <20131205133010.16410.96824.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t/xy7ov6hcEGXQ8t7B4v6yH0eLHzl5W
	i02Pr7FaXN41h83i5ccTLA6sHmvmrWH02Lyk3qNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	pt7rZCmYylpx5c8n5gbGKSxdjJwcEgImEs8mXWKCsMUkLtxbz9bFyMUhJLCUUeLp4n4op4FJ
	YlHjG7AqYQEniVW/d4IlRARmMEp8vvOTHSTBJmAmsW3fbUYQm0VAVWLOy/1gcV4BY4nt+/vA
	4pxA67p7m8FWCwHFH6y/ygxiiwKtXnPpJBNEvaDEj8n3gGo4OJgF1CWmTMkFCTMLyEtsXvOW
	eQIj/ywkVbMQqmYhqVrAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRYv+5gXHrM6hCj
	AAejEg+vY8r8ICHWxLLiytxDjBIczEoivMI5C4KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MM6c
	nHF0x/Iu7cbvYb+lbEy8Dc7lK19dNrNQujKiYs3ndVLyt19an2SeLOEf28a9Kz3X4+LSGMYH
	l+9VZTbzHLX3S9sUd2T2MeVls+zeXr4zeZvGxnluN9i6XQ03GTK8lVsplVNbJPHH1vl79NaI
	YJfwCIXkrcp33D2O/bxoW7faR7VD6OWlIiWW4oxEQy3mouJEAFZ9M8I0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need at least 24 bytes above frame pointer.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm64/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d25459f..c3b6c63 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -43,7 +43,7 @@ int unwind_frame(struct stackframe *frame)
 	low  = frame->sp;
 	high = ALIGN(low, THREAD_SIZE);
 
-	if (fp < low || fp > high || fp & 0xf)
+	if (fp < low || fp > high - 0x18 || fp & 0xf)
 		return -EINVAL;
 
 	frame->sp = fp + 0x10;

