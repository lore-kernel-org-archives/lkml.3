Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaC1RzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:55:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaC1Rao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3.10 13/22] ARM: move outer_cache declaration out of ifdef
Date: Fri, 28 Mar 2014 10:32:05 -0700
Message-Id: <20140328173111.220536702@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <rob.herring@calxeda.com>

commit 0b53c11d533a8f6688d73fad0baf67dd08ec1b90 upstream.

Move the outer_cache declaration of the CONFIG_OUTER_CACHE ifdef so that
outer_cache can be used inside IS_ENABLED condition.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/outercache.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -37,10 +37,10 @@ struct outer_cache_fns {
 	void (*resume)(void);
 };
 
-#ifdef CONFIG_OUTER_CACHE
-
 extern struct outer_cache_fns outer_cache;
 
+#ifdef CONFIG_OUTER_CACHE
+
 static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
 {
 	if (outer_cache.inv_range)


