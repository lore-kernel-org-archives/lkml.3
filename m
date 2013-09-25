Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3IYAUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab3IYAUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 020/117] arm64: perf: fix ARMv8 EVTYPE_MASK to include NSH bit
Date: Tue, 24 Sep 2013 17:18:06 -0700
Message-Id: <20130925001743.055378539@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 178cd9ce377232518ec17ff2ecab2e80fa60784c upstream.

This is a port of f2fe09b055e2 ("ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK
to include NSH bit") to arm64, which fixes the broken evtype mask to
include the NSH bit, allowing profiling at EL2.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -784,7 +784,7 @@ static const unsigned armv8_pmuv3_perf_c
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV8_EVTYPE_MASK	0xc00000ff	/* Mask for writable bits */
+#define	ARMV8_EVTYPE_MASK	0xc80000ff	/* Mask for writable bits */
 #define	ARMV8_EVTYPE_EVENT	0xff		/* Mask for EVENT bits */
 
 /*


