Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3CREed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:34:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33712 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab3CREbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:16 -0400
Message-Id: <20130318042146.360540879@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 21/82] ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f2fe09b055e2549de41fb107b34c60bac4a1b0cf upstream.

Masked out PMXEVTYPER.NSH means that we can't enable profiling at PL2,
regardless of the settings in the HDCR.

This patch fixes the broken mask.

Reported-by: Christoffer Dall <cdall@cs.columbia.edu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/perf_event_v7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -720,7 +720,7 @@ static const unsigned armv7_a15_perf_cac
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV7_EVTYPE_MASK	0xc00000ff	/* Mask for writable bits */
+#define	ARMV7_EVTYPE_MASK	0xc80000ff	/* Mask for writable bits */
 #define	ARMV7_EVTYPE_EVENT	0xff		/* Mask for EVENT bits */
 
 /*


