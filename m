Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3LRVNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3LRVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Jon Medhurst <tixy@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 015/118] ARM: 7917/1: cacheflush: correctly limit range of memory region being flushed
Date: Wed, 18 Dec 2013 13:10:52 -0800
Message-Id: <20131218211219.899085789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Medhurst <tixy@linaro.org>

commit b31459adeab018b297541e288ac88873011da82a upstream.

The __do_cache_op function operates with a 'chunk' size of one page
but fails to limit the size of the final chunk so as to not exceed
the specified memory region. Fix this.

Reported-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Tested-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/traps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -503,9 +503,10 @@ static inline int
 __do_cache_op(unsigned long start, unsigned long end)
 {
 	int ret;
-	unsigned long chunk = PAGE_SIZE;
 
 	do {
+		unsigned long chunk = min(PAGE_SIZE, end - start);
+
 		if (signal_pending(current)) {
 			struct thread_info *ti = current_thread_info();
 


