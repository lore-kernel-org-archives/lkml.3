Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaIYVwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:52:12 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:58691 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIYVwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Uuk1zBYn4NgcpDSHVfKeyw3MONO7roUNVSPSDDEyD=8Q@mail.gmail.com>
References: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=WiHR+KcTWHnma6TdPQcc3oc4wqAofj5kF=Sgec_5kGAQ@mail.gmail.com>
	<54227F93.7000507@rock-chips.com>
	<CAD=FV=Uq9AteUcpMvcU5tmyGZbVYWM6PNmevZXSVCkYB8rqSsQ@mail.gmail.com>
	<5423765B.8000706@rock-chips.com>
	<CAD=FV=Uuk1zBYn4NgcpDSHVfKeyw3MONO7roUNVSPSDDEyD=8Q@mail.gmail.com>
Date: Thu, 25 Sep 2014 14:52:08 -0700
X-Google-Sender-Auth: coV9_90vM2jG082Hm1Ne72LDR_0
Message-ID: <CAD=FV=UkAcR8b+T_Dvoy9STDfzyC8QVSawihoHLYyHFJ6bfXxQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: adjust the LOW divison based on
 characteristics of SCL
From: Doug Anderson <dianders@chromium.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Wed, Sep 24, 2014 at 9:36 PM, Doug Anderson <dianders@chromium.org> wrote:
> Addy,
>
> On Wed, Sep 24, 2014 at 6:56 PM, addy ke <addy.ke@rock-chips.com> wrote:
>> In my measurement,all paramter but "Data hold time" are match the characteristics of SCL bus line.
>> the measured value is 0.928us("data hold time on RK3X"  ~=  "the low period / 2")
>> but the maximum value described in table is 0.9us
>>
>> About "Data hold time", there are described in I2C specification:
>> - for CBUS compatible masters for I2C-bus deivices
>> - the maximum data hold time has only be met if the device does not stretch the LOW period of the SCL signal.
>>
>> I have tested on RK3288-Pinky board, there are no error.
>> But I don't known whether this paramter will affect i2c communications.
>
> I'll have to spend more time tomorrow to really understand this, but
> if changing the code to bias towards slightly longer "high" times
> instead of "low" times helps fix it then that's fine with me.

So what you're saying is that you're seeing a case where the clock
goes low and the data is not valid until .928us.  Is this data that is
being driven by the master or data that is being driven by the slave?

Do you know why the data takes so long to be valid?  Maybe you can
email me some of the waveforms and I can try to help you debug it.


In any case it sounds like the the "data hold time" problem is
unrelated to the clock ratio problem (right?), so maybe you could send
out patch v2?

-Doug

P.S. I checked the Rockchip TRM and it claims 400kHz maximum i2c.  I
think that means you can just remove all of the "fast mode plus" and
"high speed mode" clock rates from your table.
