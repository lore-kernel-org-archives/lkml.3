Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaEZRBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:01:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:43464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaEZQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122320"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 04/15] x86/xsaves: Change compacted format xsave area header
Date: Mon, 26 May 2014 10:01:11 -0700
Message-Id: <1401123682-5384-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

With compacted format xsave area supported, the xsave area header is changed
to support both compacted format and standard format xsave area.

The XSAVE header of an XSAVE area comprises the 64 bytes starting at offset
512 from the area\u2019s base address:
        - Bytes 7:0 of the XSAVE header is a state-component bitmap called
XSTATE_BV. It identifies the state components in the XSAVE area.
        - Bytes 15:8 of the XSAVE header is a state-component bitmap called
XCOMP_BV. It is used as follows:
                - XCOMP_BV[63] indicates the format of the extended region of
the XSAVE area. If it is clear, the standard format is used. If it is set,
the compacted format is used; XCOMP_BV[62:0] provide format specifics.
                - XCOMP_BV[63] determines which form of the XRSTOR instruction
is used. If the bit is set, the compacted form is used; otherwise, the standard
form is used. See Section 13.7.
        - All bits in XCOMP_BV should be 0 if the processor does not support
the compaction extensions to the XSAVE feature set.
        - Bytes 63:16 of the XSAVE header are reserved.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a4ea023..2c8d3b8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -386,8 +386,8 @@ struct bndcsr_struct {
 
 struct xsave_hdr_struct {
 	u64 xstate_bv;
-	u64 reserved1[2];
-	u64 reserved2[5];
+	u64 xcomp_bv;
+	u64 reserved[6];
 } __attribute__((packed));
 
 struct xsave_struct {
-- 
1.8.1.2

