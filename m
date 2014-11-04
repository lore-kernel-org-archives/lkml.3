Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaKDRW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:22:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKDRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:22:22 -0500
Date: Tue, 4 Nov 2014 09:21:56 -0800
From: tip-bot for Daniel J Blueman <tipbot@zytor.com>
Message-ID: <tip-25e5a76bae106e1673887db09e22b19cb1a86c45@git.kernel.org>
Cc: mingo@kernel.org, daniel@numascale.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, bhelgaas@google.com, sp@numascale.com,
        tglx@linutronix.de
Reply-To: hpa@zytor.com, tglx@linutronix.de, sp@numascale.com,
        bhelgaas@google.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        daniel@numascale.com
In-Reply-To: <1415089784-28779-2-git-send-email-daniel@numascale.com>
References: <1415089784-28779-2-git-send-email-daniel@numascale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: numachip: Elide self-IPI ICR polling
Git-Commit-ID: 25e5a76bae106e1673887db09e22b19cb1a86c45
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

Commit-ID:  25e5a76bae106e1673887db09e22b19cb1a86c45
Gitweb:     http://git.kernel.org/tip/25e5a76bae106e1673887db09e22b19cb1a86c45
Author:     Daniel J Blueman <daniel@numascale.com>
AuthorDate: Tue, 4 Nov 2014 16:29:42 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Nov 2014 18:17:27 +0100

x86: numachip: Elide self-IPI ICR polling

The default self-IPI path polls the ICR to delay sending the IPI until
there is no IPI in progress. This is redundant on x86-86 APICs, since
IPIs are queued. See the AMD64 Architecture Programmer's Manual, vol 2,
p525.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
Cc: Steffen Persvold <sp@numascale.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/1415089784-28779-2-git-send-email-daniel@numascale.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic_numachip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 2aaee79..7a31912 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -145,7 +145,7 @@ static void numachip_send_IPI_all(int vector)
 
 static void numachip_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	apic_write(APIC_SELF_IPI, vector);
 }
 
 static int __init numachip_probe(void)
