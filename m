Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbaLLFhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:37:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48400 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaLLFhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:37:33 -0500
Message-ID: <548A7E7D.8010703@ti.com>
Date: Fri, 12 Dec 2014 11:04:53 +0530
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
Subject: Re: [PATCH v6 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com> <1418291722-25448-2-git-send-email-lyz@rock-chips.com> <548971AF.1020506@ti.com> <54899FE7.7050808@rock-chips.com>
In-Reply-To: <54899FE7.7050808@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 December 2014 07:15 PM, Yunzhi Li wrote:
> Hi Kishon:
> 
> On 2014/12/11 18:27, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Thursday 11 December 2014 03:25 PM, Yunzhi Li wrote:
>>> +
>>> +static struct phy *rockchip_usb_phy_xlate(struct device *dev,
>>> +                    struct of_phandle_args *args)
>>> +{
>>> +    struct rockchip_usb_phy_priv *priv = dev_get_drvdata(dev);
>>> +    unsigned int phy_id = args->args[0];
>>> +
>>> +    if (WARN_ON(phy_id < 0 || phy_id >= priv->nphys))
>>> +        return ERR_PTR(-ENODEV);
>>> +
>>> +    return priv->phys[phy_id].phy;
>> I didn't mean that. You can get rid of this entire xlate stuff if you use
>> something like below
>>
>> phy@xxx {
>>     compatible = "";
>>     phy1:usb_phy {
>>     }
>>     phy2:usb_phy {
>>     };
>> };
>>
>>
>> usb@xx {
>>     compatible = "";
>>     phys = <&phy1>; //doesn't need xlate
>>     /* this needs xlate
>>        phys = <&phy 1>;
>>     */
>>     phy-names = "phy";
>> };
> 
> Thank you so much for your suggestion, but still have a question:
> I have to add the #phy-cells property in each phy sub-node, otherwise
> devm_get_phy() will fail and I get log info like
> "/usb@ff500000: could not get #phy-cells for /phy/usbp-phy1". So can the
> #phy-cells property defines in patent node
> also valid for it's child nodes like #address-cells ?

No. You have to add #phy-cells property for every PHY node.

Thanks
Kishon
