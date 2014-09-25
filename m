Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbaIYEgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:36:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52936 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaIYEgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <5423765B.8000706@rock-chips.com>
References: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=WiHR+KcTWHnma6TdPQcc3oc4wqAofj5kF=Sgec_5kGAQ@mail.gmail.com>
	<54227F93.7000507@rock-chips.com>
	<CAD=FV=Uq9AteUcpMvcU5tmyGZbVYWM6PNmevZXSVCkYB8rqSsQ@mail.gmail.com>
	<5423765B.8000706@rock-chips.com>
Date: Wed, 24 Sep 2014 21:36:38 -0700
X-Google-Sender-Auth: qt13F5PDPIViaYdPRsMBy9saszU
Message-ID: <CAD=FV=Uuk1zBYn4NgcpDSHVfKeyw3MONO7roUNVSPSDDEyD=8Q@mail.gmail.com>
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

On Wed, Sep 24, 2014 at 6:56 PM, addy ke <addy.ke@rock-chips.com> wrote:
> In my measurement,all paramter but "Data hold time" are match the characteristics of SCL bus line.
> the measured value is 0.928us("data hold time on RK3X"  ~=  "the low period / 2")
> but the maximum value described in table is 0.9us
>
> About "Data hold time", there are described in I2C specification:
> - for CBUS compatible masters for I2C-bus deivices
> - the maximum data hold time has only be met if the device does not stretch the LOW period of the SCL signal.
>
> I have tested on RK3288-Pinky board, there are no error.
> But I don't known whether this paramter will affect i2c communications.

I'll have to spend more time tomorrow to really understand this, but
if changing the code to bias towards slightly longer "high" times
instead of "low" times helps fix it then that's fine with me.
