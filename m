Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354Ab3BNLzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:55:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1426 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715Ab3BNLzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:55:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Feb 2013 03:55:02 -0800
Message-ID: <511CD0A1.70606@nvidia.com>
Date: Thu, 14 Feb 2013 17:25:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap: irq: do not write mask register if it is
 not supported
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com> <1360761290-15976-2-git-send-email-ldewangan@nvidia.com> <20130213142036.GJ5062@opensource.wolfsonmicro.com> <511CC520.8050104@nvidia.com> <20130214113531.GC13249@opensource.wolfsonmicro.com>
In-Reply-To: <20130214113531.GC13249@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013 05:05 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Feb 14, 2013 at 04:36:08PM +0530, Laxman Dewangan wrote:
>> On Wednesday 13 February 2013 07:50 PM, Mark Brown wrote:
>>>>   	for (i = 0; i < d->chip->num_regs; i++) {
>>>> +		if (!d->chip->mask_base)
>>>> +			goto skip_mask_reg_update;
>>> Why is this inside the loop?
> You appear to have ignored this question.

I have accepted this to put out of loop.
Originally  thought that Inside loop, there is two register update one 
is mask and other is wakup. If I ignore the loop for mask_base= 0 then 
probably wake_ register will not get updated and hence it is inside the 
loop to update the wake register. If there is wake_base is 0 then this 
register update will be ignored anyhow.



>
>>> I'd also expect us to return an error if a caller tries to enable or
>>> disable an interrupt, or possibly to give different ops to the IRQ
>>> subsystem, rather than just silently claim we did what we were asked.
> if I remove the mask_buf at all then how do we tell the int_sts
> register is corresponding to which gpio handler?
> This doesn't sound like something that should be open coded in
> individual interrupt controller drivers, obviously it's a bit rubbish
> that there's no way to enable or disable the interrupt but presumably
> other hardware has the same "feature" and the IRQ subsystem ought to
> understand it.
>

To support such case, can we assume that mask is always enabled 
(interrupt enabled) so that it can be use in irq_thread to mask the 
interrupt status. So during initialization, if there is no mask_base 
register then all mask_buf is such that it enabled interrupt.


