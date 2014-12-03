Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaLCQBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:01:43 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:44659 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaLCQBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:01:41 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <ea2cbc05e1a3a80794a1154849ed237c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547F33D5.2000905@rock-chips.com>
Date: Thu, 04 Dec 2014 00:01:25 +0800
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
Subject: Re: [PATCH v16 05/12] drm: imx: imx-hdmi: move imx-hdmi to bridge/dw_hdmi
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com> <1417620732-30593-1-git-send-email-andy.yan@rock-chips.com> <20141203154503.GD11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141203154503.GD11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell:

On 2014年12月03日 23:45, Russell King - ARM Linux wrote:
> On Wed, Dec 03, 2014 at 11:32:12PM +0800, Andy Yan wrote:
>> diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
>> index 884923f..26162ef 100644
>> --- a/drivers/gpu/drm/bridge/Kconfig
>> +++ b/drivers/gpu/drm/bridge/Kconfig
>> @@ -3,3 +3,8 @@ config DRM_PTN3460
>>   	depends on DRM
>>   	select DRM_KMS_HELPER
>>   	---help---
>> +
>> +config DRM_DW_HDMI
>> +	bool "Synopsys DesignWare High-Definition Multimedia Interface"
>> +	depends on DRM
>> +	select DRM_KMS_HELPER
> ...
>> diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
>> index 82fb758..7070077 100644
>> --- a/drivers/gpu/drm/imx/Kconfig
>> +++ b/drivers/gpu/drm/imx/Kconfig
>> @@ -48,6 +48,7 @@ config DRM_IMX_IPUV3
>>   
>>   config DRM_IMX_HDMI
>>   	tristate "Freescale i.MX DRM HDMI"
>> +	select DRM_DW_HDMI
>>   	depends on DRM_IMX
>>   	help
>>   	  Choose this if you want to use HDMI on i.MX6.
> I'd recommend that if you want to select DRM_DW_HDMI, then don't give
> DRM_DW_HDMI a prompt message.  I assume you're going to do something
> similar with your Rockchip driver too - in which case DRM_DW_HDMI is
> really about building a library module.
   Do you mean I just neet to do like bellow?

+
+config DRM_DW_HDMI
+	bool
+	depends on DRM
+	select DRM_KMS_HELPER



