Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaLCQEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:04:46 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:52753 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaLCQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:04:44 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <ea1da0fc9d12a8fe52c25fc0f6f92723>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547F3495.9070206@rock-chips.com>
Date: Thu, 04 Dec 2014 00:04:37 +0800
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
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com> <1417620566-30496-1-git-send-email-andy.yan@rock-chips.com> <20141203153847.GC11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141203153847.GC11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell:

On 2014年12月03日 23:38, Russell King - ARM Linux wrote:
> On Wed, Dec 03, 2014 at 11:29:26PM +0800, Andy Yan wrote:
>> +int imx_hdmi_bind(struct device *dev, struct device *master,
>> +		  void *data, struct drm_encoder *encoder,
>> +		  const struct imx_hdmi_plat_data *plat_data)
>>   {
>>   	struct platform_device *pdev = to_platform_device(dev);
>> -	const struct of_device_id *of_id =
>> -				of_match_device(imx_hdmi_dt_ids, dev);
>>   	struct drm_device *drm = data;
>>   	struct device_node *np = dev->of_node;
>>   	struct device_node *ddc_node;
>> @@ -1594,19 +1566,16 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
>>   	struct resource *iores;
>>   	int ret, irq;
>>   
>> -	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
>> +	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
>>   	if (!hdmi)
>>   		return -ENOMEM;
>>   
>> -	hdmi->dev = dev;
>> +	hdmi->plat_data = plat_data;
>> +	hdmi->dev = &pdev->dev;
>> +	hdmi->dev_type = plat_data->dev_type;
>>   	hdmi->sample_rate = 48000;
>>   	hdmi->ratio = 100;
>> -
>> -	if (of_id) {
>> -		const struct platform_device_id *device_id = of_id->data;
>> -
>> -		hdmi->dev_type = device_id->driver_data;
>> -	}
>> +	hdmi->encoder = encoder;
> I'd suggest changing imx_hdmi_bind() to take the struct resource and irq
> number, and avoiding the platform device stuff altogether in here.
>
    Actually this is what the current code do: the resource and irq number
are all handled in imx_hdmi_bind


