Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaIZBlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:41:22 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:41570 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaIZBlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:41:20 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <7576bc53d85c2883ffd603a22578128c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5424C41F.8030508@rock-chips.com>
Date: Fri, 26 Sep 2014 09:40:47 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH] i2c: rk3x: adjust the LOW divison based on characteristics
 of SCL
References: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>	<CAD=FV=WiHR+KcTWHnma6TdPQcc3oc4wqAofj5kF=Sgec_5kGAQ@mail.gmail.com>	<54227F93.7000507@rock-chips.com>	<CAD=FV=Uq9AteUcpMvcU5tmyGZbVYWM6PNmevZXSVCkYB8rqSsQ@mail.gmail.com>	<5423765B.8000706@rock-chips.com>	<CAD=FV=Uuk1zBYn4NgcpDSHVfKeyw3MONO7roUNVSPSDDEyD=8Q@mail.gmail.com> <CAD=FV=UkAcR8b+T_Dvoy9STDfzyC8QVSawihoHLYyHFJ6bfXxQ@mail.gmail.com>
In-Reply-To: <CAD=FV=UkAcR8b+T_Dvoy9STDfzyC8QVSawihoHLYyHFJ6bfXxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Doug

On 2014/9/26 5:52, Doug Anderson wrote:
> Addy,
> 
> On Wed, Sep 24, 2014 at 9:36 PM, Doug Anderson <dianders@chromium.org> wrote:
>> Addy,
>>
>> On Wed, Sep 24, 2014 at 6:56 PM, addy ke <addy.ke@rock-chips.com> wrote:
>>> In my measurement,all paramter but "Data hold time" are match the characteristics of SCL bus line.
>>> the measured value is 0.928us("data hold time on RK3X"  ~=  "the low period / 2")
>>> but the maximum value described in table is 0.9us
>>>
>>> About "Data hold time", there are described in I2C specification:
>>> - for CBUS compatible masters for I2C-bus deivices
>>> - the maximum data hold time has only be met if the device does not stretch the LOW period of the SCL signal.
>>>
>>> I have tested on RK3288-Pinky board, there are no error.
>>> But I don't known whether this paramter will affect i2c communications.
>>
>> I'll have to spend more time tomorrow to really understand this, but
>> if changing the code to bias towards slightly longer "high" times
>> instead of "low" times helps fix it then that's fine with me.
> 
> So what you're saying is that you're seeing a case where the clock
> goes low and the data is not valid until .928us.  Is this data that is
> being driven by the master or data that is being driven by the slave?
> 
It is driven by the master and will be release at half of LOW period in our IC design.

> Do you know why the data takes so long to be valid?  Maybe you can
> email me some of the waveforms and I can try to help you debug it.
> 
sure, I will email the I2C signal test report table right now.
> 
> In any case it sounds like the the "data hold time" problem is
> unrelated to the clock ratio problem (right?), so maybe you could send
> out patch v2?
> 
Ok, I will send patch v2 today.
thanks.

> -Doug
> 
> P.S. I checked the Rockchip TRM and it claims 400kHz maximum i2c.  I
> think that means you can just remove all of the "fast mode plus" and
> "high speed mode" clock rates from your table.
> 
Ok.
> 
> 

