Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493Ab3JPRp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:45:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288Ab3JPRpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 14/69] ARC: Setup Vector Table Base in early boot
Date: Wed, 16 Oct 2013 10:44:23 -0700
Message-Id: <20131016174314.637381911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 05b016ecf5e7a8c24409d8e9effb5d2ec9107708 upstream.

Otherwise early boot exceptions such as instructions errors due to
configuration mismatch between kernel and hardware go off to la-la land,
as opposed to hitting the handler and panic()'ing properly.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/head.S |    2 ++
 arch/arc/kernel/irq.c  |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -27,6 +27,8 @@ stext:
 	; Don't clobber r0-r4 yet. It might have bootloader provided info
 	;-------------------------------------------------------------------
 
+	sr	@_int_vec_base_lds, [AUX_INTR_VEC_BASE]
+
 #ifdef CONFIG_SMP
 	; Only Boot (Master) proceeds. Others wait in platform dependent way
 	;	IDENTITY Reg [ 3  2  1  0 ]
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -32,8 +32,6 @@ void __cpuinit arc_init_IRQ(void)
 {
 	int level_mask = 0;
 
-	write_aux_reg(AUX_INTR_VEC_BASE, _int_vec_base_lds);
-
 	/* Disable all IRQs: enable them as devices request */
 	write_aux_reg(AUX_IENABLE, 0);
 


