Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaISBEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:04:23 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30343 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbaISBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:04:20 -0400
X-IronPort-AV: E=Sophos;i="5.04,550,1406617200"; 
   d="scan'208";a="46044037"
Message-ID: <541B7FCB.1090102@broadcom.com>
Date: Thu, 18 Sep 2014 17:58:51 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, Florian Fainelli <florian@openwrt.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>
CC: <devicetree@vger.kernel.org>, Ray Jui <rjui@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/6] Add initial support for Broadcom Cygnus SoC
References: <Jonathan Richardson <jonathar@broadcom.com> <1410897497-27527-1-git-send-email-jonathar@broadcom.com> <541B5D5A.10800@hauke-m.de> <541B5F16.6030005@openwrt.org> <541B62BE.8050909@hauke-m.de>
In-Reply-To: <541B62BE.8050909@hauke-m.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-09-18 03:54 PM, Hauke Mehrtens wrote:
> On 09/19/2014 12:39 AM, Florian Fainelli wrote:
>> On 09/18/2014 03:31 PM, Hauke Mehrtens wrote:
>>> On 09/16/2014 09:58 PM, Jonathan Richardson wrote:
>>>> Hi,
>>>>
>>>> This patchset contains initial support for Broadcom's Cygnus SoC based on our
>>>> iProc architecture. Initial support is minimal and includes just the mach
>>>> platform code, clock driver, and a basic device tree configuration. Peripheral
>>>> drivers will be submitted soon, as will device tree configurations for other
>>>> Cygnus board variants.
>>>
>>> This SoC looks similar to the BCM5301X (Northstar) SoCs even some cores
>>> are at the same memory addresses. Does this SoC use an AXI bus with
>>> Broadcom Plugins at address 0x18000000 ?
>>>
>>> The BCM5301X (Northstar) SoCs also has an iProc Clock Control Unit and I
>>> will try to use your driver for that SoC.
>>>
>>> Is Broadcom Cygnus similar to BCM563XX or is it actually the same SoC?
Cygnus is a next generation product with similarities to other Broadcom 
SoC's.  It takes technology from other parts for sure.  Our first step 
is to upstream the core IPROC code and Cygnus code.  From there we will 
upstream individual drivers which are reusable on some other Broadcom 
chips (or will need minor additions/quirks added as identified).  There 
are also other IPROC-based Broadcom chips that can also be upstreamed 
more easily with this patchset going forward.

I know the BCM5301X iProc Clock Control Unit is an older.  I think you 
may run into some difficulties running this code as is.  But hopefully 
we can build up more support for other chips from this initial 
submission for Cygnus support.
>>
>> According to this link:
>> http://lists.denx.de/pipermail/u-boot/2014-August/186086.html
>>
>> these SoCs, in particular BCM58622 would belong to the StrataGX network
>> processors:
>> http://www.broadcom.com/products/Processors/Home-and-Small-Business/BCM5862X-Series.
>
> Broadcom claims that this SoC is pin and software compatible to BCM5301X:
>> Pin compatible and software compatible products with previous
>> generation BCM5301x products enable single design with easy
>> upgradeable path
>
>>> Do you have some description of the hardware features of this SoC? Does
>>> it have PCIe, or Ethernet?
Yes, Some variants of Cygnus do have PCIe or Ethernet.  Drivers to be 
upstreamed once cleaned up fully.  The drivers will be built into our 
bcm_cygnus_defconfig and then enabled in device tree.
>>
>>  From the link above, it has Ethernet for sure, and certainly PCIe since
>> the Wi-Fi chips mentioned in the link above are PCIe chips.
>>
>> It would be really good if all the work you and Rafal did was usable for
>> the Cygnus SoCs.
>
> I also hope you can use much of the code and improve it. ;-)
>
> Hauke

>

