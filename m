Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaLCNUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:20:35 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:44647 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaLCNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:20:33 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <6ad9ab66f42dc741646a4fc1dcdf0c87>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547F0E06.5040106@rock-chips.com>
Date: Wed, 03 Dec 2014 21:20:06 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
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
        Mark Rutland <mark.rutland@arm.com>, vladimir_zapolskiy@mentor.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v15 12/12] drm: bridge/dw_hdmi: add rockchip rk3288 support
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>			 <1417506327-18908-1-git-send-email-andy.yan@rock-chips.com>		 <1417515882.3411.8.camel@pengutronix.de> <547DB1ED.7000409@rock-chips.com>	 <1417525257.3411.12.camel@pengutronix.de> <547F02CF.9010804@rock-chips.com> <1417612197.5124.12.camel@pengutronix.de>
In-Reply-To: <1417612197.5124.12.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:
On 2014年12月03日 21:09, Philipp Zabel wrote:
> Hi Andy,
>
> Am Mittwoch, den 03.12.2014, 20:32 +0800 schrieb Andy Yan:
>>> My question is not about the available gates at the SoC level, but about
>>> the actual clock inputs from point of view of the HDMI TX IP.
>>>
>>> It could be that the hdmi_ctrl_clk gates all inputs to the module and
>>> bus clocks together. If so, you could just reuse "isfr" and "iahb" and
>>> set it to the same clock. If not, we'd need to think of something else.
>>> Unfortunately I don't have any Synopsys documentation of the HDMI TX at
>>> that level.
>>      After confirming with the IC designer, we finally make clear that
>>      Rockchip RK3288 almost use the same clock design with imx:
>>      clk-----iahbclk, used for hdmi module and bus
>>      hdcp_clk-----isfrclk, used for hdcp and i2cm
>>      cecclk -----cecclk, but this clk can be gated on rockchip, this is
>> different with imx,
>>      but we don't handle the cec stuff now. So i will try to reuse the
>> imx clk binds. do you
>>     think that is ok?
> Thank you for taking the time to verify this. So we should move the
> clock handling out of the soc specific parts into the common driver and
> reuse the existing clock bindings ("iahb", "isfr").
> I'd suggest to add the "cec" clock now to the binding document as an
> optional clock, then you can already specify it in the rockchip dtsi.
   ok
>
> regards
> Philipp
>
>
>

