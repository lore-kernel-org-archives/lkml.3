Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaFZNtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:49:21 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37135 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaFZNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:49:19 -0400
Message-ID: <53AC24C6.8000304@linaro.org>
Date: Thu, 26 Jun 2014 21:48:54 +0800
From: zhangfei <zhangfei.gao@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kishon Vijay Abraham I <kishon@ti.com>, mark.rutland@arm.com,
        haifeng.yan@linaro.org, jchxue@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata
 PHY
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <201406251416.49561.arnd@arndb.de> <53AAC376.7050705@linaro.org> <20300092.1dHGFVKfHm@wuerfel>
In-Reply-To: <20300092.1dHGFVKfHm@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/25/2014 09:32 PM, Arnd Bergmann wrote:
> On Wednesday 25 June 2014 20:41:26 zhangfei wrote:
>> On 06/25/2014 08:16 PM, Arnd Bergmann wrote:
>>> On Wednesday 25 June 2014, Zhangfei Gao wrote:
>>>> From: Jiancheng Xue <xuejiancheng@huawei.com>
>>>>
>>>> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
>>>>
>>>> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
>>>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>>>
>>> We have had a couple of PHY drivers that were initially meant to be
>>> single-purpose but then turned out to be for hardware that could
>>> be put into multiple modes (SATA, gbit ethernet, PCIe, ...). Are
>>> you sure that this particular device is SATA-only?
>>>
>>
>> Yes, double confimed.
>> Hix5hd2 phy diver only support sata phy, in fact, current soc only
>> support synposis phy, since some internal physical link.
>> And hix5hd2 ethernet phy is already in hix5hd2_gmac.c.
>> No pcie support on hix5hd2 platfrom.
>
> Sorry if I my question was unclear, I did not mean the implementation
> of this phy in hix5hd2, but the Synopsys phy itself. I was mainly
> asking because of the "compatible" string, which should otherwise
> not include "sata" but be more generic.

This phy is specifically for sata.

>
> Since you mention that this is a synopsys part, it may however be
> good to also define a compatible string for the generic device,
> to allow other SoCs to share this driver, and to make it easier
> for people to find out that we already have one so they don't have
> to write another driver for the same hardware.

http://www.synopsys.com/dw/ipdir.php?ds=dwc_sata_phy
name can be: dwc_sata_phy
However, not find register from the website, not sure whether the 
register are totally same, or there is some change.
Other soc from hisilicon using the same ip can share this driver.

>
> Can you find out what the Synopsys/Designware product designation for
> this PHY is? It would be good to rename the driver and binding
> if possible. I would still recommend leaving the
> "hisilicon,hix5hd2-sata-phy" string and the "hisilicon,peripheral-syscon"
> property in place, since that indicates a minor variation of the
> generic part.

"hisilicon,peripheral-syscon" is privide power supply, etc.

Do you mean change the compatible to "hisilicon,dwc-sata-phy" or 
multiple compatible?

Thanks
