Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaLDAvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:51:15 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:42808 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLDAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:51:14 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <2c99a66b32f593a55796fa5eef606cde>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547FAFF6.3050800@rock-chips.com>
Date: Thu, 04 Dec 2014 08:51:02 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        vladimir_zapolskiy@mentor.com, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v16 03/12] drm: imx: imx-hdmi: convert imx-hdmi to drm_bridge
 mode
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com> <1417620566-30496-1-git-send-email-andy.yan@rock-chips.com> <20141203153847.GC11285@n2100.arm.linux.org.uk> <547F3495.9070206@rock-chips.com> <20141203161122.GF11285@n2100.arm.linux.org.uk> <547F3A9F.30701@rock-chips.com> <20141203163318.GH11285@n2100.arm.linux.org.uk> <547F40B8.6060706@rock-chips.com> <20141203234000.GJ11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141203234000.GJ11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel:
On 2014年12月04日 07:40, Russell King - ARM Linux wrote:
> On Thu, Dec 04, 2014 at 12:56:24AM +0800, Andy Yan wrote:
>> Hi Russell:
>> On 2014年12月04日 00:33, Russell King - ARM Linux wrote:
>>> On Thu, Dec 04, 2014 at 12:30:23AM +0800, Andy Yan wrote:
>>>> On 2014年12月04日 00:11, Russell King - ARM Linux wrote:
>>>>> I meant that imx_hdmi_bind should be passed these, so that it needs to
>>>>> know nothing about the struct device beyond the generic device structure.
>>>>> In other words, the dw-hdmi core should not assume that the struct device
>>>>> is part of a platform device.
>>>>>
>>>>     if so, how about the device tree properties  ddc-i2c-bus, reg-io-width,
>>>> iahb, isfr,
>>>>    they are all found by device?
>>> If the device has a device tree node associated with it, it will have a
>>> non-NULL dev->of_node - which is part of the generic device structure.
>>>
>>    so , I just need get the resource and irq number in the
>> dw_hdmi-imx/rockchip ,than
>>    pass them to imx_hdmi_bind, as the properties ddc-i2c-bus, reg-io-width,
>> iahb,isfr, they
>>    are still can be handled in imx_hdmi_bind ?
> Basically, what I'm suggesting is just this change to imx_hdmi_bind():
>
>   int imx_hdmi_bind(struct device *dev, struct device *master,
> 		  void *data, struct drm_encoder *encoder,
> +		  const struct resource *iores, int irq,
> 		  const struct imx_hdmi_plat_data *plat_data)
>   {
> -	struct platform_device *pdev = to_platform_device(dev);
> ...
> 	}
>
> -	irq = platform_get_irq(pdev, 0);
> 	if (irq < 0)
> 		return irq;
> ...
> 		return ret;
>
> -	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 	hdmi->regs = devm_ioremap_resource(dev, iores);
> 	if (IS_ERR(hdmi->regs))
>
> and supplying those as arguments from the caller.
>
   got it, thanks, and also many thanks for Philipp


