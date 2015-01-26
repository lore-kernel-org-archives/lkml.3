Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbbAZQEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:04:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:14262 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbAZQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:04:30 -0500
Message-ID: <54C66589.3040505@atmel.com>
Date: Mon, 26 Jan 2015 17:04:25 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Peter Rosin <peda@axentia.se>,
        Sylvain Rochet <sylvain.rochet@finsecur.com>,
        Wenyou Yang <wenyou.yang@atmel.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH v2 02/12] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com> <1422265139-23011-1-git-send-email-wenyou.yang@atmel.com> <20150126103605.GA20837@gradator.net> <54C6426E.9090808@atmel.com> <20150126134453.GA27559@gradator.net> <372b731350484f8ea1d29bd016421dfb@EMAIL.axentia.se>
In-Reply-To: <372b731350484f8ea1d29bd016421dfb@EMAIL.axentia.se>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/01/2015 16:58, Peter Rosin a écrit :
> Sylvain Rochet wrote:
>> Hello Nicolas,
>>
>> On Mon, Jan 26, 2015 at 02:34:38PM +0100, Nicolas Ferre wrote:
>>> Le 26/01/2015 11:36, Sylvain Rochet a écrit :
>>>>
>>>> I think we should explain we are dealing with an errata here, this
>>>> is not obvious at first sight, the patch summary may find its place
>>>> here :-)
>>>
>>> True but the problem is that this errata is not public yet, it will be
>>> in a couple of weeks.
>>>
>>> I have the feeling though that the commit message is pretty clear.
>>> We'll maybe add that it"s an actual errata.
>>
>> Humm, this is not what I meant actually. I only proposed a code source
>> comment explaining why this is done this way, the current patch summary
>> looked like it will be perfect between /* */ ;-)
> 
> I did not want to fill up the source with wordy comments, and settled
> for a one-liner. I don't know much about the underlying reasons other
> than the fact that LPDDR1 mode of the controller isn't working properly
> in self-refresh and that the DDR2 spec is similar enough to work.
> 
> The one-liner comment says about the same thing, but not with so
> many words. The comment does make it clear that the switch to DDR2
> is intentional, and that is all that is needed as protection from some
> future cleanup. I mean, anyone seeing that comment and just erasing
> the whole thing without further investigation is not doing a very good
> job as there is no reason to intentionally switch from LPDDR1 mode to
> DDR2 mode, other that the fact that the LPDDR1 mode isn't working for
> some reason. That reason is not to be found in the commit message
> and I have no information to improve the situation. IMO, the only thing
> missing is a pointer to the as yet unreleased errata, which should explain
> the situation clearly for any and all interested parties. May I suggest that
> someone who cares sends a patch with the comment update when the
> errata is released?

That's the option that I'll take.

Let's go for it (and anyone remind me if I don't when the errata is
released).

Bye,


> If others feel differently, by all means please reword and expand the
> comment.
> 
> Cheers,
> Peter
> 


-- 
Nicolas Ferre
