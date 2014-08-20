Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaHTTLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:11:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44414 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHTTLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:11:15 -0400
Message-ID: <53F4F2D2.2050600@codeaurora.org>
Date: Wed, 20 Aug 2014 12:11:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net> <20140817185522.GX30401@n2100.arm.linux.org.uk> <20140817190434.GJ12769@titan.lakedaemon.net> <20140817214123.GY30401@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1408172005070.29347@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1408172005070.29347@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/14 17:17, Nicolas Pitre wrote:
> On Sun, 17 Aug 2014, Russell King - ARM Linux wrote:
>
>> I have no problem with changing gic_raise_softirq() to use a different
>> lock, which gic_migrate_target(), and gic_set_affinity() can also use.
>> There's no need for horrid locking here, because the only thing we're
>> protecting is gic_map[] and the write to the register to trigger an
>> IPI - and nothing using gic_arch_extn has any business knowing about
>> SGIs.
>>
>> No need for these crappy sgi_map_lock() macros and all the ifdeffery.
> Those macros are there only to conditionalize the locking in 
> gic_raise_softirq() because no locking what so ever is needed there when 
> gic_migrate_target() is configured out.  I suggested the macros to cut 
> down on the #ifdefery in the code.

Ok I can resend with the sgi lock around the gic_cpu_map updating code.
Let's see how v5 goes.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

