Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab3CLXCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:02:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3CLWdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 051/100] ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit
Date: Tue, 12 Mar 2013 15:31:36 -0700
Message-Id: <20130312223128.481176494@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f2fe09b055e2549de41fb107b34c60bac4a1b0cf upstream.

Masked out PMXEVTYPER.NSH means that we can't enable profiling at PL2,
regardless of the settings in the HDCR.

This patch fixes the broken mask.

Reported-by: Christoffer Dall <cdall@cs.columbia.edu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event_v7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -774,7 +774,7 @@ static const unsigned armv7_a7_perf_cach
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV7_EVTYPE_MASK	0xc00000ff	/* Mask for writable bits */
+#define	ARMV7_EVTYPE_MASK	0xc80000ff	/* Mask for writable bits */
 #define	ARMV7_EVTYPE_EVENT	0xff		/* Mask for EVENT bits */
 
 /*


