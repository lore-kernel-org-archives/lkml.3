Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaLCJne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:43:34 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:40610 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaLCJnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:43:32 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <f815395be09710401e38b5c589770516>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547EDB3B.9010907@rock-chips.com>
Date: Wed, 03 Dec 2014 17:43:23 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>, rmk+kernel@arm.linux.org.uk,
        jay.xu@rock-chips.com, devicetree@vger.kernel.org,
        Zubair.Kakakhel@imgtec.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, Dave Airlie <airlied@redhat.com>,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        vladimir_zapolskiy@mentor.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v15 06/12] dt-bindings: add document for dw_hdmi
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com> <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com> <1417544629.3411.15.camel@pengutronix.de> <547E5F51.2090800@rock-chips.com> <1417598398.5124.2.camel@pengutronix.de>
In-Reply-To: <1417598398.5124.2.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:
On 2014年12月03日 17:19, Philipp Zabel wrote:
> Hi Andy,
>
> Am Mittwoch, den 03.12.2014, 08:54 +0800 schrieb Andy Yan:
>>>> +Required properities:
>>>> +- compatible: platform specific such as:
>>>> +   * "fsl,imx6q-hdmi"
>>>> +   * "fsl,imx6dl-hdmi"
>>>> +   * "rockchip,rk3288-dw-hdmi"
>>> I think we should add a common compatible value "snps,dw-hdmi-tx" here:
>>>
>>> 	compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi-tx";
>>>
>>        How about "snps,dw-hdmi", because the driver is not only about
>>     hdmi tx, but also include hdmi phy.
> Synopsys call the whole module
> "DesignWare HDMI Transmitter (TX) IP Solution":
>
> https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_14_csds_tx
> https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_20_csds_tx
>
> That includes the PHY. I'd prefer keeping the -tx in there to
> differentiate from a possible future "snps,dw-hdmi-rx":
>
> https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_14_csds_rx
> https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_20_csds_rx

   Ok, I will add the compatible "snps, dw-hdmi-tx",
    So do I need to add this value to imx6dl.dtsi?
>>         If we add such compatible value, do we have to implement another
>>      platform driver like dw_hdmi-pltfm.c with the
>> compatible="snps,dw-hdmi" ,
>>      or just include the compatible value in dw_hdmi-imx.c and
>> dw_hdmi-rockchip.c?
> That common compatible doesn't have to be used by any driver. It's just
> there to show these are the same/similar IP core.
> If a common driver without any SoC specific knowledge could be written,
> that one would match against the common compatible.
>
> regards
> Philipp
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


