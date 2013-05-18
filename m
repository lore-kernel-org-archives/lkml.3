Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3EREzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 00:55:12 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:62778 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3EREzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 00:55:10 -0400
Message-ID: <519709AD.8010206@prisktech.co.nz>
Date: Sat, 18 May 2013 16:55:09 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, romieu@fr.zoreil.com
Subject: Re: [PATCHv7 0/3] Add support for velocity network driver on platform
 devices
References: <1368843825-14813-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1368843825-14813-1-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/13 14:23, Tony Prisk wrote:
> v7 changes:
> Forgot to merge a patch to fix an error with the pm ops changes. Apologies Dave.
>
> v6 changes:
> Remove more bus specific code from velocity_probe()
> Make velocity_(suspend/resume) accept a struct device *
> Simplify PM code to use velocity_(suspend/resume) - remove the individual
> pci and platform functions.
> Add a struct pci_dev variable to velocity_get_pci_info() to reduce churn
>
> v5 changes:
> Remove velocity_info union. Change velocity_info->pdev back to struct pci_dev.
> Remove more 'if (pci)' sections.
> Remove 'void *pdev' function parameters.
> Pass correct variable to velocity_choose_state()
>
> v4 changes:
> Code tidyup as requested by Francois Romieu
> Removed '#ifdef PCI' around PCI code. Compile tested on (!)PCI and (!)PM.
>
> v3 changes:
> Rebased against net-next.
> Fix errors in pm code.
>
> v2 changes:
> Drop patch #1 as requested by David Miller.
> Correct the PHYID_ICPLUS_IP101A MII bits - should be ON, rather than OFF.
> Read the platform rev_id from the correct register [regs->rev_id]. It's possible
> this would work for the PCI version as well and would remove the need for the
> 'if (pci)' test to set vptr->rev_id.
>
> v1:
> The first three patches are general tidyup.
>
> [DROPPED] Patch ## just alphabetizes the #includes to make it easier to read.
>
> Patch #1 replaces vptr->dev with vptr->netdev, in preparation of adding a
> struct device *dev in Patch #2
>
> Patch #2 replaces the pci dma functions with the generic versions.
>
> I have build tested these patches but don't have a PCI velocity to run-test it.
> I can't see that they should introduce any problems as it is all renames and
> function swapping.
>
> Patch #3 adds support for the velocity driver on devicetree platform devices.
> Binding document included. This patch is compile-tested for PCI, and boot
> tested on a VIA APC8750.
>
> I think it would be pertinent to get some tested-by's for PCI users.
>
> Regards
> Tony Prisk
>
>
> Tony Prisk (3):
>    net: velocity: Rename vptr->dev to vptr->netdev
>    net: velocity: Convert to generic dma functions
>    net: velocity: Add platform device support to VIA velocity driver
>
>   .../devicetree/bindings/net/via-velocity.txt       |   20 +
>   drivers/net/ethernet/via/Kconfig                   |    3 +-
>   drivers/net/ethernet/via/via-velocity.c            |  496 +++++++++++++-------
>   drivers/net/ethernet/via/via-velocity.h            |   35 +-
>   4 files changed, 376 insertions(+), 178 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/net/via-velocity.txt
>

Please don't apply this version either Dave.
I noticed that velocity_choose_state is defined in via-velocity.h but is 
never used.

Will resend v8.
