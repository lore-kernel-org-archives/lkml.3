Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbaH0SYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:24:55 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45873 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935646AbaH0SYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140730060619.GC19933@codeaurora.org>
References: <53D788A7.4020303@mm-sol.com>
	<3794875.CZFbAag5Sv@wuerfel>
	<53D7AA72.6010309@mm-sol.com>
	<20140729234522.E9FF1C40738@trevor.secretlab.ca>
	<53D84558.7060406@codeaurora.org>
	<CAL_JsqJjH0OH+X=fzwqAPeWarjoLev7v6Nv_QhAa+nZyztMnFA@mail.gmail.com>
	<20140730060619.GC19933@codeaurora.org>
Date: Wed, 27 Aug 2014 11:24:49 -0700
Message-ID: <CAJAp7OhoRQ1eWack1e=OL0cS4Fxmgxc7OWeNxcj1qt7Q-x-sQA@mail.gmail.com>
Subject: Re: use IORESOURCE_REG resource type for non-translatable addresses
 in DT
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:06 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/29, Rob Herring wrote:
[..]
>>
>> You might as well do of_property_read_u32 in the below example.
>>
>
> Fair enough. The example is probably too simple. Things are
> sometimes slightly more complicated and a simple
> of_property_read_u32() isn't going to work in the case of
> multiple reg values or when reg-names is in play.
>

But do we have such cases in the Qualcomm PMICs?

The only case I've hit so far is for gpios and mpps, where it feels
like reg should be base, size and not simply base reg of first gpio -
but that's a different thing.

Also, so far it seems like most drivers just code the base address in
the driver, as we have very specific compatibles.


How about we stop trying so hard to make this "perfect" and just merge
something close to Josh's original proposal and ignore this problem?
Currently all we're doing is delaying any possibility of getting
drivers for the individual blocks merged.
If we have the dt bindings require the reg to be there, we can discuss
and change this all we want later!

Regards,
Bjorn
