Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3LLBZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:25:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57722 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751377Ab3LLBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:25:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Tang, Feng" <feng.tang@intel.com>,
        "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI wrapper - acpi_disabled linkage.
Date: Thu, 12 Dec 2013 02:38:21 +0100
Message-ID: <2140164.VX2WIofybX@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131209231515.GA4699@google.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <1AE640813FDE7649BE1B193DEA596E88024950DB@SHSMSX101.ccr.corp.intel.com> <20131209231515.GA4699@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 09, 2013 04:15:15 PM Bjorn Helgaas wrote:
> On Fri, Dec 06, 2013 at 02:53:00PM +0000, Zheng, Lv wrote:
> > Hi,
> > 
> > > From: Zheng, Lv
> > > Sent: Friday, December 06, 2013 4:52 PM
> > > To: Wysocki, Rafael J; Brown, Len
> > > 
> > > In Linux kernel, ACPICA is wrapped and safely exported by CONFIG_ACPI.  So
> > > all external modules should depend on CONFIG_ACPI rather than using ACPICA
> > > header directly for stubbing.  But if we moves <acpi/acpi.h> inclusions
> > > into "#ifdef CONFIG_ACPI", build breakge can help to detect wrong ACPICA
> > > dependent modules.
> > > 
> > > One of the build breakage is:
> > > arch/x86/pci/mmconfig-shared.c:389:1: error: unknown type name 'acpi_status'
> > > arch/x86/pci/mmconfig-shared.c:389:47: warning: 'struct acpi_resource' declared inside parameter list [enabled by default]
> > > arch/x86/pci/mmconfig-shared.c:389:47: warning: its scope is only this definition or declaration, which is probably not what you want
> > > [enabled by default]
> > > arch/x86/pci/mmconfig-shared.c: In function 'check_mcfg_resource':
> > > arch/x86/pci/mmconfig-shared.c:392:33: error: storage size of 'address' isn't known
> > > arch/x86/pci/mmconfig-shared.c:393:2: error: unknown type name 'acpi_status'
> > > arch/x86/pci/mmconfig-shared.c:395:9: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:395:19: error: 'ACPI_RESOURCE_TYPE_FIXED_MEMORY32' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c:395:19: note: each undeclared identifier is reported only once for each function it appears in
> > > arch/x86/pci/mmconfig-shared.c:397:8: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:399:11: error: 'AE_OK' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c:400:35: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:401:33: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:402:19: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:404:11: error: 'AE_CTRL_TERMINATE' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c:407:10: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:407:20: error: 'ACPI_RESOURCE_TYPE_ADDRESS32' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c:408:10: error: dereferencing pointer to incomplete type
> > > arch/x86/pci/mmconfig-shared.c:408:20: error: 'ACPI_RESOURCE_TYPE_ADDRESS64' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c:411:2: error: implicit declaration of function 'acpi_resource_to_address64' [-Werror=implicit-
> > > function-declaration]
> > > arch/x86/pci/mmconfig-shared.c:412:2: error: implicit declaration of function 'ACPI_FAILURE' [-Werror=implicit-function-declaration]
> > > arch/x86/pci/mmconfig-shared.c:414:31: error: 'ACPI_MEMORY_RANGE' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c:392:33: warning: unused variable 'address' [-Wunused-variable]
> > > arch/x86/pci/mmconfig-shared.c: At top level:
> > > arch/x86/pci/mmconfig-shared.c:425:1: error: unknown type name 'acpi_status'
> > > arch/x86/pci/mmconfig-shared.c:425:41: error: unknown type name 'acpi_handle'
> > > arch/x86/pci/mmconfig-shared.c: In function 'is_acpi_reserved':
> > > arch/x86/pci/mmconfig-shared.c:447:2: error: implicit declaration of function 'acpi_get_devices' [-Werror=implicit-function-
> > > declaration]
> > > arch/x86/pci/mmconfig-shared.c:447:30: error: 'find_mboard_resource' undeclared (first use in this function)
> > > arch/x86/pci/mmconfig-shared.c: At top level:
> > > arch/x86/pci/mmconfig-shared.c:389:20: warning: 'check_mcfg_resource' defined but not used [-Wunused-function]
> > 
> > Let me say something about this error messages.  Someone may face difficulties to reproduce it.
> > Currently, this message cannot be seen in any kernel build.
> > This is because this patch series doesn't include a fix to remove <acpi/acpi.h> inclusion from linux/sfi_acpi.h.
> > To achieve this, I have offered 2 options:
> > 1. Redefining ACPICA table stuff for CONFIG_ACPI=n environment, or
> > 2. Implementing stubs for all ACPICA functions/globals/macros and introducing <linux/acpica.h> (where acpi/acpi.h is included) as a top level header.
> > 3. Other solutions...
> > 
> > If we choose solution 1, then this issue is exposed by a build test where CONFIG_ACPI=n and CONFIG_SFI=y.
> > Since we haven't decided what to do for the table structures and it is really not a good approach to achieve the build safety for mmconfig-share.c by relying on link-stage optimization rather than compile-stage referencing.  IMO, we need to sort it out, thus I make it a part of this patchset.
> > 
> > Well, if we choose solution 2, this patch can only help to reduce the size of the kernel image.
> 
> OK, I assume you will make sure one of these fixes gets merged before the
> change that causes the breakage, so bisection continues to work.
> Therefore, I think it's best if both changes are merged through the same
> tree, and I won't apply this via the PCI tree.  Let me know if you need me
> to do something.

We're doing our best not to break compilation between the patches in this
series.  And I'll take care of it. :-)

Thanks,
Rafael

