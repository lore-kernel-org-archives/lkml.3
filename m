Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaG2Qli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:41:38 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:44227 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaG2Qlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:41:37 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:2811:8aec:a585:9833]
In-Reply-To: <9hhvbqg1jra.fsf@arm.com>
References: <20140707140538.GA4204@himangi-Dell>
	<9hhwqb42k63.fsf@arm.com>
	<20140723150518.GD27677@arm.com>
	<9hhvbqg1jra.fsf@arm.com>
Date: Tue, 29 Jul 2014 09:41:36 -0700
Message-ID: <CAOesGMjUZgvpMoKivoZcAsMTZbfBrBToRPZmQyQNLHtxWNa5wA@mail.gmail.com>
Subject: Re: [PATCH] drivers: CCI: Correct use of ! and &
From: Olof Johansson <olof@lixom.net>
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Himangi Saraogi <himangi774@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 4:34 AM, Punit Agrawal <punit.agrawal@arm.com> wrote:
> Hi Arnd,
>
> Will Deacon <will.deacon@arm.com> writes:
>
>> On Wed, Jul 23, 2014 at 04:01:56PM +0100, Punit Agrawal wrote:
>>> > diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
>>> > index 5a86da9..7af78df 100644
>>> > --- a/drivers/bus/arm-cci.c
>>> > +++ b/drivers/bus/arm-cci.c
>>> > @@ -397,7 +397,8 @@ static irqreturn_t pmu_handle_irq(int irq_num, void *dev)
>>> >            hw_counter = &event->hw;
>>> >
>>> >            /* Did this counter overflow? */
>>> > -          if (!pmu_read_register(idx, CCI_PMU_OVRFLW) & CCI_PMU_OVRFLW_FLAG)
>>> > +          if (!(pmu_read_register(idx, CCI_PMU_OVRFLW) &
>>> > +                CCI_PMU_OVRFLW_FLAG))
>>> >                    continue;
>>>
>>>
>>> Going back to the manual, this fix looks correct.
>>>
>>> Acked-by: Punit Agrawal <punit.agrawal@arm.com>
>>>
>>> Will, would this go via your tree?
>>
>> Given that you're happy with it, I don't mind which tree it goes in.
>> Probably deserves a CC stable on it too.
>
> The CCI PMU patches went via arm-soc. Are you happy to pick this fix with
> the Ack and a Cc to stable.

Yeah, we've been merging most of the CCI patches.

Please resend the patch to arm@kernel.org if you want us to apply it.


Thanks,

-Olof
