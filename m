Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbaHZKkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:40:06 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:42542 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaHZKkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:40:03 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: lee.jones@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <cd3783685af9ce8be080d8ebe8205a31>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53FC63EE.6060104@rock-chips.com>
Date: Tue, 26 Aug 2014 18:39:42 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v2 2/5] MFD: RK808: Add new mfd driver for RK808
References: <1408505461-24200-1-git-send-email-zyw@rock-chips.com> <20140820092117.GI4266@lee--X1> <53FA9D1E.8040202@rock-chips.com> <20140826092205.GG9574@lee--X1> <53FC5BD1.7030406@rock-chips.com> <20140826102036.GJ9574@lee--X1>
In-Reply-To: <20140826102036.GJ9574@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/26/2014 06:20 PM, Lee Jones wrote:
> On Tue, 26 Aug 2014, Chris Zhong wrote:
>> On 08/26/2014 05:22 PM, Lee Jones wrote:
>>> On Mon, 25 Aug 2014, Chris Zhong wrote:
>>>> On 08/20/2014 05:21 PM, Lee Jones wrote:
>>>>> On Wed, 20 Aug 2014, Chris Zhong wrote:
>>>>>
>>>>>> The RK808 chip is a power management IC for multimedia and handheld
>>>>>> devices. It contains the following components:
>>>>>>
>>>>>> - Regulators
>>>>>> - RTC
>>>>>>
>>>>>> The rk808 core driver is registered as a platform driver and provides
>>>>>> communication through I2C with the host device for the different
>>>>>> components.
>>>>>>
>>>>>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>>>>> ---
>>> [...]
>>>
>>>>>> +	rk808->pdata = pdata;
>>>>> Remove pdata from 'struct rk808'.  You can obtain it from dev.
>>>> Can I keep this pdata in rk808, because it is used in the regulator driver.
>>>> The one obtain from dev maybe empty.
>>> If the one in dev is empty, you should populate that instead.
>> So, should I malloc a pada, and assign it to client->dev?
> If client->dev.pdata is NULL, yes.
>
> But actually, I have more important questions that need to be answered
> first.  Ones which I would normally be able to answer myself if the
> patch-set had been sent as one (i.e. threaded) instead of as
> individual patches:
>
> - What are you using pdata for?

For save some properties,

like "rockchip,system-power-controller" in MFD
and some regulator properties in regulator/rk808...

> - Where is pdata populated?

It is populated in probe in mfd/rk808.c

actually, I copy it from tps65910.c


> - Where is pdata used?

pdata is used in mfd and regulator



