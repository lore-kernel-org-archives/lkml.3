Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaIDSq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:46:57 -0400
Received: from bowie.eng.utah.edu ([155.98.110.113]:49508 "EHLO
	bowie.eng.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaIDSq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:46:56 -0400
Message-ID: <5408B39D.4030400@eng.utah.edu>
Date: Thu, 04 Sep 2014 12:46:53 -0600
From: Scotty Bauer <sbauer@eng.utah.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, clemens@ladisch.de
Subject: [PATCH] kern/sys: Compat sysinfo syscall fix undefined behavior
Content-Type: multipart/mixed;
 boundary="------------090501030002030507060708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090501030002030507060708
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



--------------090501030002030507060708
Content-Type: text/x-diff;
 name="compat_sysinfo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="compat_sysinfo.patch"

Fix undefined behavior and compiler warning by replacing right
shift 32 with upper_32_bits macro

Signed-off-by: Scotty Bauer <sbauer@eng.utah.edu>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index ce81291..c78530b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2135,7 +2135,7 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
 	/* Check to see if any memory value is too large for 32-bit and scale
 	 *  down if needed
 	 */
-	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
+	if (upper_32_bits(s.totalram) || upper_32_bits(s.totalswap)) {
 		int bitcount = 0;
 
 		while (s.mem_unit < PAGE_SIZE) {
-- 
1.8.3.2


--------------090501030002030507060708--
