Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3AYJE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:04:27 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64506 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3AYJET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:04:19 -0500
MIME-Version: 1.0
In-Reply-To: <1359104204.12502.101.camel@smile>
References: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
	<1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nnrEo69W7sBES85KgF0+WUy8Ouoq+SG1XiB54e7QLiow@mail.gmail.com>
	<1359104204.12502.101.camel@smile>
Date: Fri, 25 Jan 2013 11:04:17 +0200
Message-ID: <CAHp75Vex-t=q4aQtBsJHiu-r8u98UDPvcbgQi3Z+42dkQWL+YA@mail.gmail.com>
Subject: Re: [PATCH v3.5] dw_dmac: return proper residue value
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:56 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Fri, 2013-01-25 at 09:43 +0530, Viresh Kumar wrote:
>> On Thu, Jan 24, 2013 at 6:37 PM, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:

>> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> > +static inline u32 dwc_get_residue(struct dw_dma_chan *dwc)
>> > +{
>> > +       unsigned long flags;
>> > +       u32 residue;
>> > +
>> > +       spin_lock_irqsave(&dwc->lock, flags);
>> > +
>> > +       residue = dwc->residue;
>>
>> you need to release the lock just here.
>>
>> > +       if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags) && residue)
>> > +               residue -= dwc_get_sent(dwc);
>>
>> why do you need lock while reading the control registers? It looks you didn't
>> get what i wanted to say earlier. We are using locks to protect some part for
>> shared data or critical sections. these are playing with dwc transfer
>> lists, etc..
>>
>> Probably we don't need a lock to read the control register as nobody can
>> guarantee that another access is not happening currently. As hardware is
>> changing this register continuously for the transfer.
>>
>> Let me know if i am missing something.

Okay, we have to have a protection here because get_sent reads two
registers consequentially. This means we could end up with scenario
with threads 1 and 2

1. read ctlhi
2. write ctlhi
2. write ctllo
1. read ctllo


-- 
With Best Regards,
Andy Shevchenko
