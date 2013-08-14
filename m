Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3HNEkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 00:40:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3HNEkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 00:40:01 -0400
Date: Tue, 13 Aug 2013 21:39:40 -0700
From: tip-bot for Tang Chen <tipbot@zytor.com>
Message-ID: <tip-2449f343e4adc778de1c3d45b5aa14fe788663f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1376451844-15682-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1376451844-15682-1-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use memblock_set_current_limit()
  to set limit for memblock.
Git-Commit-ID: 2449f343e4adc778de1c3d45b5aa14fe788663f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 13 Aug 2013 21:39:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2449f343e4adc778de1c3d45b5aa14fe788663f5
Gitweb:     http://git.kernel.org/tip/2449f343e4adc778de1c3d45b5aa14fe788663f5
Author:     Tang Chen <tangchen@cn.fujitsu.com>
AuthorDate: Wed, 14 Aug 2013 11:44:04 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Aug 2013 21:27:02 -0700

x86: Use memblock_set_current_limit() to set limit for memblock.

In setup_arch() of x86, it set memblock.current_limit directly.
We should use memblock_set_current_limit(). If the implementation
is changed, it is easy to maintain.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/1376451844-15682-1-git-send-email-tangchen@cn.fujitsu.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..de33798 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1070,7 +1070,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = ISA_END_ADDRESS;
+	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
 	/*
@@ -1103,7 +1103,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
