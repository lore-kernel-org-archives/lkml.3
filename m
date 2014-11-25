Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaKYVLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:11:06 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52942 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKYVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:11:04 -0500
Message-ID: <5474F05E.90401@linaro.org>
Date: Tue, 25 Nov 2014 21:10:54 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>
Subject: Re: [PATCH 3.18-rc3 v9 1/5] irqchip: gic: Finer grain locking for
 gic_raise_softirq
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-2-git-send-email-daniel.thompson@linaro.org> <5474BF19.3040707@arm.com> <alpine.LFD.2.11.1411251510231.11690@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1411251510231.11690@knanqh.ubzr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/14 20:17, Nicolas Pitre wrote:
> On Tue, 25 Nov 2014, Marc Zyngier wrote:
> 
>> Hi Daniel,
>>
>> On 25/11/14 17:26, Daniel Thompson wrote:
>>> irq_controller_lock is used for multiple purposes within the gic driver.
>>> Primarily it is used to make register read-modify-write sequences atomic.
>>> It is also used by gic_raise_softirq() in order that the big.LITTLE
>>> migration logic can figure out when it is safe to migrate interrupts
>>> between physical cores.
>>>
>>> The second usage of irq_controller_lock is difficult to discern when
>>> reviewing the code because the migration itself takes place outside
>>> the lock.
>>>
>>> This patch makes the second usage more explicit by splitting it out into
>>> a separate lock and providing better comments.
>>
>> While we're at it, how about an additional patch that would make this
>> lock disappear entirely when the big-little stuff is not compiled in,
>> which is likely to be the case on a lot of (dare I say most?) systems?
>> That will save expensive barriers that we definitely could do without.
> 
> For the record, I reviewed and ACKed a patch doing exactly that a while 
> ago:
> 
> http://lkml.org/lkml/2014/8/13/486

Well remembered! That patch had a different motivation but is very
similar to mine... so much so I might steal bit of it.

I'll make sure I put Stephen on Cc: when I respin with the changes Marc
requested.

