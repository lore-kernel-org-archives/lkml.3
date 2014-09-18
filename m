Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaIRB0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:26:42 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:39123 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaIRB0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:26:41 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <5709549b40a86b2bef2310361582d06a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <541A34C3.6000400@rock-chips.com>
Date: Thu, 18 Sep 2014 09:26:27 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: max.schwarz@online.de, heiko@sntech.de, wsa@the-dreams.de,
        huangtao@rock-chips.com, cf@rock-chips.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: Re: About RK3288 i2c scl duty cycle
References: <2014091709302172205233@rock-chips.com> <CAD=FV=VEUVxxZ8ZP89qhSOmvX_LgMvnczNx17qdMTGCapZj3uw@mail.gmail.com>
In-Reply-To: <CAD=FV=VEUVxxZ8ZP89qhSOmvX_LgMvnczNx17qdMTGCapZj3uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add public list

On 2014/9/17 23:17, Doug Anderson wrote:
> Addy,
> 
> On Tue, Sep 16, 2014 at 6:30 PM, addy.ke@rock-chips.com
> <addy.ke@rock-chips.com> wrote:
>> hi, all
> 
> Any reason why you didn't add some public lists?  It seems like this
> is a perfect discussion for linux-i2c.
> 
> 
>> According to i2c-bus specification(version2.1, page 32, Table5, FAST-MODE):
>> The minimum LOW period of the scl clock is <1.3us>, and the minimum HIGH
>> period of the scl clock is <0.6us>.
>> T(min_low) : T(min_high)  ~= 2 : 1
>>
>> If <DIVH = DIVL> in fast mode(scl rate = 400Khz)
>> 1）Under ideal conditions, T(scl_low) = T(scl_high) = <1.25us>
>> 2）Our measurement, T(scl_low) = <1.3us>, T(scl_high) = <1.25us>
>>
>> The low period of the scl clock is critical.
>>
>> Do we need set <DIVL:DIVH = 1 : 2>  to increase T(scl_low)?   // T(scl_low )
>> : T(scl_High) = 2 : 1
> 
> I can't say I've ever looked at that pat of the i2c spec before, but
> what you say seems reasonable to me.  ...well for 400kHz, at least.
> At 100kHz you shouldn't use the same 2:1 ratio.

Yes, in normal-mode(100K) we can be only used 1:1 ratio.
But in FAST-MODE maybe we must use 2:1 ratio.
----
In Table 5(Characteristics of the SDA and SCL bus lines for F/S-mode I2C-bus devices)

1)FAST-MODE(400K):
  The minimum LOW period of the scl clock                1.3us
  the minimum HIGH period of the scl clock               0.6us
  T(min_low) : T(min_high)  ~= 2 : 1

  But I can't see any ratio about In FAST-mode(400k) and Normal-mode(100k).
2)Normal-MODE(100K):
  The minimum LOW period of the scl clock                4.7us
  the minimum HIGH period of the scl clock               4.0us
  T(min_low) : T(min_high)  ~= 1 : 1

3) HS-mode(3.4M)
  ratio of 1 to 2 is required, decribed as follows:
  Hs-mode master devices generate a serial clock signal with a HIGH to LOW ratio of 1 to 2
> 
> I'm sure other drivers have solved this problem too, so maybe you can
> copy some code.  In i2c-designware-core.c you can see them doing all
> the calculations you need, I think.
> 
> 
> -Doug
> 
> 
> 

