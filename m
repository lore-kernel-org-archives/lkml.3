Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952Ab3GWWvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:51:18 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57189 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934560Ab3GWWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <0104420@agluck-desk.sc.intel.com>
References: <0104420@agluck-desk.sc.intel.com>
Date: Tue, 23 Jul 2013 15:51:14 -0700
Message-ID: <CA+8MBbLkWZKwG40XMXCV75Vr=6pKq9rijRamt7=qALhc72SCTQ@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
From: Tony Luck <tony.luck@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gah ... there is another bug in that unaffected thread entry.  The check for
MCG_STATUS should be for RIPV=1 *and* EIPV=0

gmail will mess this patch up ... but should still be readable.

-Tony

---

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c
b/arch/x86/kernel/cpu/mcheck/mce-severity
index 7f6ab4e..48f0fd2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -112,7 +112,7 @@ static struct severity {
        MCESEV(
                KEEP, "Action required but unaffected thread is continuable",
                SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR,
MCI_UC_SAR|MCI_ADDR),
-               MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
+               MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, MCG_STATUS_RIPV)
                ),
        MCESEV(
                AR, "Action required: data load error in a user process",
