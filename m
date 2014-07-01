Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbaGAQkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:40:03 -0400
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:45326
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbaGAQkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:40:00 -0400
X-Greylist: delayed 2774 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 12:39:59 EDT
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] arm64: KVM: export demux regids as KVM_REG_ARM64
Date: Tue,  1 Jul 2014 16:53:13 +0100
Message-Id: <1404229993-14522-1-git-send-email-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suspect this is a -ECUTPASTE fault from the initial implementation. If
we don't declare the register ID to be KVM_REG_ARM64 the KVM_GET_ONE_REG
implementation kvm_arm_get_reg() returns -EINVAL and hilarity ensues.

The kvm/api.txt document describes all arm64 registers as starting with
0x60xx... (i.e KVM_REG_ARM64).

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0324458..5ee99e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -962,7 +962,7 @@ static unsigned int num_demux_regs(void)
 
 static int write_demux_regids(u64 __user *uindices)
 {
-	u64 val = KVM_REG_ARM | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
+	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
 	unsigned int i;
 
 	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
-- 
2.0.0

