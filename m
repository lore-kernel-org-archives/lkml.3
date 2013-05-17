Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3EQLTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:19:09 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48873 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3EQLTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:19:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] h8300: Limit timer channel ranges in Kconfig
Date: Fri, 17 May 2013 13:18:59 +0200
Message-Id: <1368789541-3869-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/h8300/kernel/timer/itu.c and arch/h8300/kernel/timer/tpu.c
only support 0--4 for CONFIG_H8300_ITU_CH resp. H8300_TPU_CH, hence limit
them to that range in Kconfig.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/Kconfig.cpu |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index 321f392..c8ea74a 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -155,10 +155,12 @@ config H8300_TIMER16_CH
 config H8300_ITU_CH
 	int "ITU channel"
 	depends on H8300_ITU
+	range 0 4
 
 config H8300_TPU_CH
 	int "TPU channel"
 	depends on H8300_TPU
+	range 0 4
 
 source "kernel/Kconfig.preempt"
 
-- 
1.7.0.4

