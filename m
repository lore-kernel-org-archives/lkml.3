Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaGUKjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:39:40 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:58344 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaGUKji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:39:38 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <b916368a92ab671b58584aa66c2bb86a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53CCEDCB.5010500@rock-chips.com>
Date: Mon, 21 Jul 2014 18:39:07 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: heiko@sntech.de, b.galvani@gmail.com, cf@rock-chips.com,
        huangtao@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] pwm: add this patch to introduce for rk-pwm and
 vop-pwm
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com> <1405774529-26027-2-git-send-email-caesar.wang@rock-chips.com> <20140721085716.GH8843@ulmo>
In-Reply-To: <20140721085716.GH8843@ulmo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

于 2014年07月21日 16:57, Thierry Reding 写道:
> On Sat, Jul 19, 2014 at 08:55:28PM +0800, Caesar Wang wrote:
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   Documentation/devicetree/bindings/pwm/pwm-rockchip.txt | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
>> index 3182126..bb6e7f1 100644
>> --- a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
>> +++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
>> @@ -1,11 +1,14 @@
>>   Rockchip PWM controller
>>   
>>   Required properties:
>> - - compatible: should be "rockchip,rk2928-pwm"
>> - - reg: physical base address and length of the controller's registers
>> - - clocks: phandle and clock specifier of the PWM reference clock
>> - - #pwm-cells: should be 2. See pwm.txt in this directory for a
>> -   description of the cell format.
> Can you please stick to the original format rather than removing the
> space in the first column? It makes it difficult to see what's being
> changed by this patch.
ok，
>> +- compatible: should be "rockchip,<name>-pwm"should be one of following:
> I think it should be either 'should be "rockchip,<name>-pwm"' or 'should
> be one of the following', not both.
Seems reasonable.
>
>> +    "rockchip,rk2928-pwm" - support the old version PWM for RK29xx,RK3066,RK3188 SoCs.
>> +    "rockchip,rk3288-pwm" - support the new version PWM for RK3036,RK3288 SoCs.
>> +    "rockchip,vop-pwm" - support rockchip integrated VOP-PWM for RK32 SoCs.
> "old version PWM" and "new version PWM" can be dropped. Maybe:
>
> 	"rockchip,rk2928-pwm": found on RK29xx, RK3066 and RK3188 SoCs
> 	"rockchip,rk3288-pwm": found on RK3036 and RK3288 SoCs
> 	"rockchip,vop-pwm": found integrated in VOP on RK32xx SoCs
>
> ? Could you explain a little what this VOP is? Also since the above says
> that "rockchip,rk3288-pwm" is supported on RK3036, the compatible value
> should really be "rockchip,rk3036-pwm" since we usually list the chip
> that an IP block was first used in (I'm assuming here that RK3036 is
> older than RK3288).
the SoC rk3036 is newer than rk3288. Maybe I will remove the rk3036.
It's the genenation Soc.

VOP is the display interface from memory frame buffer to display device 
(LCD panel, LVDS,MIPI, eDP, HDMI and TV set).
VOP is connected to an AHB bus through an AHB slave and AXI bus through 
an AXI master.
The register setting is configured through the AHB slave interface and 
the display frame data
is read through the AXI master interface.
Furthermore, there is adata path between IEP and VOP, which can provide 
frame data from IEP to VOP.

If you are interested in it,I will sent the vop doc for you and explain it.
>> +- reg: physical base address and length of the controller's registers.
>> +- clocks: phandle and clock specifier of the PWM reference clock.
>> +- #pwm-cells: should be 2. See pwm.txt in this directory for a
>> +  description of the cell format.
> These are all unchanged (except for the first column's space being
> removed and the full-stops for reg and clocks properties). Please keep
> with the original formatting so that it becomes obvious what the patch
> changes.
>
> Thierry
I will fix this and the other issuses in v3,thanks.

Caesar

