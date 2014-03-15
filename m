Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaCOUCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:02:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbaCOUCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:02:12 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86 emulator: emulate MOVAPD
Date: Sat, 15 Mar 2014 21:02:00 +0100
Message-Id: <1394913720-6466-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add emulation for 0x66 prefixed instruction of 0f 28 opcode
that has been added earlier.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a26d075..205b17e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3669,7 +3669,7 @@ static const struct gprefix pfx_vmovntpx = {
 };
 
 static const struct gprefix pfx_0f_28_0f_29 = {
-	I(Aligned, em_mov), N, N, N,
+	I(Aligned, em_mov), I(Aligned, em_mov), N, N,
 };
 
 static const struct escape escape_d9 = { {
-- 
1.8.5.3

