Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaFEEVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaFEEVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 141/214] x86/Sandy Bridge: mark arrays in __init functions as __initconst
Date: Wed,  4 Jun 2014 21:18:24 -0700
Message-Id: <20140605041658.710449111@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 91c90db1aa92a50fa1d7f289502b49ddb46a90d3 upstream.

commit ab3cd8670e0b3fcde7f029e1503ed3c5138e9571 upstream.

Mark static arrays as __initconst so they get removed when the init
sections are flushed.

Reported-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/75F4BEE6-CB0E-4426-B40B-697451677738@googlemail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -625,7 +625,7 @@ static bool __init snb_gfx_workaround_ne
 #ifdef CONFIG_PCI
 	int i;
 	u16 vendor, devid;
-	static const u16 snb_ids[] = {
+	static const __initconst u16 snb_ids[] = {
 		0x0102,
 		0x0112,
 		0x0122,
@@ -658,7 +658,7 @@ static bool __init snb_gfx_workaround_ne
  */
 static void __init trim_snb_memory(void)
 {
-	static const unsigned long bad_pages[] = {
+	static const __initconst unsigned long bad_pages[] = {
 		0x20050000,
 		0x20110000,
 		0x20130000,


