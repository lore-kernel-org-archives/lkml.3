Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaFTITj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:19:39 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47400 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaFTITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406201005400.5170@nanos>
References: <20140619212606.431750473@linutronix.de>
	<20140619212713.496614337@linutronix.de>
	<CAOh2x==trCJcQnzekEdcFoBb2i1Mc7hMsJq94iu2dzrZ=Xkeow@mail.gmail.com>
	<alpine.DEB.2.10.1406201005400.5170@nanos>
Date: Fri, 20 Jun 2014 13:49:36 +0530
Message-ID: <CAKohpom76zu0ec0rgcVH8J5hmAypS9WJ+i_bB43P3aFYzDW2Mw@mail.gmail.com>
Subject: Re: [patch 08/13] irqchip: spear_shirq: Precalculate status mask
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2014 13:36, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 20 Jun 2014, Viresh Kumar wrote:
>> On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > @@ -176,6 +186,7 @@ static struct spear_shirq spear320_shirq
>> >  static struct spear_shirq spear320_shirq_intrcomm_ras = {
>> >         .offset         = 11,
>> >         .nr_irqs        = 11,
>> > +       .mask           = ((0x1 << 11) - 1) << 11,
>> >         .regs = {
>> >                 .enb_reg = -1,
>> >                 .status_reg = SPEAR320_INT_STS_MASK_REG,
>>
>> If you like, maybe this instead of above diff:
>
> What's wrong with letting the compiler fill it in?

>> +               shirq_blocks[i]->mask = ((0x1 << shirq_blocks[i]->nr_irqs) - 1)
>> +                                       << shirq_blocks[i]->offset;

Just for better readability as it doesn't have magic numbers in it
and the performance impact wouldn't be much as its done just
once on boot.
