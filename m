Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab3BEWQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:16:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab3BEWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 78/93] x86/Sandy Bridge: mark arrays in __init functions as __initconst
Date: Tue,  5 Feb 2013 20:07:07 -0200
Message-Id: <1360102042-10732-79-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit ab3cd8670e0b3fcde7f029e1503ed3c5138e9571 upstream.

Mark static arrays as __initconst so they get removed when the init
sections are flushed.

Reported-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/75F4BEE6-CB0E-4426-B40B-697451677738@googlemail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 36cf7fa..8ac6c8a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -617,7 +617,7 @@ static bool __init snb_gfx_workaround_needed(void)
 {
 	int i;
 	u16 vendor, devid;
-	static const u16 snb_ids[] = {
+	static const __initconst u16 snb_ids[] = {
 		0x0102,
 		0x0112,
 		0x0122,
@@ -649,7 +649,7 @@ static bool __init snb_gfx_workaround_needed(void)
  */
 static void __init trim_snb_memory(void)
 {
-	static const unsigned long bad_pages[] = {
+	static const __initconst unsigned long bad_pages[] = {
 		0x20050000,
 		0x20110000,
 		0x20130000,
-- 
1.7.9.5

