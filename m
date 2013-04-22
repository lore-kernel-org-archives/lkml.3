Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3DVQyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:54:31 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17533 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3DVQy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:54:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pNfbUvoVNIWySzvsHTw4vKKqtDiC2uZU=
Date: Mon, 22 Apr 2013 12:53:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        linus.walleij@linaro.org, thierry.reding@avionic-design.de,
        Liviu.Dudau@arm.com, grant.likely@secretlab.ca, juhosg@openwrt.org,
        paulus@samba.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, jg1.han@samsung.com,
        jgunthorpe@obsidianresearch.com, thomas.abraham@linaro.org,
        benh@kernel.crashing.org, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, suren.reddy@samsung.com
Subject: Re: [PATCH v8 0/3] of/pci: Provide common support for PCI DT
 parsing
Message-ID: <20130422165343.GE25724@titan.lakedaemon.net>
References: <1366627295-16964-1-git-send-email-Andrew.Murray@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366627295-16964-1-git-send-email-Andrew.Murray@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:41:32AM +0100, Andrew Murray wrote:
> This patchset factors out duplicated code associated with parsing PCI
> DT "ranges" properties across the architectures and introduces a
> "ranges" parser. This parser "of_pci_range_parser" can be used directly
> by ARM host bridge drivers enabling them to obtain ranges from device
> trees.
> 
> I've included the Reviewed-by, Tested-by and Acked-by's received from v5/v6/v7
> in this patchset, earlier versions of this patchset (v3) have been tested-by:
> 
> Thierry Reding <thierry.reding@avionic-design.de>
> Jingoo Han <jg1.han@samsung.com>
> 
> I've tested that this patchset builds and runs on ARM and that it builds on
> PowerPC, x86_64 and MIPS.

Andrew,

Unfortunately, the mvebu/drivers branch containing your series had to be
dropped from arm-soc for v3.10.  This was not due to your series, but
since arm-soc's granularity is branches, your series was caught in the
drop.

As the mvebu-pcie driver is now v3.11 material, I have taken the
opportunity to upgrade from your v7 patchset to v8.  You can find the
whole branch at mvebu-next/pcie.

mvebu-next/pcie *will* be rebased onto v3.9 once it drops.  Several
dependencies will be removed (since they will have been merged into
v3.9).

Once the rebase is done, I'll send a pull request to Arnd and Olof so we
can get as many cycles on -next as possible.

thx,

Jason.

> 
> Compared to the v7 sent by Andrew Murray, the following changes have been made
> (please note that the first patch is unchanged from v7):
> 
>  * Rename of_pci_range_parser to of_pci_range_parser_init and
>    of_pci_process_ranges to of_pci_range_parser_one as suggested by Grant
>    Likely.
> 
>  * Reverted back to using a switch statement instead of if/else in
>    pci_process_bridge_OF_ranges. Grant Likely highlighted this change from
>    the original code which was unnecessary.
> 
>  * Squashed in a patch provided by Gabor Juhos which fixes build errors on
>    MIPS found in the last patchset.
> 
> Compared to the v6 sent by Andrew Murray, the following changes have
> been made in response to build errors/warnings:
> 
>  * Inclusion of linux/of_address.h in of_pci.c as suggested by Michal
>    Simek to prevent compilation failures on Microblaze (and others) and his
>    ack.
> 
>  * Use of externs, static inlines and a typo in linux/of_address.h in response
>    to linker errors (multiple defination) on x86_64 as spotted by a kbuild test
>    robot on (jcooper/linux.git mvebu/drivers)
> 
>  * Add EXPORT_SYMBOL_GPL to of_pci_range_parser function to be consistent
>    with of_pci_process_ranges function
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
>  arch/mips/pci/pci.c                      |   51 +++-----
>  arch/powerpc/include/asm/pci-bridge.h    |    5 +-
>  arch/powerpc/kernel/pci-common.c         |  192 ------------------------------
>  drivers/of/address.c                     |   67 +++++++++++
>  drivers/of/of_pci.c                      |  173 +++++++++++++++++++++++++++
>  include/linux/of_address.h               |   48 ++++++++
>  include/linux/of_pci.h                   |    4 +
>  9 files changed, 313 insertions(+), 424 deletions(-)
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
