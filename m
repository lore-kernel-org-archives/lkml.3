Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3FJEMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:12:15 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55386 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3FJEMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:12:13 -0400
Message-ID: <51B55218.9040401@gmail.com>
Date: Sun, 09 Jun 2013 23:12:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-5-git-send-email-sboyd@codeaurora.org> <20130603093938.GG18614@n2100.arm.linux.org.uk> <51AD069F.1060308@codeaurora.org> <20130603221210.GO18614@n2100.arm.linux.org.uk> <51AD483F.2010206@codeaurora.org> <20130604102114.GU18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130604102114.GU18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 05:21 AM, Russell King - ARM Linux wrote:
> On Mon, Jun 03, 2013 at 06:51:59PM -0700, Stephen Boyd wrote:
>> On 06/03/13 15:12, Russell King - ARM Linux wrote:
>>> If you have a 56-bit clock which ticks at a period of 1ns, then
>>> cd.rate = 1, and your sched_clock() values will be truncated to 56-bits.
>>> The scheduler always _requires_ 64-bits from sched_clock.  That's why we
>>> have the complicated code to extend the 32-bits-or-less to a _full_
>>> 64-bit value.
>>>
>>> Let me make this clearer: sched_clock() return values _must_ without
>>> exception monotonically increment from zero to 2^64-1 and then wrap
>>> back to zero.  No other behaviour is acceptable for sched_clock().
>>
>> Ok so you're saying if we have less than 64 bits of useable information
>> we _must_ do something to find where the wraparound will occur and
>> adjust for it so that epoch_ns is always incrementing until 2^64-1. Fair
>> enough. I was trying to avoid more work because on arm architected timer
>> platforms it takes many years for that to happen.
>>
>> I'll see what I can do.
> 
> Well, 56 bits at 1ns intervals is 833 days (2^56 / (1000000000*60*60*24)).
> We used to say that 497 days was enough several years ago, and that got
> fixed.  We used to say 640K was enough memory for anything, and that
> got fixed.

The ARM ARM states a minimum resolution of 40 years AND at least 56-bits
of resolution. So a 1Gz counter would have to have more that 56 bits.

Rob

