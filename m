Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbaLKIjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:39:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44098 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaLKIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:39:13 -0500
Message-ID: <54895785.104@ti.com>
Date: Thu, 11 Dec 2014 14:06:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yunzhi Li <lyz@rock-chips.com>, <heiko@sntech.de>, <jwerner@chromium.org>,
        <dianders@chromium.org>
CC: <olof@lixom.net>, <huangtao@rock-chips.com>, <zyw@rock-chips.com>,
        <cf@rock-chips.com>, <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com> <1418208371-18851-2-git-send-email-lyz@rock-chips.com> <5489338C.1030109@ti.com> <54894B52.3060105@rock-chips.com>
In-Reply-To: <54894B52.3060105@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 December 2014 01:14 PM, Yunzhi Li wrote:
> Hi Kishon:
> 
> On 2014/12/11 14:02, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Wednesday 10 December 2014 04:16 PM, Yunzhi Li wrote:
>>> This patch to add a generic PHY driver for ROCKCHIP usb PHYs,
>>> currently this driver can support RK3288. The RK3288 SoC have
>>> three independent USB PHY IPs which are all configured through a
>>> set of registers located in the GRF (general register files)
>>> module.
>>>
>>> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>>>
>>> +
>>> +#define ROCKCHIP_RK3288_UOC(n)    (0x320 + n * 0x14)
>>> +
>>> +/*
>>> + * The higher 16-bit of this register is used for write protection
>>> + * only if BIT(13 + 16) set to 1 the BIT(13) can be written.
>>> + */
>>> +#define SIDDQ_MSK        BIT(13 + 16)
>> I think here the "MSK" is misleading. it should be something that refers write
>> protection?
> So, #define SIDDQ_WRITE_ENA  BIT(29) , could be ok ?

yeah. should be fine.
>>> +#define SIDDQ_ON        BIT(13)
>>> +#define SIDDQ_OFF        (0 << 13)
>>> +
>>> +struct rockchip_usb_phy {
>>> +    struct regmap    *reg_base;
>>> +    unsigned int    reg_offset;
>>> +    struct clk    *clk;
>>> +    struct phy    *phy;
>>> +    unsigned    index;
>>> +};
>>> +
>>> +struct rockchip_usb_phy_priv {
>>> +    struct rockchip_usb_phy    *phys;
>>> +    unsigned        nphys;
>>> +};
>>> +
>>> +static int rockchip_usb_phy_power(struct rockchip_usb_phy *phy,
>>> +                       bool siddq)
>>> +{
>>> +    return regmap_write(phy->reg_base, phy->reg_offset,
>>> +                SIDDQ_MSK | (siddq ? SIDDQ_ON : SIDDQ_OFF));
>> Shouldn't we actually reset the bit for power off?
> Sorry, which bit you refer to here  and why should it be reset? could you give
> more infomation.

Never mind. Initially was thinking it might affect bits other than siddq but
anyway you have write lock. So should be fine.

Thanks
Kishon
