Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216Ab3EFXkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:40:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760273Ab3EFXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 013/104] powerpc/power8: Fix secondary CPUs hanging on boot for HV=0
Date: Mon,  6 May 2013 16:11:32 -0700
Message-Id: <20130506230044.963642403@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,6 +64,7 @@ _GLOBAL(__restore_cpu_power8)
 	mflr	r11
 	mfmsr	r3
 	rldicl.	r0,r3,4,63
+	mtlr	r11
 	beqlr
 	li	r0,0
 	mtspr	SPRN_LPID,r0


