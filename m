Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaB1AJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:09:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59207 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB1AJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:09:53 -0500
Message-ID: <530FD3CF.2040900@codeaurora.org>
Date: Thu, 27 Feb 2014 16:09:51 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sebastian Capella <sebastian.capella@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7Zu?= =?UTF-8?B?aWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v6 2/2] ARM hibernation / suspend-to-disk
References: <1393545478-14908-1-git-send-email-sebastian.capella@linaro.org> <1393545478-14908-3-git-send-email-sebastian.capella@linaro.org>
In-Reply-To: <1393545478-14908-3-git-send-email-sebastian.capella@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/14 15:57, Sebastian Capella wrote:
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 8756e4b..1079ea8 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -291,6 +291,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>   */
>  #define __pa(x)			__virt_to_phys((unsigned long)(x))
>  #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
> +#define __pa_symbol(x)		__pa(RELOC_HIDE((unsigned long)(x), 0))

Just curious, is there a reason for the RELOC_HIDE() here? Or
__pa_symbol() for that matter? It looks like only x86 uses this on the
__nosave_{begin,end} symbol. Maybe it's copy-pasta?

I also wonder if anyone has thought about making a __weak
pfn_is_nosave() function so that architectures don't need to implement
the same thing every time. Consolidating those shouldn't be part of this
patch though.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

