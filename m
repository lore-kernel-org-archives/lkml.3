Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaG3Kdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:33:42 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53250 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752096AbaG3Kdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:33:41 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "arm\@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Himangi Saraogi <himangi774@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall\@lip6.fr" <julia.lawall@lip6.fr>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] drivers: CCI: Correct use of ! and &
References: <20140707140538.GA4204@himangi-Dell> <9hhwqb42k63.fsf@arm.com>
	<20140723150518.GD27677@arm.com> <9hhvbqg1jra.fsf@arm.com>
	<CAOesGMjUZgvpMoKivoZcAsMTZbfBrBToRPZmQyQNLHtxWNa5wA@mail.gmail.com>
Date: Wed, 30 Jul 2014 11:32:45 +0100
In-Reply-To: <CAOesGMjUZgvpMoKivoZcAsMTZbfBrBToRPZmQyQNLHtxWNa5wA@mail.gmail.com>
	(Olof Johansson's message of "Tue, 29 Jul 2014 09:41:36 -0700")
Message-ID: <9hh61if6ss2.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson <olof@lixom.net> writes:

> On Tue, Jul 29, 2014 at 4:34 AM, Punit Agrawal <punit.agrawal@arm.com> wrote:
>> Hi Arnd,
>>
>> Will Deacon <will.deacon@arm.com> writes:
>>
>>> On Wed, Jul 23, 2014 at 04:01:56PM +0100, Punit Agrawal wrote:
>>>> > diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
>>>> > index 5a86da9..7af78df 100644
>>>> > --- a/drivers/bus/arm-cci.c
>>>> > +++ b/drivers/bus/arm-cci.c
>>>> > @@ -397,7 +397,8 @@ static irqreturn_t pmu_handle_irq(int irq_num, void *dev)
>>>> >            hw_counter = &event->hw;
>>>> >
>>>> >            /* Did this counter overflow? */
>>>> > -          if (!pmu_read_register(idx, CCI_PMU_OVRFLW) & CCI_PMU_OVRFLW_FLAG)
>>>> > +          if (!(pmu_read_register(idx, CCI_PMU_OVRFLW) &
>>>> > +                CCI_PMU_OVRFLW_FLAG))
>>>> >                    continue;
>>>>
>>>>
>>>> Going back to the manual, this fix looks correct.
>>>>
>>>> Acked-by: Punit Agrawal <punit.agrawal@arm.com>
>>>>
>>>> Will, would this go via your tree?
>>>
>>> Given that you're happy with it, I don't mind which tree it goes in.
>>> Probably deserves a CC stable on it too.
>>
>> The CCI PMU patches went via arm-soc. Are you happy to pick this fix with
>> the Ack and a Cc to stable.
>
> Yeah, we've been merging most of the CCI patches.
>
> Please resend the patch to arm@kernel.org if you want us to apply it.

Ok, thanks! I'll send the patch with the tags applied shortly.

>
>
> Thanks,
>
> -Olof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
