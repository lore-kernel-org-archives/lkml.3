Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3KHSxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:53:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34302 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab3KHSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:53:13 -0500
Message-ID: <527D3318.2050003@codeaurora.org>
Date: Fri, 08 Nov 2013 10:53:12 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org> <20131108095842.GG28304@ns203013.ovh.net> <20131108165223.GL16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131108165223.GL16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 08:52, Russell King - ARM Linux wrote:
> On Fri, Nov 08, 2013 at 10:58:42AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 11:20 Thu 07 Nov     , Stephen Boyd wrote:
>>> @@ -381,6 +384,13 @@ static void __init cpuid_init_hwcaps(void)
>>>  		elf_hwcap |= HWCAP_IDIVT;
>>>  	}
>>>  
>>> +#ifdef CONFIG_THUMB2_KERNEL
>> if (IS_ENABLED(CONFIG_THUMB2_KERNEL) && elf_hwcap & HWCAP_IDIVT)
>>> +	if (elf_hwcap & HWCAP_IDIVT)
>>> +#else
>>> +	if (elf_hwcap & HWCAP_IDIVA)
>>> +#endif
> Take another look, and you'll see the change that you're suggesting is
> wrong.  Instead, the following may be a more reasonable suggestion as
> a suitable replacement:
>
> 	if (elf_hwcap & (IS_ENABLED(CONFIG_THUMB2_KERNEL) ?
> 				HWCAP_IDIVT : HWCAP_IDIVA))

I can use IS_ENABLED() but I'd prefer a local variable to make it
simpler in the conditional.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

