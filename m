Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198Ab3BLOxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:53:12 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:43010 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405Ab3BLOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/10] cris/kgdb: Fix buffer overflow in getpacket()
Date: Tue, 12 Feb 2013 15:52:54 +0100
Message-Id: <1360680777-12622-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/arch-v10/kernel/kgdb.c: In function 'handle_exception':
arch/cris/arch-v10/kernel/kgdb.c:534:17: warning: array subscript is above array bounds [-Warray-bounds]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index d0b6257..0e79907 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -523,7 +523,7 @@ getpacket (char *buffer)
 		xmitcsum = -1;
 		count = 0;
 		/* Read until a # or the end of the buffer is reached */
-		while (count < BUFMAX) {
+		while (count < BUFMAX - 1) {
 			ch = getDebugChar ();
 			if (ch == '#')
 				break;
-- 
1.7.0.4

