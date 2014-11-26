Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaKZB1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:27:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaKZB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:27:41 -0500
Message-ID: <54752C8A.1070006@codeaurora.org>
Date: Tue, 25 Nov 2014 17:27:38 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        John Stultz <john.stultz@linaro.org>, Tim Sander <tim@krieglstein.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3.18-rc3 v9 1/5] irqchip: gic: Finer grain locking for
 gic_raise_softirq
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-2-git-send-email-daniel.thompson@linaro.org> <5474BF19.3040707@arm.com> <alpine.LFD.2.11.1411251510231.11690@knanqh.ubzr> <5474F05E.90401@linaro.org>
In-Reply-To: <5474F05E.90401@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:10 PM, Daniel Thompson wrote:
> On 25/11/14 20:17, Nicolas Pitre wrote:
>> On Tue, 25 Nov 2014, Marc Zyngier wrote:
>>
>>> Hi Daniel,
>>>
>>> On 25/11/14 17:26, Daniel Thompson wrote:
>>>> irq_controller_lock is used for multiple purposes within the gic driver.
>>>> Primarily it is used to make register read-modify-write sequences atomic.
>>>> It is also used by gic_raise_softirq() in order that the big.LITTLE
>>>> migration logic can figure out when it is safe to migrate interrupts
>>>> between physical cores.
>>>>
>>>> The second usage of irq_controller_lock is difficult to discern when
>>>> reviewing the code because the migration itself takes place outside
>>>> the lock.
>>>>
>>>> This patch makes the second usage more explicit by splitting it out into
>>>> a separate lock and providing better comments.
>>> While we're at it, how about an additional patch that would make this
>>> lock disappear entirely when the big-little stuff is not compiled in,
>>> which is likely to be the case on a lot of (dare I say most?) systems?
>>> That will save expensive barriers that we definitely could do without.
>> For the record, I reviewed and ACKed a patch doing exactly that a while
>> ago:
>>
>> http://lkml.org/lkml/2014/8/13/486
> Well remembered! That patch had a different motivation but is very
> similar to mine... so much so I might steal bit of it.
>
> I'll make sure I put Stephen on Cc: when I respin with the changes Marc
> requested.

I don't get a random Cc here? :-)

Anyway, yes please let's merge that patch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

