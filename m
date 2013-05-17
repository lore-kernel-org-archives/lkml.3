Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3EQHvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:51:46 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:52382 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab3EQHvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:51:45 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH] ARM: vt8500: Add missing NULL terminator in dt_compat
Date: Fri, 17 May 2013 08:44:17 +0100
Message-Id: <1368776657-23035-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

When I tried booting a stih415 Dual core A9 with multi_v7_defconfig, it
failed to boot. The issues seems to be changing by enabling or disabling
VT8550 platform. Having a quick look at dt_compat list, it seems to miss
a NULL terminator, which means of_flat_dt_match will compat check will
cross the boundary of dt_compat and fault at some point , which is what
was happening in my case.

Without this patch if we try to boot multi_v7_defconfig you might notice
that some of the platforms might fault if they fall after vt8500 in
machine-desc list. Other platforms which fall before vt8500 in mdesc list
will not fault.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/mach-vt8500/vt8500.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 1dd281e..f5c33df 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -173,6 +173,7 @@ static const char * const vt8500_dt_compat[] = {
 	"wm,wm8505",
 	"wm,wm8750",
 	"wm,wm8850",
+	NULL
 };
 
 DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
-- 
1.7.6.5

