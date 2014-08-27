Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936036AbaH0Vzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:55:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaH0Vzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:55:47 -0400
Message-ID: <53FE53E1.9030605@codeaurora.org>
Date: Wed, 27 Aug 2014 14:55:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: use IORESOURCE_REG resource type for non-translatable addresses
 in DT
References: <53D788A7.4020303@mm-sol.com>	<3794875.CZFbAag5Sv@wuerfel>	<53D7AA72.6010309@mm-sol.com>	<20140729234522.E9FF1C40738@trevor.secretlab.ca>	<53D84558.7060406@codeaurora.org>	<CAL_JsqJjH0OH+X=fzwqAPeWarjoLev7v6Nv_QhAa+nZyztMnFA@mail.gmail.com>	<20140730060619.GC19933@codeaurora.org> <CAJAp7OhoRQ1eWack1e=OL0cS4Fxmgxc7OWeNxcj1qt7Q-x-sQA@mail.gmail.com>
In-Reply-To: <CAJAp7OhoRQ1eWack1e=OL0cS4Fxmgxc7OWeNxcj1qt7Q-x-sQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/14 11:24, Bjorn Andersson wrote:
> On Tue, Jul 29, 2014 at 11:06 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 07/29, Rob Herring wrote:
> [..]
>>> You might as well do of_property_read_u32 in the below example.
>>>
>> Fair enough. The example is probably too simple. Things are
>> sometimes slightly more complicated and a simple
>> of_property_read_u32() isn't going to work in the case of
>> multiple reg values or when reg-names is in play.
>>
> But do we have such cases in the Qualcomm PMICs?

At the least we have reg-names users.

>
> The only case I've hit so far is for gpios and mpps, where it feels
> like reg should be base, size and not simply base reg of first gpio -
> but that's a different thing.
>
> Also, so far it seems like most drivers just code the base address in
> the driver, as we have very specific compatibles.

It would be nice if the drivers didn't have to do this. It annoys me
that platform drivers need to know that they're using DT to figure out
things that are standard platform features: registers, irqs, etc.

>
>
> How about we stop trying so hard to make this "perfect" and just merge
> something close to Josh's original proposal and ignore this problem?
> Currently all we're doing is delaying any possibility of getting
> drivers for the individual blocks merged.
> If we have the dt bindings require the reg to be there, we can discuss
> and change this all we want later!

What's Josh's original proposal? We've already punted on this for SSBI
PMICs and just required them to put registers in DT for use some day and
I don't see anyone blocking individual SPMI pmic drivers from merging
over this. So I guess I agree with you that we can move forward with the
other drivers. I'd still like to see us make this better though, so it
seems worthwhile to have the discussion and get to some conclusion.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

