Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaDPS1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:27:30 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63084 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbaDPS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140416101323.GP12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
	<1397592876-5741-3-git-send-email-dianders@chromium.org>
	<20140416095922.GG4754@lee--X1>
	<20140416101323.GP12304@sirena.org.uk>
Date: Wed, 16 Apr 2014 11:27:25 -0700
X-Google-Sender-Auth: ZKe5T3TooUOa51YKMS_Z91j7CPo
Message-ID: <CAD=FV=WRJgWVB4TjHa04JjH6XBbPf1-SeV5Y+QXo=uGU8FYKdw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: tps65090: Stop caching registers
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Anton Vorontsov <anton@enomsg.org>,
        Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Apr 16, 2014 at 3:13 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Apr 16, 2014 at 10:59:22AM +0100, Lee Jones wrote:
>
>> > NOTE: the IRQnMASK and CG_CTRLn registers are the exception and could
>> > be cached.  If we find that we spend a lot of time reading those we
>> > can turn on cache for just those registers.
>
>> > -static bool is_volatile_reg(struct device *dev, unsigned int reg)
>> > -{
>> > -   if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS2))
>> > -           return true;
>> > -   else
>> > -           return false;
>> > -}
>> > -
>
>> I don't know enough about Regmap internals to know what this actually
>> affects in real terms.
>
>> Mark,
>>   Does this change seem sane to you?
>
> It does what it says, it stops us caching stuff.  It would seem better
> to do what the changelog suggests above and keep caching the registers
> that can be cached - especially the interrupt masks, they should get
> read in the interrupt path and that tends to be a bit latency sensitive.

Done
