Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaIXTN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:13:56 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:63478 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbaIXTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:13:55 -0400
Message-ID: <1411586033.19525.34.camel@x220>
Subject: [PATCH] unicore32: Remove unneeded Kconfig entry NO_IOPORT_MAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 21:13:53 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2014 19:13:53.0500 (UTC) FILETIME=[AE35F9C0:01CFD82B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures only need a Kconfig entry for NO_IOPORT_MAP if it is
possible that its value will be 'y'. For unicore32 its value will always
be 'n', making it pointless. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by playing with arch/unicore32/configs/unicore32_defconfig. This
patch made no difference whatsoever to the generated .config file.
Please note that it has
    CONFIG_HAS_IOPORT_MAP=y

set after invoking "make oldconfig" both before and after this patch.

 arch/unicore32/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 928237a7b9ca..2322cc87e7cb 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -27,9 +27,6 @@ config UNICORE32
 config GENERIC_CSUM
 	def_bool y
 
-config NO_IOPORT_MAP
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
-- 
1.9.3

