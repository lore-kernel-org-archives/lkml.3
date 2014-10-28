Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbaJ1Hbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:31:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaJ1Dlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 130/146] sparc64: Fix hibernation code refrence to PAGE_OFFSET.
Date: Tue, 28 Oct 2014 11:34:32 +0800
Message-Id: <20141028033349.072320840@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

We changed PAGE_OFFSET to be a variable rather than a constant,
but this reference here in the hibernate assembler got missed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/power/hibernate_asm.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/power/hibernate_asm.S
+++ b/arch/sparc/power/hibernate_asm.S
@@ -54,8 +54,8 @@ ENTRY(swsusp_arch_resume)
 	 nop
 
 	/* Write PAGE_OFFSET to %g7 */
-	sethi	%uhi(PAGE_OFFSET), %g7
-	sllx	%g7, 32, %g7
+	sethi	%hi(PAGE_OFFSET), %g7
+	ldx	[%g7 + %lo(PAGE_OFFSET)], %g7
 
 	setuw	(PAGE_SIZE-8), %g3
 


