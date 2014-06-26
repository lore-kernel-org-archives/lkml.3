Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbaFZATP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:19:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55786 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFZATO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:19:14 -0400
Message-ID: <53AB6700.2060807@codeaurora.org>
Date: Wed, 25 Jun 2014 17:19:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>
CC: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/9] ARM: kernel: add support for cpu cache information
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-9-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1403717444-23559-9-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/14 10:30, Sudeep Holla wrote:
> +
> +/*
> + * Which cache CCSIDR represents depends on CSSELR value
> + * Make sure no one else changes CSSELR during this
> + * smp_call_function_single prevents preemption for us
> + */

Where's the smp_call_function_single() or preemption disable happening?

> +static inline u32 get_ccsidr(u32 csselr)
> +{
> +	u32 ccsidr;
> +
> +	/* Put value into CSSELR */
> +	asm volatile ("mcr p15, 2, %0, c0, c0, 0" : : "r" (csselr));
> +	isb();
> +	/* Read result out of CCSIDR */
> +	asm volatile ("mrc p15, 1, %0, c0, c0, 0" : "=r" (ccsidr));
> +
> +	return ccsidr;
> +}
> +

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

