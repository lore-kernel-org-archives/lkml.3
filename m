Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaESKoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:44:24 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34304 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaESKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:44:22 -0400
Message-ID: <5379E07B.9040507@gmail.com>
Date: Mon, 19 May 2014 12:44:11 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>, Tomasz Figa <t.figa@samsung.com>
CC: Rahul Sharma <rahul.sharma@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, sunil joshi <joshi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 1/4] clk: samsung: out: Add infrastructure to register
 CLKOUT
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>	<1399640410-30957-2-git-send-email-tushar.behera@linaro.org>	<536DA243.6000600@samsung.com>	<53705243.1030704@linaro.org>	<CAPdUM4N=k-pPxdhPQgVHh0fb+nqkgs7StwM2Pb6C8gcjx6dw-w@mail.gmail.com>	<5374CA1C.8000207@samsung.com> <CAHbNUh03TVxbXZcT3e6618zPdu_53_y6nVjwJE7cWa6zxLMpqA@mail.gmail.com>
In-Reply-To: <CAHbNUh03TVxbXZcT3e6618zPdu_53_y6nVjwJE7cWa6zxLMpqA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.05.2014 05:30, Tushar Behera wrote:
> On 15 May 2014 19:37, Tomasz Figa <t.figa@samsung.com> wrote:
>> Hi Rahul, Tushar,
>>
>> On 15.05.2014 15:44, Rahul Sharma wrote:
>>> Hi Tushar,
>>>
>>> Basically you are adding a new clock-type for Clkout. IMO clkout
>>> is not a special hardware. Existing clock types can be reused to
>>> support clkout. I see 3 major problem here:
>>>
>>> 1) Clkout -> (Mux + Gate). You clubbed mux and gate together, and
>>> exposing as a single clock which is something like a composite clock.
>>> IMO this is not a recommended way in CCF.
>>>
>>> 2) New Clock Type: Since clkout is just a combination of a simple
>>> mux and gate which are already supported, it is a unnecessary
>>> duplication.
>>>
>>> 3) Clkout registered along with CMU: which is not correct. Clkout is in PMU
>>> (Separate physical IP) and should be registered as a independent Clock
>>> provider which provides 1 mux and 1 gate clock (As if now). It should also be
>>> well connected with main CMU.
>>>
>>> I understand the challenge in using regmap interface for a clock provider. But
>>> we need to identify a clean solution. IMHO a independent clock provider with
>>> iomap, is relatively cleaner approach till CCF is not ready with regmap based
>>> reg access for clock registers.
>>>
>>> Experts!! please comment.
>>
>> It's quite unfortunate that Tushar has duplicated the effort to create a
>> clkout driver, considering the fact that we did have such driver
>> internally at SRPOL and it was quite nice and simple.
>>
> 
> I had no idea that you had some solutions to this available to be posted :(
> 
> Now that the new series is posted, I will test that at my end and
> update you later.

Again, sorry for this duplicated effort.

The biggest problem is that we (SRPOL and Linaro) don't have a way to
share our upstream TODO lists and say "hey, we have this working, if you
need it, we can upstream it \o/" or "we need it too, but don't have
resources right now to work on it :(".

Maybe we should set up some wiki or any other semi-public site for this
purpose? I need to talk with other people from my team and my manager to
see what we can do. Other guys (other Samsung teams, Chromium folks,
hobbyists) could also benefit from it.

Anyway, thanks for your understanding and testing.

Best regards,
Tomasz
