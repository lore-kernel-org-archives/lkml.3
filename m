Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3DWVwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:52:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3DWVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [ 01/42] powerpc: add a missing label in resume_kernel
Date: Tue, 23 Apr 2013 14:51:59 -0700
Message-Id: <20130423215205.713391123@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit d8b92292408831d86ff7b781e66bf79301934b99 upstream.

A label 0 was missed in the patch a9c4e541 (powerpc/kprobe: Complete
kprobe and migrate exception frame). This will cause the kernel
branch to an undetermined address if there really has a conflict when
updating the thread flags.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-By: Tiejun Chen <tiejun.chen@windriver.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -634,7 +634,7 @@ resume_kernel:
 	/* Clear _TIF_EMULATE_STACK_STORE flag */
 	lis	r11,_TIF_EMULATE_STACK_STORE@h
 	addi	r5,r9,TI_FLAGS
-	ldarx	r4,0,r5
+0:	ldarx	r4,0,r5
 	andc	r4,r4,r11
 	stdcx.	r4,0,r5
 	bne-	0b


