Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaEHI7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:59:17 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64068 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaEHI7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:59:14 -0400
Date: Thu, 8 May 2014 10:59:05 +0200
From: Robert Richter <rric@kernel.org>
To: suravee.suthikulpanit@amd.com
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V3 1/3] x86/PCI: Fix PCI root numa_node info on AMD
 family15h
Message-ID: <20140508085905.GK32718@rric.localhost>
References: <1399489127-6961-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1399489127-6961-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399489127-6961-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.14 13:58:45, suravee.suthikulpanit@amd.com wrote:
> @@ -113,10 +122,17 @@ static int __init early_fill_mp_bus_info(void)
>  		info = alloc_pci_root_info(min_bus, max_bus, node, link);
>  	}
>  
> +	/*
> +	 * The following code is only supported until Fam11h.
> +	 * Newer processors will depend on ACPI MCFG table instead.
> +	 */
> +	if (boot_cpu_data.x86 > 0x11)
> +		return 0;
> +
>  	/* get the default node and link for left over res */

As this is the only substantial change of your patch, I would better
drop ther rest or at least split it in two patches. Should this change
also be for stable?

-Robert
