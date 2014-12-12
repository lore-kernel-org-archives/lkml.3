Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbaLLFtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:49:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35139 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaLLFto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:49:44 -0500
Message-ID: <548A8155.8080809@ti.com>
Date: Fri, 12 Dec 2014 11:17:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Yunzhi Li <lyz@rock-chips.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        <jwerner@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com>	<1418291722-25448-2-git-send-email-lyz@rock-chips.com>	<548971AF.1020506@ti.com> <CAD=FV=XTYmzxvteNip2gtuDSSEWph-vY=BOPejHa1Z5KS2Kf6Q@mail.gmail.com>
In-Reply-To: <CAD=FV=XTYmzxvteNip2gtuDSSEWph-vY=BOPejHa1Z5KS2Kf6Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 12 December 2014 12:11 AM, Doug Anderson wrote:
> Kishon,
> 
> On Thu, Dec 11, 2014 at 2:27 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> I didn't mean that. You can get rid of this entire xlate stuff if you use
>> something like below
>>
>> phy@xxx {
>>         compatible = "";
>>         phy1:usb_phy {
>>         }
>>         phy2:usb_phy {
>>         };
>> };
>>
>>
>> usb@xx {
>>         compatible = "";
>>         phys = <&phy1>; //doesn't need xlate
>>         /* this needs xlate
>>            phys = <&phy 1>;
>>         */
>>         phy-names = "phy";
>> };
> 
> Is the syntax you proposed really better?  Are you saying that you
> advocate never using "#phy-cells" other than 0 for new bindings?  Is

No. It can still be used for configuring the PHY. For example, in the case of
PIPE3 PHY we configure it to USB PHY, SATA PHY or PCIE PHY depending on to
which controller the PHY is connected to.

I feel using phy-cells just for differentiating the PHY is pointless when you
have a separate node for each PHY.

Thanks
Kishon
