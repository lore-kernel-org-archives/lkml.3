Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaHGB1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:27:43 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:37642 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaHGB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:27:41 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-doc@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <3119fda7a75e0aa79266ec873d625351>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53E2D605.2000704@rock-chips.com>
Date: Thu, 07 Aug 2014 09:27:33 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJu?= =?UTF-8?B?ZXI=?= <heiko@sntech.de>,
        b.galvani@gmail.com, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kumar Gala <galak@codeaurora.org>, Eddie Cai <cf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Addy Ke <addy.ke@rock-chips.com>,
        =?UTF-8?B?6ZmI5riQ6aOe?= <cjf@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>	<1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com> <CAD=FV=V4Kp-H3CcAKZPV1jBnYX+Ntwvxx6RB13TLxS5RRPHTWA@mail.gmail.com>
In-Reply-To: <CAD=FV=V4Kp-H3CcAKZPV1jBnYX+Ntwvxx6RB13TLxS5RRPHTWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

在 2014年08月07日 06:46, Doug Anderson 写道:
> Caesar,
>
> On Thu, Jul 24, 2014 at 3:21 AM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
>> +static const struct rockchip_pwm_data pwm_data_v1 = {
>> +       .regs.duty = PWM_HRC,
>> +       .regs.period = PWM_LRC,
>> +       .regs.cntr = PWM_CNTR,
>> +       .regs.ctrl = PWM_CTRL,
>> +       .prescaler = PRESCALER,
>> +       .set_enable = rockchip_pwm_set_enable_v1,
>> +};
>> +
>> +static const struct rockchip_pwm_data pwm_data_v2 = {
>> +       .regs.duty = PWM_LRC,
>> +       .regs.period = PWM_HRC,
>> +       .regs.cntr = PWM_CNTR,
>> +       .regs.ctrl = PWM_CTRL,
>> +       .prescaler = PRESCALER-1,
>> +       .set_enable = rockchip_pwm_set_enable_v2,
>> +};
>> +
>> +static const struct rockchip_pwm_data pwm_data_vop = {
>> +       .regs.duty = PWM_LRC,
>> +       .regs.period = PWM_HRC,
>> +       .regs.cntr = PWM_CTRL,
>> +       .regs.ctrl = PWM_CNTR,
> Did you really mean to flip CTRL and CNTR here?  If so, that's super
> confusing and deserves a comment.  AKA, I think the above should not
> be:
>
>   +       .regs.cntr = PWM_CTRL,
>   +       .regs.ctrl = PWM_CNTR,
>
> ...but should be
>
>   +       .regs.cntr = PWM_CNTR,
>   +       .regs.ctrl = PWM_CTRL,
>
> If you didn't mean to flip CTRL and CNTR here, then just get rid of
> pwm_data_vop and refer to pwm_data_v2.  In fact, I'd suggest that you
> totally remove the "rockchip,vop-pwm" since there's nothing different
> between "rockchip,rk3288-pwm" and "rockchip,vop-pwm".

Sorry,I think it's no problem. the  "rockchip,rk3288-pwm" and 
"rockchip,vop-pwm" are seperate PWM controllers.
They are just different registers address between CNTR and CTRL .

>
> Have you validated Thierry's suggestion to allow you to access your
> memory range?
Yes,we have solve it in lcdc driver.
The Mark Yao have the  submission in [0].

[0]: https://lkml.org/lkml/2014/8/4/20
>
> -Doug
>
>
>


