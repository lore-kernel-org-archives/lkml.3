Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaLKGww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:52:52 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:39926 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaLKGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:52:51 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: joe@perches.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <b5550eafa6a6617daa40aa187330d419>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54893F26.5050304@rock-chips.com>
Date: Thu, 11 Dec 2014 14:52:22 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Kishon Vijay Abraham I <kishon@ti.com>
CC: heiko@sntech.de, jwerner@chromium.org, dianders@chromium.org,
        olof@lixom.net, huangtao@rock-chips.com, zyw@rock-chips.com,
        cf@rock-chips.com, linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com>	 <1418208371-18851-2-git-send-email-lyz@rock-chips.com>	 <5489338C.1030109@ti.com> <1418278322.18092.30.camel@perches.com>	 <54893963.7060304@ti.com> <1418279847.18092.32.camel@perches.com>
In-Reply-To: <1418279847.18092.32.camel@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/12/11 14:37, Joe Perches wrote:
> On Thu, 2014-12-11 at 11:57 +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Thursday 11 December 2014 11:42 AM, Joe Perches wrote:
>>> On Thu, 2014-12-11 at 11:32 +0530, Kishon Vijay Abraham I wrote:
>>>> On Wednesday 10 December 2014 04:16 PM, Yunzhi Li wrote:
>>>>> diff --git a/drivers/phy/phy-rockchip-usb.c b/drivers/phy/phy-rockchip-usb.c
>>> []
>>>>> +/*
>>>>> + * The higher 16-bit of this register is used for write protection
>>>>> + * only if BIT(13 + 16) set to 1 the BIT(13) can be written.
>>>>> + */
>>>>> +#define SIDDQ_MSK		BIT(13 + 16)
>>> huh?
>>>
>>> This #define looks _very_ odd.
>>>
>>> Is this supposed to be a single bit 29 or
>>> some range?
>>  From what I understood, the most significant 16 bits are write locks to the
>> least significant 16 bits.
>>
>> So If I have to write something on bit 0, I have to set bit 16.
>> If I have to write something on bit 1, I have to set bit 17.
>> If I have to write something on bit 2, I have to set bit 18.
>> and so on.
> To me it'd look better to use another << rather than a plus
Like (BIT(13) << 16)? It looks strange, or could I just use ((1 << 13) 
<< 16) to describe this bit ?

---
Yunzhi Li @ rockchip



