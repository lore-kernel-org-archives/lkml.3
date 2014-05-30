Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbaE3PLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:11:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbaE3PLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:11:32 -0400
Date: Fri, 30 May 2014 08:11:20 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-0b29643a58439dc9a8b0c0cacad0e7cb608c8199@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-6-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-6-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves:
  Change compacted format xsave area header
Git-Commit-ID: 0b29643a58439dc9a8b0c0cacad0e7cb608c8199
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b29643a58439dc9a8b0c0cacad0e7cb608c8199
Gitweb:     http://git.kernel.org/tip/0b29643a58439dc9a8b0c0cacad0e7cb608c8199
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:33 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:31:10 -0700

x86/xsaves: Change compacted format xsave area header

The XSAVE area header is changed to support both compacted format and
standard format of xsave area.

The XSAVE header of an xsave area comprises the 64 bytes starting at offset
512 from the area base address:

- Bytes 7:0 of the xsave header is a state-component bitmap called
  xstate_bv. It identifies the state components in the xsave area.

- Bytes 15:8 of the xsave header is a state-component bitmap called
  xcomp_bv. It is used as follows:
  - xcomp_bv[63] indicates the format of the extended region of
    the xsave area. If it is clear, the standard format is used.
    If it is set, the compacted format is used.
  - xcomp_bv[62:0] indicate which features (starting at feature 2)
    have space allocated for them in the compacted format.

- Bytes 63:16 of the xsave header are reserved.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-6-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
