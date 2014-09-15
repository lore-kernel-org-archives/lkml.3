Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbaIOUfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:35:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbaIOTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Tejun Heo <htejun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 018/114] kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path
Date: Mon, 15 Sep 2014 12:25:18 -0700
Message-Id: <20140915192641.996085323@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 618fde872163e782183ce574c77f1123e2be8887 upstream.

The rarely-executed memry-allocation-failed callback path generates a
WARN_ON_ONCE() when smp_call_function_single() succeeds.  Presumably
it's supposed to warn on failures.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -617,7 +617,7 @@ void on_each_cpu_cond(bool (*cond_func)(
 			if (cond_func(cpu, info)) {
 				ret = smp_call_function_single(cpu, func,
 								info, wait);
-				WARN_ON_ONCE(!ret);
+				WARN_ON_ONCE(ret);
 			}
 		preempt_enable();
 	}


