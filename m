Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab3E3WL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:11:27 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:47134 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab3E3WLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:11:22 -0400
Date: Thu, 30 May 2013 16:10:54 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH] arm: Prevent memory aliasing on non-LPAE kernels
Message-ID: <20130530221054.GA31643@obsidianresearch.com>
References: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:45:20PM -0700, Stepan Moskovchenko wrote:
>  void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
> +#ifndef CONFIG_ARM_LPAE
> +	if (base > ((phys_addr_t)~0)) {

The #ifdef is probably not necessary here, simply checking that
base/size can be represented in a phys_addr_t is enough.

> +		pr_crit("Ignoring memory at 0x%08llx due to lack of LPAE support\n",
> +			base);
> +		return;
> +	}
> +
> +	if (size > ((phys_addr_t)~0))
> +		size = ((phys_addr_t)~0);

A similar printk as arm_add_memory for this one too?

                printk(KERN_CRIT "Truncating memory at 0x%08llx to fit in "
                        "32-bit physical address space\n", (long long)start);

Regards,
Jason
