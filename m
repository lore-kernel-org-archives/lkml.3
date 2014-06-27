Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaF0Dhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:37:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62409 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaF0Dh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:37:29 -0400
Message-ID: <53ACE6EE.4050300@linaro.org>
Date: Fri, 27 Jun 2014 11:37:18 +0800
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
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <20300092.1dHGFVKfHm@wuerfel> <53AC24C6.8000304@linaro.org> <4989178.vejv39dnj8@wuerfel>
In-Reply-To: <4989178.vejv39dnj8@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/27/2014 04:53 AM, Arnd Bergmann wrote:
> On Thursday 26 June 2014 21:48:54 zhangfei wrote:

>>> Since you mention that this is a synopsys part, it may however be
>>> good to also define a compatible string for the generic device,
>>> to allow other SoCs to share this driver, and to make it easier
>>> for people to find out that we already have one so they don't have
>>> to write another driver for the same hardware.
>>
>> http://www.synopsys.com/dw/ipdir.php?ds=dwc_sata_phy
>> name can be: dwc_sata_phy
>> However, not find register from the website, not sure whether the
>> register are totally same, or there is some change.
>> Other soc from hisilicon using the same ip can share this driver.
>
> I found a list of versions under "Downloads and Documentation", but
> unfortunately the actual downloads are not accessible without a
> customer account.
>
>>> Can you find out what the Synopsys/Designware product designation for
>>> this PHY is? It would be good to rename the driver and binding
>>> if possible. I would still recommend leaving the
>>> "hisilicon,hix5hd2-sata-phy" string and the "hisilicon,peripheral-syscon"
>>> property in place, since that indicates a minor variation of the
>>> generic part.
>>
>> "hisilicon,peripheral-syscon" is privide power supply, etc.
>>
>> Do you mean change the compatible to "hisilicon,dwc-sata-phy" or
>> multiple compatible?
>
> Multiple compatible strings.
>
> "hisilicon,dwc-sata-phy" would be too generic anyway, it should include the
> name of the chip that first implements this, or the exact version of the
> IP block, preferably both.
>
> Ideally if you can find out the version that hisilicon uses, it could
> look something like
>
> compatible = "hisilicon,hi15hd2-sata-phy", "snps,dwc-sata-phy-2.3a", ""snps,dwc-sata-phy";
>
> Note also the specific version of the hisilicon chip: you must not use
> wildcards in compatible strings but should always use a real product number.
> ("1" instead of "x"). If multiple chips are mutually compatible, they
> can all use the number of the first one here.
>

Sorry for the confusion.

The phy is rather an analog controller, without standard register.
Instead, the phy interface is just some pin / analog interface.
The register is in fact hix5hd2 register, controls all the analog 
output, including reset, power, speed, para tunning.

Even the same phy is used in other soc, they can not share this driver, 
since the connection must be different, as well as internal soc register 
layout.
Only if the same controller & phy are reused in other hisilicon soc, 
this driver can be shared.

Since what we control is hix5hd2 controller itself, so it may not 
suitable to put snps here.


And about hix5hd2 name: x is not wildcard.

Currently hix5hd2 is series of hi3716c v200, hi3719c v100, hi3718c v100.
They are same soc, except minus pin assembles different.

However, not all hi37x is in this series, for example hi3716c v100 is a 
different soc.

In the future hi3719m, hi3718m may also plan to add to hix5hd2 series.
The difference will be different cpu core number, different gpu core 
number. Also use different ethernet controller.


So we may still keep "hisilicon,hix5hd2-sata-phy" unchanged.
What do you think?

Thanks



