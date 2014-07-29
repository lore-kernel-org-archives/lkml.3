Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaG2Lfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:35:54 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51651 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751234AbaG2Lfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:35:53 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: arm@kernel.org, arnd@arndb.de
Cc: Himangi Saraogi <himangi774@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall\@lip6.fr" <julia.lawall@lip6.fr>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] drivers: CCI: Correct use of ! and &
References: <20140707140538.GA4204@himangi-Dell> <9hhwqb42k63.fsf@arm.com>
	<20140723150518.GD27677@arm.com>
Date: Tue, 29 Jul 2014 12:34:17 +0100
In-Reply-To: <20140723150518.GD27677@arm.com> (Will Deacon's message of "Wed,
	23 Jul 2014 16:05:18 +0100")
Message-ID: <9hhvbqg1jra.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Will Deacon <will.deacon@arm.com> writes:

> On Wed, Jul 23, 2014 at 04:01:56PM +0100, Punit Agrawal wrote:
>> > diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
>> > index 5a86da9..7af78df 100644
>> > --- a/drivers/bus/arm-cci.c
>> > +++ b/drivers/bus/arm-cci.c
>> > @@ -397,7 +397,8 @@ static irqreturn_t pmu_handle_irq(int irq_num, void *dev)
>> >  		hw_counter = &event->hw;
>> >  
>> >  		/* Did this counter overflow? */
>> > -		if (!pmu_read_register(idx, CCI_PMU_OVRFLW) & CCI_PMU_OVRFLW_FLAG)
>> > +		if (!(pmu_read_register(idx, CCI_PMU_OVRFLW) &
>> > +		      CCI_PMU_OVRFLW_FLAG))
>> >  			continue;
>> 
>> 
>> Going back to the manual, this fix looks correct.
>> 
>> Acked-by: Punit Agrawal <punit.agrawal@arm.com>
>> 
>> Will, would this go via your tree?
>
> Given that you're happy with it, I don't mind which tree it goes in.
> Probably deserves a CC stable on it too.

The CCI PMU patches went via arm-soc. Are you happy to pick this fix with
the Ack and a Cc to stable.

Cheers,
Punit

>
> If you get stuck, put it in rmk's patch system.
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
