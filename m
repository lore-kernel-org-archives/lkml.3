Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaKSWO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:14:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbaKSUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr on 32-bit
Date: Wed, 19 Nov 2014 12:52:03 -0800
Message-Id: <20141119205153.916605840@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 85be07c32496dc264661308e4d9d4e9ccaff8072 upstream.

We should be accessing it through a pointer, like on the BSP.

Tested-by: Richard Hendershot <rshendershot@mchsi.com>
Fixes: 65cef1311d5d ("x86, microcode: Add a disable chicken bit")
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/core_early.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/core_early.c
+++ b/arch/x86/kernel/cpu/microcode/core_early.c
@@ -124,7 +124,7 @@ void __init load_ucode_bsp(void)
 static bool check_loader_disabled_ap(void)
 {
 #ifdef CONFIG_X86_32
-	return __pa_nodebug(dis_ucode_ldr);
+	return *((bool *)__pa_nodebug(&dis_ucode_ldr));
 #else
 	return dis_ucode_ldr;
 #endif


