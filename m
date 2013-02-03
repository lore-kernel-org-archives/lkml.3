Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3BCPEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:04:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087Ab3BCO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:03 -0500
Message-Id: <20130203144653.768292235@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>
Subject: [ 110/128] x86/Sandy Bridge: mark arrays in __init functions as __initconst
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit ab3cd8670e0b3fcde7f029e1503ed3c5138e9571 upstream.

Mark static arrays as __initconst so they get removed when the init
sections are flushed.

Reported-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/75F4BEE6-CB0E-4426-B40B-697451677738@googlemail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9dcb325..18182d1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -614,7 +614,7 @@ static bool __init snb_gfx_workaround_needed(void)
 {
 	int i;
 	u16 vendor, devid;
-	static const u16 snb_ids[] = {
+	static const __initconst u16 snb_ids[] = {
 		0x0102,
 		0x0112,
 		0x0122,
@@ -646,7 +646,7 @@ static bool __init snb_gfx_workaround_needed(void)
  */
 static void __init trim_snb_memory(void)
 {
-	static const unsigned long bad_pages[] = {
+	static const __initconst unsigned long bad_pages[] = {
 		0x20050000,
 		0x20110000,
 		0x20130000,


