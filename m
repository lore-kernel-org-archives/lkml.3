Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3CLFbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:31:48 -0400
Received: from ozlabs.org ([203.10.76.45]:33139 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLFbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:31:46 -0400
From: Michael Neuling <mikey@neuling.org>
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: powerpc/eeh: Fix compile error due to missing include file
In-reply-to: <1362713395.3768.466.camel@deadeye.wl.decadent.org.uk>
References: <20130304033707.648729212@decadent.org.uk> <20130304033708.479195432@decadent.org.uk> <CAEjGV6z-d2f6G_bozJmaeg7pmK71uM_JjBZ24KgijnjO1wv+4g@mail.gmail.com> <1362713395.3768.466.camel@deadeye.wl.decadent.org.uk>
Comments: In-reply-to Ben Hutchings <ben@decadent.org.uk>
   message dated "Fri, 08 Mar 2013 03:29:55 -0000."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 12 Mar 2013 16:31:44 +1100
Message-ID: <28515.1363066304@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> wrote:

> On Fri, 2013-03-08 at 13:51 +1100, Michael Neuling wrote:
> > This patch is breaking the celleb_defconfig on powerpc with:
> > 
> > arch/powerpc/kernel/of_platform.c: In function 'of_pci_phb_probe':
> > arch/powerpc/kernel/of_platform.c:95:2: error: implicit declaration of
> > function 'eeh_add_sysfs_files' [-Werror=implicit-function-declaration]
> 
> In 3.2 this file doesn't (directly) include <asm/eeh.h> which is where
> the definition was added.  In mainline it does.
> 
> Assuming that this change is actually required for 3.2 (which I'm not
> sure about), I suppose we just need to add the #include.

Yep that fixes it.  Patch below (for stable 3.2 only)


From: Michael Neuling <mikey@neuling.org>
Subject: powerpc/eeh: Fix compile error due to missing include file

3.2.40 fails to compile the celleb_defconfig with the following error:

  arch/powerpc/kernel/of_platform.c: In function 'of_pci_phb_probe':
  arch/powerpc/kernel/of_platform.c:95:2: error: implicit declaration of function 'eeh_add_sysfs_files' [-Werror=implicit-function-declaration]

The following adds the required include file to fix this.

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index b10beef..601650f 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -26,6 +26,7 @@
 #include <asm/topology.h>
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
+#include <asm/eeh.h>
 #include <linux/atomic.h>
 
 #ifdef CONFIG_PPC_OF_PLATFORM_PCI
