Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab3EFVR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:17:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab3EFUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 013/115] powerpc/power8: Fix secondary CPUs hanging on boot for HV=0
Date: Mon,  6 May 2013 13:44:09 -0700
Message-Id: <20130506203056.946486455@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 8c2a381734fc9718f127f4aba958e8a7958d4028 upstream.

In __restore_cpu_power8 we determine if we are HV and if not, we return
before setting HV only resources.

Unfortunately we forgot to restore the link register from r11 before
returning.

This will happen on boot and with secondary CPUs not coming online.

This adds the missing link register restore.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/cpu_setup_power.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/cpu_setup_power.S
+++ b/arch/powerpc/kernel/cpu_setup_power.S
@@ -66,6 +66,7 @@ _GLOBAL(__restore_cpu_power8)
 	bl	__init_FSCR
 	mfmsr	r3
 	rldicl.	r0,r3,4,63
+	mtlr	r11
 	beqlr
 	li	r0,0
 	mtspr	SPRN_LPID,r0


