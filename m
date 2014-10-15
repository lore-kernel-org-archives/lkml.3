Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaJORGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:17 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:63672 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJORGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:12 -0400
Subject: [PATCH v1 04/10] MIPS: Remove "weak" from platform_maar_init()
 declaration
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:09 -0600
Message-ID: <20141015170609.4063.10668.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/mips/mm/init.c provides a default platform_maar_init() definition
explicitly marked "weak".  arch/mips/mti-malta/malta-memory.c provides its
own definition intended to override the default, but the "weak" attribute
on the declaration applied to this as well, so the linker chose one based
on link order (see 10629d711ed7 ("PCI: Remove __weak annotation from
pcibios_get_phb_of_node decl")).

Remove the "weak" attribute from the declaration so we always prefer a
non-weak definition over the weak one, independent of link order.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-mips@linux-mips.org
---
 arch/mips/include/asm/maar.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/maar.h b/arch/mips/include/asm/maar.h
index 6c62b0f899c0..b02891f9caaf 100644
--- a/arch/mips/include/asm/maar.h
+++ b/arch/mips/include/asm/maar.h
@@ -26,7 +26,7 @@
  *
  * Return:	The number of MAAR pairs configured.
  */
-unsigned __weak platform_maar_init(unsigned num_pairs);
+unsigned platform_maar_init(unsigned num_pairs);
 
 /**
  * write_maar_pair() - write to a pair of MAARs

