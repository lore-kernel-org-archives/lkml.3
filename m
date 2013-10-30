Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3J3NIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:08:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41960 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3J3NI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:08:28 -0400
Date: Wed, 30 Oct 2013 13:07:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        monstr@monstr.eu, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: Fix ECC mem policy printk
Message-ID: <20131030130728.GA16735@n2100.arm.linux.org.uk>
References: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:46:18PM +0100, Michal Simek wrote:
> Russell, Will: We discussed this at KS that will be good
> to rephrase it or have different logic around this.
> I am not sure if we can also test that this bit is
> implemented by particular SoC or not.
> 
> Maybe logic should be that if SoC uses this bit
> that message is shown in origin format to declare
> that ECC is enabled or disabled.
> When SoC doesn't implement it then do not show this message.

This is not quite what I meant - by making the change you have, you also
omit to print the data cache policy.

> @@ -556,8 +556,9 @@ static void __init build_mem_type_table(void)
>  		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_WB;
>  		break;
>  	}
> -	printk("Memory policy: ECC %sabled, Data cache %s\n",
> -		ecc_mask ? "en" : "dis", cp->policy);
> +	if (ecc_mask)
> +		pr_info("Memory policy: ECC enabled, Data cache %s\n",
> +			cp->policy);

	pr_info("Memory policy: %sData cache %s\n",
		ecc_mask ? "ECC enabled, " : "", cp->policy);

is more what I was suggesting.
