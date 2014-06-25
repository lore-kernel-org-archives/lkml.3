Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaFYMZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:25:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50919 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaFYMZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:25:02 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: kvm: x86.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 14:25:58 +0200
Message-Id: <1403699158-22807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to the same value more than once

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/kvm/x86.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..0f48eb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4730,7 +4730,6 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 	if (desc->g)
 		var.limit = (var.limit << 12) | 0xfff;
 	var.type = desc->type;
-	var.present = desc->p;
 	var.dpl = desc->dpl;
 	var.db = desc->d;
 	var.s = desc->s;
-- 
1.7.10.4

