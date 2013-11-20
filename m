Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3KTAHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:07:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40933 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3KTAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:07:09 -0500
Message-ID: <528BFD28.3050909@wwwdotorg.org>
Date: Tue, 19 Nov 2013 17:07:04 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: Doug Anderson <dianders@chromium.org>, devicetree@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>	<528BB1F2.4080107@wwwdotorg.org>	<CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>	<528BB913.6080409@wwwdotorg.org> <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
In-Reply-To: <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 05:02 PM, Kyungmin Park wrote:
> On Wed, Nov 20, 2013 at 4:16 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 11/19/2013 11:59 AM, Doug Anderson wrote:
>>> On Tue, Nov 19, 2013 at 10:46 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 11/19/2013 10:15 AM, Tomasz Figa wrote:
>>>>> This patch extends the range of settings configurable via pinfunc API
>>>>> to cover pin value as well. This allows configuration of default values
>>>>> of pins.
>>>>
>>>> Shouldn't there be a driver that acquires the GPIO that's output to the
>>>> pin, and configures the output value? IIRC there have been previous
>>>> discussions re: having a list of e.g. initial GPIO output values in DT,
>>>> and that was rejected, and this patch seems to be doing almost the exact
>>>> same thing, just at the pinctrl level rather than GPIO level.
>>>>
>>>> That all said, I admit this could be a useful feature...
>>>
>>> I haven't followed all of the previous discussions, but I know I've
>>> run into scenarios where something like this would be useful.  The one
>>> that comes to mind is:
>>>
>>> * We've got GPIOs that default at bootup to a pulled up input since
>>> the default state of the pin should be "high".
>>>
>>> * These pins are really intended to be outputs, like an "enable",
>>> "reset", or "power down" line for a peripheral.  The pullup is strong
>>> enough to give us a good default state but we really want outputs.
>>>
>>> * We'd like to provide this GPIO to a peripheral through device tree.
>>> ...and we'd like all the pinmux to be setup automatically so we use
>>> pinctrl-names = "default".
>>>
>>> * If we set the pinmux up as "output" then there's a chance that the
>>> line will glitch at bootup since the pinmux happens (changing the pin
>>> to output) before the driver has a chance to run.
>>
>> I think that last point should be addressed by having a driver that owns
>> the GPIO set it to the desired output level, and the implementation of
>
> Some pins are not connected (NC). At that cases, there's no drivers to
> handle it. To reduce power leakage, it sets proper configuration with
> values instead of reset values.

Hmm. Shouldn't board firmware configure that kind of thing?

(Of course, some firmware is starting to use DT to configure itself, so
that just shifts the DT discussion, but anyway).


