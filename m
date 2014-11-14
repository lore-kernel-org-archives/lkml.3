Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbaKNLQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:16:31 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:51753 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbaKNLQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:16:29 -0500
Message-ID: <5465E47E.7090602@imgtec.com>
Date: Fri, 14 Nov 2014 11:16:14 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>, <dri-devel@lists.freedesktop.org>,
        <ykk@rock-chips.com>, <devel@driverdev.osuosl.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, <jay.xu@rock-chips.com>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, <mark.yao@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <djkurtz@google.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v10 11/11] drm: bridge/dw_hdmi: add rockchip rk3288 support
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com> <1415935884-17130-1-git-send-email-andy.yan@rock-chips.com> <5465D816.3020708@imgtec.com> <5465DB4F.7090402@rock-chips.com> <5465DF34.303@imgtec.com> <5465E3F1.4060407@rock-chips.com>
In-Reply-To: <5465E3F1.4060407@rock-chips.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/11/14 11:13, Andy Yan wrote:
> 
> On 2014年11月14日 18:53, Zubair Lutfullah Kakakhel wrote:
>>
>> On 14/11/14 10:37, Andy Yan wrote:
>>> On 2014年11月14日 18:23, Zubair Lutfullah Kakakhel wrote:
>>>> Hi Andy
>>>>
>>>> On 14/11/14 03:31, Andy Yan wrote:
>>>>> Rockchip RK3288 hdmi is compatible with dw_hdmi
>>>>>
>>>>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>>>>
>>>>> ---
>>>>>
>>>>> Changes in v10:
>>>>> - add more display mode support mpll configuration for rk3288
>>>>>
>>>>> Changes in v9:
>>>>> - move some phy configuration to platform driver
>>>>>
>>>>> Changes in v8: None
>>>>> Changes in v7: None
>>>>> Changes in v6: None
>>>>> Changes in v5: None
>>>>> Changes in v4: None
>>>>> Changes in v3: None
>>>>> Changes in v2: None
>>>>>
>>>>>    drivers/gpu/drm/bridge/dw_hdmi.c            |  10 +
>>>>>    drivers/gpu/drm/bridge/dw_hdmi.h            |   3 +-
>>>>>    drivers/gpu/drm/rockchip/Kconfig            |  10 +
>>>>>    drivers/gpu/drm/rockchip/Makefile           |   2 +-
>>>>>    drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 355 ++++++++++++++++++++++++++++
>>>>>    include/drm/bridge/dw_hdmi.h                |   1 +
>>>>>    6 files changed, 379 insertions(+), 2 deletions(-)
>>>>>    create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
>>>>>
>>>>> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>>>>> index a2876fe..1dd1f0b 100644
>>>>> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
>>>>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>>>>> @@ -715,6 +715,13 @@ static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
>>>>>                 HDMI_PHY_CONF0_ENTMDS_MASK);
>>>>>    }
>>>>>    +static void dw_hdmi_phy_enable_spare(struct dw_hdmi *hdmi, u8 enable)
>>>>> +{
>>>>> +    hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
>>>>> +             HDMI_PHY_CONF0_SPARECTRL_OFFSET,
>>>>> +             HDMI_PHY_CONF0_SPARECTRL_MASK);
>>>>> +}
>>>>> +
>>>> What does enable spare do? Can other future SoCs use it?
>>>>
>>>> This looks like DW specific. And can be a separate commit that adds a feature to the dw hdmi driver.
>>>    Actually I am not very clearly about this bit, but RK3288 HDMI will not work without this bit enable.
>>>    On imx6, the description about this bit is:Reserved. Spare pin control.
>>>    On rk3288, the description is: svsret/sparectrl
>>>     Both are very simple.
>> Sounds like the IP Core in the rk3288 is slightly upgraded.
>> Separate this section in a different commit as it is generic DW stuff.
>>
>> And add what you wrote above in the commit message.
>   Only Separate function dw_hdmi_phy_enale_spare ? not include
>   if (hdmi->dev_type == rk3288_hdmi)
>                dw_hdmi_enable_phy_spare(hdmi, 1);
>  ?

Yes. Separate dw_hdmi_phy_enable_spare and its associated defines 
 HDMI_PHY_CONF0_SPARECTRL_OFFSET
 HDMI_PHY_CONF0_SPARECTRL_MASK
 in the header
as one commit.


The if (hdmi->dev_type == rk3288_hdmi) code is part of the add rk3288 support.

ZubairLK
