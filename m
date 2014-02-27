Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaB0MMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:12:39 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58199 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaB0MMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:12:37 -0500
Date: Thu, 27 Feb 2014 17:42:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>,
        Christoph Hellwig <hch@infradead.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, josh@joshtriplett.org
Subject: [PATCH 30/46] kernel: Add prototype declaration to header file
 include/linux/smp.h
Message-ID: <dd07baef637badb8e22349552732350f0f4147c4.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype definition of function to header file include/linux/smp.h
because it is used by more than one file.

This eliminates the following warning in kernel/smp.c:
kernel/smp.c:489:13: warning: no previous prototype for ‘smp_announce’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/smp.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 3834f43..0a9ca03 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -26,6 +26,8 @@ struct call_single_data {
 	u16 flags;
 };
 
+void smp_announce(void);
+
 /* total number of cpus in this system (may exceed NR_CPUS) */
 extern unsigned int total_cpus;
 
-- 
1.7.9.5

