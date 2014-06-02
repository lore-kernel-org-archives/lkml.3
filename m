Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaFBPhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:37:05 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:7149 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaFBPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBXkQUVcZiELOD4UtF45SBxaEKgSKH6ZJ
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBXkQUVcZiELOD4UtF45SBxaEKgSKH6ZJ
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853154"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 4/9] KVM: x86: sgdt and sidt are not privilaged
Date: Mon,  2 Jun 2014 18:34:06 +0300
Message-Id: <1401723251-8034-5-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SGDT and SIDT instructions are not privilaged, i.e. they can be executed
with CPL>0.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7e4a45c..a16bf22 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3642,8 +3642,8 @@ static const struct opcode group6[] = {
 };
 
 static const struct group_dual group7 = { {
-	II(Mov | DstMem | Priv,			em_sgdt, sgdt),
-	II(Mov | DstMem | Priv,			em_sidt, sidt),
+	II(Mov | DstMem,			em_sgdt, sgdt),
+	II(Mov | DstMem,			em_sidt, sidt),
 	II(SrcMem | Priv,			em_lgdt, lgdt),
 	II(SrcMem | Priv,			em_lidt, lidt),
 	II(SrcNone | DstMem | Mov,		em_smsw, smsw), N,
-- 
1.9.1

