Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbaLKHos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:44:48 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:42788 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaLKHoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:44:46 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: kishon@ti.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <93f9a720a78e0a9d35a1db86b0a77434>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54894B52.3060105@rock-chips.com>
Date: Thu, 11 Dec 2014 15:44:18 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, heiko@sntech.de,
        jwerner@chromium.org, dianders@chromium.org
CC: olof@lixom.net, huangtao@rock-chips.com, zyw@rock-chips.com,
        cf@rock-chips.com, linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com> <1418208371-18851-2-git-send-email-lyz@rock-chips.com> <5489338C.1030109@ti.com>
In-Reply-To: <5489338C.1030109@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon:

On 2014/12/11 14:02, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Wednesday 10 December 2014 04:16 PM, Yunzhi Li wrote:
>> This patch to add a generic PHY driver for ROCKCHIP usb PHYs,
>> currently this driver can support RK3288. The RK3288 SoC have
>> three independent USB PHY IPs which are all configured through a
>> set of registers located in the GRF (general register files)
>> module.
>>
>> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>>
>> +
>> +#define ROCKCHIP_RK3288_UOC(n)	(0x320 + n * 0x14)
>> +
>> +/*
>> + * The higher 16-bit of this register is used for write protection
>> + * only if BIT(13 + 16) set to 1 the BIT(13) can be written.
>> + */
>> +#define SIDDQ_MSK		BIT(13 + 16)
> I think here the "MSK" is misleading. it should be something that refers write
> protection?
So, #define SIDDQ_WRITE_ENA  BIT(29) , could be ok ?
>> +#define SIDDQ_ON		BIT(13)
>> +#define SIDDQ_OFF		(0 << 13)
>> +
>> +struct rockchip_usb_phy {
>> +	struct regmap	*reg_base;
>> +	unsigned int	reg_offset;
>> +	struct clk	*clk;
>> +	struct phy	*phy;
>> +	unsigned	index;
>> +};
>> +
>> +struct rockchip_usb_phy_priv {
>> +	struct rockchip_usb_phy	*phys;
>> +	unsigned		nphys;
>> +};
>> +
>> +static int rockchip_usb_phy_power(struct rockchip_usb_phy *phy,
>> +					   bool siddq)
>> +{
>> +	return regmap_write(phy->reg_base, phy->reg_offset,
>> +			    SIDDQ_MSK | (siddq ? SIDDQ_ON : SIDDQ_OFF));
> Shouldn't we actually reset the bit for power off?
Sorry, which bit you refer to here  and why should it be reset? could 
you give more infomation.

---
Yunzhi Li @ rockchip

