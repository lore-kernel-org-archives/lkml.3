Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaKLBcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:32:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbaKLBcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andriy Skulysh <askulysh@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 240/319] sh: fix sh770x SCIF memory regions
Date: Wed, 12 Nov 2014 10:16:18 +0900
Message-Id: <20141112011032.513436246@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andriy Skulysh <askulysh@gmail.com>

commit 5417421b270229bfce0795ccc99a4b481e4954ca upstream.

Resources scif1_resources & scif2_resources overlap.  Actual SCIF region
size is 0x10.

This is regression from commit d850acf975be ("sh: Declare SCIF register
base and IRQ as resources")

Signed-off-by: Andriy Skulysh <askulysh@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/kernel/cpu/sh3/setup-sh770x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sh/kernel/cpu/sh3/setup-sh770x.c
+++ b/arch/sh/kernel/cpu/sh3/setup-sh770x.c
@@ -118,7 +118,7 @@ static struct plat_sci_port scif0_platfo
 };
 
 static struct resource scif0_resources[] = {
-	DEFINE_RES_MEM(0xfffffe80, 0x100),
+	DEFINE_RES_MEM(0xfffffe80, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x4e0)),
 };
 
@@ -143,7 +143,7 @@ static struct plat_sci_port scif1_platfo
 };
 
 static struct resource scif1_resources[] = {
-	DEFINE_RES_MEM(0xa4000150, 0x100),
+	DEFINE_RES_MEM(0xa4000150, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x900)),
 };
 
@@ -169,7 +169,7 @@ static struct plat_sci_port scif2_platfo
 };
 
 static struct resource scif2_resources[] = {
-	DEFINE_RES_MEM(0xa4000140, 0x100),
+	DEFINE_RES_MEM(0xa4000140, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x880)),
 };
 


