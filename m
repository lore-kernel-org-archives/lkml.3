Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3DOWYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:24:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12723 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361Ab3DOWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:24:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/66G4wd9hGfErVmNiCDz0OJirSUCzH4QU=
Date: Mon, 15 Apr 2013 13:56:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: rob.herring@calxeda.com, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, linus.walleij@linaro.org,
        thierry.reding@avionic-design.de, Liviu.Dudau@arm.com,
        grant.likely@secretlab.ca, paulus@samba.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        jg1.han@samsung.com, jgunthorpe@obsidianresearch.com,
        thomas.abraham@linaro.org, benh@kernel.crashing.org, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, suren.reddy@samsung.com
Subject: Re: [PATCH v6 0/3] of/pci: Provide common support for PCI DT
 parsing
Message-ID: <20130415175641.GM28693@titan.lakedaemon.net>
References: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Murray, Thomas,

On Thu, Apr 11, 2013 at 04:26:06PM +0100, Andrew Murray wrote:
> This patchset factors out duplicated code associated with parsing PCI
> DT "ranges" properties across the architectures and introduces a
> "ranges" parser. This parser "of_pci_range_parser" can be used directly
> by ARM host bridge drivers enabling them to obtain ranges from device
> trees.
> 
> I've included the Reviewed-by and Tested-by's received from v5 in this
> patchset, earlier versions of this patchset (v3) have been tested-by:
> 
> Thierry Reding <thierry.reding@avionic-design.de>
> Jingoo Han <jg1.han@samsung.com>
> 
> I believe a version of this patchset has also been tested through its
> inclusion in Thomas Petazzoni's Armada 370 and Armada XP SoCs PCIe support by:
> 
> Linus Walleij <linus.walleij@linaro.org>
> 
> I've tested that this patchset builds and runs on ARM and that it builds on
> PowerPC.
> 
> Compared to the v5 sent by Andrew Murray, the following changes have
> been made:
> 
>  * Use of CONFIG_64BIT instead of CONFIG_[a32bitarch] as suggested by
>    Rob Herring in drivers/of/of_pci.c
> 
>  * Added forward declaration of struct pci_controller in linux/of_pci.h
>    to prevent compiler warning as suggested by Thomas Petazzoni
> 
>  * Improved error checking (!range check), removal of unnecessary be32_to_cpup
>    call, improved formatting of struct of_pci_range_parser layout and
>    replacement of macro with a static inline. All suggested by Rob Herring.
> 
> Compared to the v4 (incorrectly labelled v3) sent by Andrew Murray,
> the following changes have been made:
> 
>  * Split the patch as suggested by Rob Herring
> 
> Compared to the v3 sent by Andrew Murray, the following changes have
> been made:
> 
>  * Unify and move duplicate pci_process_bridge_OF_ranges functions to
>    drivers/of/of_pci.c as suggested by Rob Herring
> 
>  * Fix potential build errors with Microblaze/MIPS
> 
> Compared to "[PATCH v5 01/17] of/pci: Provide support for parsing PCI DT
> ranges property", the following changes have been made:
> 
>  * Correct use of IORESOURCE_* as suggested by Russell King
> 
>  * Improved interface and naming as suggested by Thierry Reding
> 
> Compared to the v2 sent by Andrew Murray, Thomas Petazzoni did:
> 
>  * Add a memset() on the struct of_pci_range_iter when starting the
>    for loop in for_each_pci_range(). Otherwise, with an uninitialized
>    of_pci_range_iter, of_pci_process_ranges() may crash.
> 
>  * Add parenthesis around 'res', 'np' and 'iter' in the
>    for_each_of_pci_range macro definitions. Otherwise, passing
>    something like &foobar as 'res' didn't work.
> 
>  * Rebased on top of 3.9-rc2, which required fixing a few conflicts in
>    the Microblaze code.
> 
> v2:
>   This follows on from suggestions made by Grant Likely
>   (marc.info/?l=linux-kernel&m=136079602806328)
> 
> Andrew Murray (3):
>   of/pci: Unify pci_process_bridge_OF_ranges from Microblaze and
>     PowerPC
>   of/pci: Provide support for parsing PCI DT ranges property
>   of/pci: mips: convert to common of_pci_range_parser
> 
>  arch/microblaze/include/asm/pci-bridge.h |    5 +-
>  arch/microblaze/pci/pci-common.c         |  192 ------------------------------
>  arch/mips/pci/pci.c                      |   50 +++------
>  arch/powerpc/include/asm/pci-bridge.h    |    5 +-
>  arch/powerpc/kernel/pci-common.c         |  192 ------------------------------
>  drivers/of/address.c                     |   66 ++++++++++
>  drivers/of/of_pci.c                      |  168 ++++++++++++++++++++++++++
>  include/linux/of_address.h               |   46 +++++++
>  include/linux/of_pci.h                   |    4 +
>  9 files changed, 302 insertions(+), 426 deletions(-)

As agreed with Rob Herring, series applied to mvebu/drivers to support
mvebu pcie driver.

thx,

Jason.
