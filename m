Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030256Ab3BAN0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:26:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:44344 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030216Ab3BANIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:08:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>,
        Ian Molton <ian.molton@collabora.co.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Subject: [ 14/89] ARM: virt: boot secondary CPUs through the right entry point
Date: Fri,  1 Feb 2013 14:07:29 +0100
Message-Id: <20130201130208.481515085@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <marc.zyngier@arm.com>

commit 6e484be1ccca3ea495db45900fd42aac8d49d754 upstream.

Secondary CPUs should use the __hyp_stub_install_secondary entry
point, so boot mode inconsistencies can be detected.

Acked-by: Dave Martin <dave.martin@linaro.org>
Reported-by: Ian Molton <ian.molton@collabora.co.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -334,7 +334,7 @@ ENTRY(secondary_startup)
 	 * as it has already been validated by the primary processor.
 	 */
 #ifdef CONFIG_ARM_VIRT_EXT
-	bl	__hyp_stub_install
+	bl	__hyp_stub_install_secondary
 #endif
 	safe_svcmode_maskall r9
 


