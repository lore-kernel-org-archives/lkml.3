Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbbAGDBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:01:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbbAGBwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.18 43/84] x86, microcode, intel: Drop unused parameter
Date: Tue,  6 Jan 2015 17:49:46 -0800
Message-Id: <20150107014030.417002064@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 47768626c6db42cd06ff077ba12dd2cb10ab818b upstream.

apply_microcode_early() doesn't use mc_saved_data, kill it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/intel_early.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -650,8 +650,7 @@ static inline void print_ucode(struct uc
 }
 #endif
 
-static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
-				 struct ucode_cpu_info *uci)
+static int apply_microcode_early(struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
@@ -720,7 +719,7 @@ _load_ucode_intel_bsp(struct mc_saved_da
 		       mc_saved_in_initrd, uci);
 	load_microcode(mc_saved_data, mc_saved_in_initrd,
 		       initrd_start_early, uci);
-	apply_microcode_early(mc_saved_data, uci);
+	apply_microcode_early(uci);
 }
 
 void __init
@@ -783,5 +782,5 @@ void load_ucode_intel_ap(void)
 	collect_cpu_info_early(&uci);
 	load_microcode(mc_saved_data_p, mc_saved_in_initrd_p,
 		       initrd_start_addr, &uci);
-	apply_microcode_early(mc_saved_data_p, &uci);
+	apply_microcode_early(&uci);
 }


