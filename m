Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaLJKlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:41:07 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:40695 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaLJKlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:41:05 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: romain.perier@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <64410a4aac24aaf759d2411c9123dcc3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54882324.10700@rock-chips.com>
Date: Wed, 10 Dec 2014 18:40:36 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Romain Perier <romain.perier@gmail.com>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>, olof@lixom.net,
        Tao Huang <huangtao@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, linux-rockchip@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418093001-30443-1-git-send-email-lyz@rock-chips.com>	<1418093001-30443-2-git-send-email-lyz@rock-chips.com> <CABgxDoJRA4cQBqNBTCSGnnLpcOHqqTuBqcyWQosVv4A_Gx315g@mail.gmail.com>
In-Reply-To: <CABgxDoJRA4cQBqNBTCSGnnLpcOHqqTuBqcyWQosVv4A_Gx315g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Romain:

On 2014/12/9 18:41, Romain Perier wrote:
> Hi,
>
> 2014-12-09 3:43 GMT+01:00 Yunzhi Li <lyz@rock-chips.com>:
>> Changes in v3:
>> - Use BIT macro instead of bit shift ops.
>> - Rename the config entry to PHY_ROCKCHIP_USB.
> Contradiction between this , [1] and [2]
>>   drivers/phy/Kconfig            |   7 ++
>>   drivers/phy/Makefile           |   1 +
>>   drivers/phy/phy-rockchip-usb.c | 211 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 219 insertions(+)
>>   create mode 100644 drivers/phy/phy-rockchip-usb.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index ccad880..8a39d2a 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -239,6 +239,13 @@ config PHY_QCOM_IPQ806X_SATA
>>          depends on OF
>>          select GENERIC_PHY
>>
>> +config PHY_ROCKCHIP_USB2
>> +       tristate "Rockchip USB2 PHY Driver"
>> +       depends on ARCH_ROCKCHIP && OF
>> +       select GENERIC_PHY
>> +       help
>> +         Enable this to support the Rockchip USB 2.0 PHY.
>> +
> 1. The config entry ends by "USB2". Explain that your driver is for
> usb 2.0 in the description is enough, imho.
>
>>   config PHY_ST_SPEAR1310_MIPHY
>>          tristate "ST SPEAR1310-MIPHY driver"
>>          select GENERIC_PHY
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index aa74f96..8a13f72 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -28,6 +28,7 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2) += phy-exynos5250-usb2.o
>>   phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)     += phy-s5pv210-usb2.o
>>   obj-$(CONFIG_PHY_EXYNOS5_USBDRD)       += phy-exynos5-usbdrd.o
>>   obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)    += phy-qcom-apq8064-sata.o
>> +obj-$(CONFIG_PHY_ROCKCHIP_USB2) += phy-rockchip-usb.o
> 2. and... this :)
So,do you mean that I should rename the C source file as 
phy-rockchip-usb2.c ?
> Romain
>
>


