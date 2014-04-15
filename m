Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaDOK0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:26:19 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58271 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOK0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:26:17 -0400
Message-ID: <534D0943.2050100@gmail.com>
Date: Tue, 15 Apr 2014 12:26:11 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin: add GPIO nodes for the BG2Q
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com> <1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com> <534CFA77.9030108@gmail.com> <20140415180058.2fefca78@xhacker>
In-Reply-To: <20140415180058.2fefca78@xhacker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 12:00 PM, Jisheng Zhang wrote:
> On Tue, 15 Apr 2014 02:23:03 -0700
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>> On 04/15/2014 10:07 AM, Antoine Ténart wrote:
>>> The Marvell Berlin BG2Q has 6 GPIO ports compatible with the
>>> snps,dw-apb-gpio driver. This patch add the corresponding device tree
>>> nodes.
>>>
>>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>>> ---
>>>    arch/arm/boot/dts/berlin2q.dtsi | 102
>>> ++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/berlin2q.dtsi
>>> b/arch/arm/boot/dts/berlin2q.dtsi index e6e556055dfc..b2625f896bc5 100644
>>> --- a/arch/arm/boot/dts/berlin2q.dtsi
>>> +++ b/arch/arm/boot/dts/berlin2q.dtsi
[...]
>>> +					compatible =
>>> "snps,dw-apb-gpio-port";
>>> +					gpio-controller;
>>> +					#gpio-cells = <2>;
>>> +					snps,nr-gpios = <32>;
>>
>> 32 gpio pins for each of the 6 GPIO controllers? Either BG2Q is a GPIO
>
> Yes, BG2Q support 32 pins every port

Wow. Thanks for confirming this!

>> I am fine with using nr-gpios property now, but I guess BG2Q also
>> has that CONFIG[1,2] registers to actually read out the features
>> synthesized in? If I find some time, I'll prepare a patch for
>> dw-apb-gpio to exploit that (optional) information instead of
>> using nr-gpios.
>
> The problem is CONFIG1/2 registers don't exist on some versions.
> For example, the version used in BG2/BG2CD. So nr-gpio is necessary
> if we want to support these versions.

Hmm, are you sure about BG2? I remember reading it and it contains
sane values. Anyway, a proper patch for dw-apb-gpio would include
checking for sane (e.g. non-zero) values. And nr-gpios will always
stay as fall-back just because e.g. sunxi does not have the CONFIG
registers.

Sebastian

