Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3LIXP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:15:28 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50682 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3LIXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:15:21 -0500
Date: Mon, 9 Dec 2013 16:15:15 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Tang, Feng" <feng.tang@intel.com>,
        "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in
 SFI/ACPI wrapper - acpi_disabled linkage.
Message-ID: <20131209231515.GA4699@google.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <cover.1386316208.git.lv.zheng@intel.com>
 <ba1e799968e59a07964a7e693d623b41e6d62110.1386316208.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024950DB@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024950DB@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:53:00PM +0000, Zheng, Lv wrote:
> Hi,
> 
> > From: Zheng, Lv
> > Sent: Friday, December 06, 2013 4:52 PM
> > To: Wysocki, Rafael J; Brown, Len
> > 
> > In Linux kernel, ACPICA is wrapped and safely exported by CONFIG_ACPI.  So
> > all external modules should depend on CONFIG_ACPI rather than using ACPICA
> > header directly for stubbing.  But if we moves <acpi/acpi.h> inclusions
> > into "#ifdef CONFIG_ACPI", build breakge can help to detect wrong ACPICA
> > dependent modules.
> > 
> > One of the build breakage is:
> > arch/x86/pci/mmconfig-shared.c:389:1: error: unknown type name 'acpi_status'
> > arch/x86/pci/mmconfig-shared.c:389:47: warning: 'struct acpi_resource' declared inside parameter list [enabled by default]
> > arch/x86/pci/mmconfig-shared.c:389:47: warning: its scope is only this definition or declaration, which is probably not what you want
> > [enabled by default]
> > arch/x86/pci/mmconfig-shared.c: In function 'check_mcfg_resource':
> > arch/x86/pci/mmconfig-shared.c:392:33: error: storage size of 'address' isn't known
> > arch/x86/pci/mmconfig-shared.c:393:2: error: unknown type name 'acpi_status'
> > arch/x86/pci/mmconfig-shared.c:395:9: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:395:19: error: 'ACPI_RESOURCE_TYPE_FIXED_MEMORY32' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c:395:19: note: each undeclared identifier is reported only once for each function it appears in
> > arch/x86/pci/mmconfig-shared.c:397:8: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:399:11: error: 'AE_OK' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c:400:35: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:401:33: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:402:19: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:404:11: error: 'AE_CTRL_TERMINATE' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c:407:10: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:407:20: error: 'ACPI_RESOURCE_TYPE_ADDRESS32' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c:408:10: error: dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig-shared.c:408:20: error: 'ACPI_RESOURCE_TYPE_ADDRESS64' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c:411:2: error: implicit declaration of function 'acpi_resource_to_address64' [-Werror=implicit-
> > function-declaration]
> > arch/x86/pci/mmconfig-shared.c:412:2: error: implicit declaration of function 'ACPI_FAILURE' [-Werror=implicit-function-declaration]
> > arch/x86/pci/mmconfig-shared.c:414:31: error: 'ACPI_MEMORY_RANGE' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c:392:33: warning: unused variable 'address' [-Wunused-variable]
> > arch/x86/pci/mmconfig-shared.c: At top level:
> > arch/x86/pci/mmconfig-shared.c:425:1: error: unknown type name 'acpi_status'
> > arch/x86/pci/mmconfig-shared.c:425:41: error: unknown type name 'acpi_handle'
> > arch/x86/pci/mmconfig-shared.c: In function 'is_acpi_reserved':
> > arch/x86/pci/mmconfig-shared.c:447:2: error: implicit declaration of function 'acpi_get_devices' [-Werror=implicit-function-
> > declaration]
> > arch/x86/pci/mmconfig-shared.c:447:30: error: 'find_mboard_resource' undeclared (first use in this function)
> > arch/x86/pci/mmconfig-shared.c: At top level:
> > arch/x86/pci/mmconfig-shared.c:389:20: warning: 'check_mcfg_resource' defined but not used [-Wunused-function]
> 
> Let me say something about this error messages.  Someone may face difficulties to reproduce it.
> Currently, this message cannot be seen in any kernel build.
> This is because this patch series doesn't include a fix to remove <acpi/acpi.h> inclusion from linux/sfi_acpi.h.
> To achieve this, I have offered 2 options:
> 1. Redefining ACPICA table stuff for CONFIG_ACPI=n environment, or
> 2. Implementing stubs for all ACPICA functions/globals/macros and introducing <linux/acpica.h> (where acpi/acpi.h is included) as a top level header.
> 3. Other solutions...
> 
> If we choose solution 1, then this issue is exposed by a build test where CONFIG_ACPI=n and CONFIG_SFI=y.
> Since we haven't decided what to do for the table structures and it is really not a good approach to achieve the build safety for mmconfig-share.c by relying on link-stage optimization rather than compile-stage referencing.  IMO, we need to sort it out, thus I make it a part of this patchset.
> 
> Well, if we choose solution 2, this patch can only help to reduce the size of the kernel image.

OK, I assume you will make sure one of these fixes gets merged before the
change that causes the breakage, so bisection continues to work.
Therefore, I think it's best if both changes are merged through the same
tree, and I won't apply this via the PCI tree.  Let me know if you need me
to do something.

Bjorn

> > 
> > The root cause of this breakage is:
> > 1. The following commit doesn't protect ACPICA functions like
> >    acpi_get_devices()/acpi_walk_resources()/acpi_resource_to_address64() in
> >    CONFIG_SFI=y and CONFIG_ACPI=n environment:
> >     Commit: 5f0db7a2fb78895a197f64e548333b3bbd433996
> >     Author: Feng Tang <feng.tang@intel.com>
> >     Subject: SFI: Hook PCI MMCONFIG
> >     First check ACPI, and if that fails, ask SFI to find the MCFG.
> >    So it actually depends on the logic that in !CONFIG_ACPI builds, code
> >    blocks under "if (!acpi_disabled)" will not be linked in.
> > 
> > This patch fixes this issue by introducing a stub for MCFG entry checker
> > is_acpi_reserved() in !CONFIG_ACPI builds.
> > 
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: Feng Tang <feng.tang@intel.com>
> > Cc: sfi-devel@simplefirmware.org
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  arch/x86/pci/mmconfig-shared.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> > index 248642f..2c04b22 100644
> > --- a/arch/x86/pci/mmconfig-shared.c
> > +++ b/arch/x86/pci/mmconfig-shared.c
> > @@ -369,6 +369,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
> >  	return !list_empty(&pci_mmcfg_list);
> >  }
> > 
> > +#ifdef CONFIG_ACPI
> >  static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
> >  {
> >  	struct resource *mcfg_res = data;
> > @@ -435,6 +436,12 @@ static int is_acpi_reserved(u64 start, u64 end, unsigned not_used)
> > 
> >  	return mcfg_res.flags;
> >  }
> > +#else
> > +static inline int is_acpi_reserved(u64 start, u64 end, unsigned not_used)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > 
> >  typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
> > 
> > --
> > 1.7.10
> 
