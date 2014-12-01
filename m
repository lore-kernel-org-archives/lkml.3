Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaLALTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:19:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42291 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaLALTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:19:51 -0500
Message-ID: <547C4ECD.20802@arm.com>
Date: Mon, 01 Dec 2014 11:19:41 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Liviu Dudau <Liviu.Dudau@arm.com>
CC: Rob Herring <robh+dt@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Allow interrupt level to be set for PPIs.
References: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com> <20141201104145.GY3836@n2100.arm.linux.org.uk> <20141201104612.GM828@e106497-lin.cambridge.arm.com> <20141201110358.GA3836@n2100.arm.linux.org.uk>
In-Reply-To: <20141201110358.GA3836@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 01/12/14 11:03, Russell King - ARM Linux wrote:
> On Mon, Dec 01, 2014 at 10:46:13AM +0000, Liviu Dudau wrote:
>> On Mon, Dec 01, 2014 at 10:41:45AM +0000, Russell King - ARM Linux wrote:
>>> On Fri, Nov 28, 2014 at 05:55:40PM +0000, Liviu Dudau wrote:
>>>> +	/*
>>>> +	 * PPIs are optionally configurable, but we cannot distinguish
>>>> +	 * between high and low, nor falling and rising. Change the
>>>> +	 * type so that it passes the next check.
>>>
>>> This comment could do with a /lot/ of improvement.  It sounds like the
>>> only reason this code exists is to bypass the check.  If that's all
>>> that's being done, there's better ways to code it.
>>
>> Hi Russell,
>>
>> You are right, all I want to do is bypass the next check because *if*
>> the PPIs can be configured, then any combination is valid (edge 
>> raising/falling, level low/high). In real systems, PPIs tend to be
>> configured with active level low. That falls the existing check.
> 
>  "fails" :)
> 
> If all you want to do is to bypass the following check, what's wrong
> with actually doing that:
> 
> -	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
> +	if (gicirq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
> +	    type != IRQ_TYPE_EDGE_RISING)
> 		return -EINVAL;
> 

I think that will require some additional changes to gic_configure_irq
(in irq-gic-common.c).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
