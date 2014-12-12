Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbaLLDn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:43:59 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:51514 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934004AbaLLDn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:43:57 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <38459e60bf6b8971419f2de72e86bc46>
X-DNS-TYPE: 0
Message-ID: <548A645D.8010608@rock-chips.com>
Date: Fri, 12 Dec 2014 11:43:25 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>, jwerner@chromium.org,
        Olof Johansson <olof@lixom.net>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com>	<1418291722-25448-2-git-send-email-lyz@rock-chips.com> <CAD=FV=WcAJAgj2triu1W4863BT1ew2wf-z6YNHHwiDKpnYmK4w@mail.gmail.com>
In-Reply-To: <CAD=FV=WcAJAgj2triu1W4863BT1ew2wf-z6YNHHwiDKpnYmK4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug:

On 2014/12/12 2:09, Doug Anderson wrote:
> Yunzhi,
>
> On Thu, Dec 11, 2014 at 1:55 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
>> +               rk_phy->clk = of_clk_get(child, 0);
>> +               if (IS_ERR(rk_phy->clk)) {
>> +                       dev_warn(dev, "failed to get clock\n");
>> +                       rk_phy->clk = NULL;
>> +               }
> The device tree bindings don't specify a clock and the "dtsi" added to
> rk3288 don't reference a clock.  Take that code out and avoid a
> warning in the logs at bootup.
>
> ...or should there be a clock?
Actually, there is a clk gating control bit in CRU for each usb phy and I
think we should manage these clocks by the usb phy driver, so I will add
clock property to usb PHYs nodes in next version of patche set.

>
>> +               rk_phy->phy = devm_phy_create(dev, NULL, &ops);
> This has the wrong number of arguments.  Even before the change that
> added the 4th argument, this is still wrong because "ops" is supposed
> to be the 2nd argument, not the 3rd.
>
> ...so I'm confused how this compiled for you.  I think this ought to be:
>
> rk_phy->phy = devm_phy_create(dev, child, &ops, NULL);
>
> ...but please correct me if I'm mistaken!
>
>
>


