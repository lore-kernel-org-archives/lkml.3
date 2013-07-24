Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3GXU3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:29:02 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GXU3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:29:01 -0400
Message-ID: <51F0390C.7090501@codeaurora.org>
Date: Wed, 24 Jul 2013 13:29:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix deadlock scenario with smp_send_stop()
References: <1373384217-26307-1-git-send-email-sboyd@codeaurora.org> <20130724185618.GD27761@codeaurora.org> <20130724202148.GA24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130724202148.GA24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/13 13:21, Russell King - ARM Linux wrote:
> On Wed, Jul 24, 2013 at 11:56:18AM -0700, Stephen Boyd wrote:
>> On 07/09, Stephen Boyd wrote:
>>> If one process calls sys_reboot and that process then stops other
>>> CPUs while those CPUs are within a spin_lock() region we can
>>> potentially encounter a deadlock scenario like below.
>>>
>>> CPU 0                   CPU 1
>>> -----                   -----
>>>                         spin_lock(my_lock)
>>> smp_send_stop()
>>>  <send IPI>             handle_IPI()
>>>                          disable_preemption/irqs
>>>                           while(1);
>>>  <PREEMPT>
>>> spin_lock(my_lock) <--- Waits forever
>>>
>>> We shouldn't attempt to run any other tasks after we send a stop
>>> IPI to a CPU so disable preemption so that this task runs to
>>> completion.
>>>
>>> Reported-by: Sundarajan Srinivasan <sundaraj@codeaurora.com>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>>
>>> Resending this patch now that the context has changed.
>> Ping? Shall I put this in the patch tracker?
> Well, looking at x86, they use local_irq_disable() before sending the
> stop, so I think we should do the same for cross-arch consistency.

Fair enough. I'll send v2 with that.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

