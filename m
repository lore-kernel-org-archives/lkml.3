Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaHGEFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:05:48 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:38974 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaHGEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:05:45 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-doc@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <03b042b76e73a2fae62a3450b7aef120>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53E2FB0E.40301@rock-chips.com>
Date: Thu, 07 Aug 2014 12:05:34 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJu?= =?UTF-8?B?ZXI=?= <heiko@sntech.de>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
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
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>	<1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com>	<CAD=FV=V4Kp-H3CcAKZPV1jBnYX+Ntwvxx6RB13TLxS5RRPHTWA@mail.gmail.com>	<53E2D605.2000704@rock-chips.com>	<CAD=FV=Xw8tz2keCUtO+qYUmnuv=+DPGZjY9-j_2XmAcP3Luzjg@mail.gmail.com>	<53E2F11A.1040109@rock-chips.com>	<CAD=FV=Wuj2_q+iW2EAj7w8TvgS=C2juSu+h_iG24NvPk4UqhKQ@mail.gmail.com>	<53E2F471.6020701@rock-chips.com> <CAD=FV=XhN__4hoGu=3hSXP69-T6T7KTxRiFY4Ac4bNJAYf+6jQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XhN__4hoGu=3hSXP69-T6T7KTxRiFY4Ac4bNJAYf+6jQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,
在 2014年08月07日 11:46, Doug Anderson 写道:
> Caesar,
>
> On Wed, Aug 6, 2014 at 8:37 PM, caesar <caesar.wang@rock-chips.com> wrote:
>> Doug,
>>
>> 在 2014年08月07日 11:26, Doug Anderson 写道:
>>
>>> caesar,
>>>
>>> On Wed, Aug 6, 2014 at 8:23 PM, caesar <caesar.wang@rock-chips.com> wrote:
>>>> 在 2014年08月07日 10:16, Doug Anderson 写道:
>>>>
>>>>> Caesar,
>>>>>
>>>>> On Wed, Aug 6, 2014 at 6:27 PM, caesar <caesar.wang@rock-chips.com>
>>>>> wrote:
>>>>>> Doug,
>>>>>>
>>>>>> 在 2014年08月07日 06:46, Doug Anderson 写道:
>>>>>>
>>>>>>> Caesar,
>>>>>>>
>>>>>>> On Thu, Jul 24, 2014 at 3:21 AM, Caesar Wang
>>>>>>> <caesar.wang@rock-chips.com>
>>>>>>> wrote:
>>>>>>>> +static const struct rockchip_pwm_data pwm_data_v1 = {
>>>>>>>> +       .regs.duty = PWM_HRC,
>>>>>>>> +       .regs.period = PWM_LRC,
>>>>>>>> +       .regs.cntr = PWM_CNTR,
>>>>>>>> +       .regs.ctrl = PWM_CTRL,
>>>>>>>> +       .prescaler = PRESCALER,
>>>>>>>> +       .set_enable = rockchip_pwm_set_enable_v1,
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +static const struct rockchip_pwm_data pwm_data_v2 = {
>>>>>>>> +       .regs.duty = PWM_LRC,
>>>>>>>> +       .regs.period = PWM_HRC,
>>>>>>>> +       .regs.cntr = PWM_CNTR,
>>>>>>>> +       .regs.ctrl = PWM_CTRL,
>>>>>>>> +       .prescaler = PRESCALER-1,
>>>>>>>> +       .set_enable = rockchip_pwm_set_enable_v2,
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +static const struct rockchip_pwm_data pwm_data_vop = {
>>>>>>>> +       .regs.duty = PWM_LRC,
>>>>>>>> +       .regs.period = PWM_HRC,
>>>>>>>> +       .regs.cntr = PWM_CTRL,
>>>>>>>> +       .regs.ctrl = PWM_CNTR,
>>>>>>> Did you really mean to flip CTRL and CNTR here?  If so, that's super
>>>>>>> confusing and deserves a comment.  AKA, I think the above should not
>>>>>>> be:
>>>>>>>
>>>>>>>      +       .regs.cntr = PWM_CTRL,
>>>>>>>      +       .regs.ctrl = PWM_CNTR,
>>>>>>>
>>>>>>> ...but should be
>>>>>>>
>>>>>>>      +       .regs.cntr = PWM_CNTR,
>>>>>>>      +       .regs.ctrl = PWM_CTRL,
>>>>>>>
>>>>>>> If you didn't mean to flip CTRL and CNTR here, then just get rid of
>>>>>>> pwm_data_vop and refer to pwm_data_v2.  In fact, I'd suggest that you
>>>>>>> totally remove the "rockchip,vop-pwm" since there's nothing different
>>>>>>> between "rockchip,rk3288-pwm" and "rockchip,vop-pwm".
>>>>>>
>>>>>> Sorry,I think it's no problem. the  "rockchip,rk3288-pwm" and
>>>>>> "rockchip,vop-pwm" are seperate PWM controllers.
>>>>>> They are just different registers address between CNTR and CTRL .
>>>>> OK, I looked up in the TRM.  Right, the CNTR and CTRL are flipped on
>>>>> the vop.  So I think that the only change you need is to add:
>>>>>
>>>>> #define PWM_VOP_CTRL  0x00
>>>>> #define PWM_VOP_CNTR  0x0c
>>>>>
>>>>> ...then use these new #defines for the vop structure.
>>>>>
>>>>>
>>>>> As you have the code written right now it's very confusing.  The new
>>>>> #defines will fix this.
>>>>>
>>>> yeah, I think they can be used in the same context.
>>>>
>>>> I will fix it in patch v5 if it is really need.
>>> I think you should fix this, but if Thierry doesn't think so then it's
>>> really his decision.
>> I remember In patch v2 [1],Thierry suggests me to fix it so if I have no to
>> get wrong.
>>
>> [1]: https://lkml.org/lkml/2014/7/21/113
> I think Thierry might not have realized that they were flipped...
>
> -Doug
>
>
>
Maybe you are right.
I will sent patch v5 fix the about tomorrow if it has no other problems.


