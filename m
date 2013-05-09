Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3EIW0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3EIW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        John J Miller <millerjo@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 03/73] powerpc/tm: Fix null pointer deference in flush_hash_page
Date: Thu,  9 May 2013 15:24:53 -0700
Message-Id: <20130509222526.830697843@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit c2fd22df89365df9451d5b91da3b7bfd48122ecd upstream.

Make sure that current->thread.reg exists before we deference it in
flush_hash_page.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reported-by: John J Miller <millerjo@us.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hash_utils_64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -1191,6 +1191,7 @@ void flush_hash_page(unsigned long vpn,
 	 * unmapping it first, it may see the speculated version.
 	 */
 	if (local && cpu_has_feature(CPU_FTR_TM) &&
+	    current->thread.regs &&
 	    MSR_TM_ACTIVE(current->thread.regs->msr)) {
 		tm_enable();
 		tm_abort(TM_CAUSE_TLBI);


