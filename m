Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaJHJWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:22:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaJHJWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:22:16 -0400
Date: Wed, 8 Oct 2014 02:21:45 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-2dee5c43da3a981489a4f18972827139afcbee82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1411533139-25708-1-git-send-email-andi@firstfloor.org>
References: <1411533139-25708-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix section conflict for numachip
Git-Commit-ID: 2dee5c43da3a981489a4f18972827139afcbee82
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

Commit-ID:  2dee5c43da3a981489a4f18972827139afcbee82
Gitweb:     http://git.kernel.org/tip/2dee5c43da3a981489a4f18972827139afcbee82
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Wed, 24 Sep 2014 06:32:19 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 11:18:49 +0200

x86: Fix section conflict for numachip

A variable cannot be both __read_mostly and const. This
is a meaningless combination.

Just make it only const.

This fixes the LTO build with numachip enabled.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1411533139-25708-1-git-send-email-andi@firstfloor.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic_numachip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index ae91539..4128b5f 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -32,7 +32,7 @@
 
 static int numachip_system __read_mostly;
 
-static const struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip;
 
 static unsigned int get_apic_id(unsigned long x)
 {
