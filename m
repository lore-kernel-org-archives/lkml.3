Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaINC3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:29:12 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:42216 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbaINC3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:29:11 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <c8401aa6426dd04bbfb95718bd8120da>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5414FD6E.2050006@rock-chips.com>
Date: Sun, 14 Sep 2014 10:29:02 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jianqun <jay.xu@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
CC: huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH 4/5] ASoC: rockchip-i2s: fix registers' property of rockchip
 i2s controller
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com> <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com> <5414AFA6.9060904@cogentembedded.com>
In-Reply-To: <5414AFA6.9060904@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/14/2014 04:57 AM, Sergei Shtylyov 写道:
> Hello.
> 
> On 9/13/2014 3:42 AM, Jianqun wrote:
> 
>> Reference rockchip I2S controller TRM, modify some registers' property
>> I2S_FIFOLR: read / write, but not volatile, not precious
>> I2S_INTSR: read / write
>> I2S_CLR: volatile, register value will be cleared by read
> 
>> Test on RK3288 with max98090.
> 
>> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
>> ---
>>   sound/soc/rockchip/rockchip_i2s.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
>> diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
>> index 1b9b404..6595383 100644
>> --- a/sound/soc/rockchip/rockchip_i2s.c
>> +++ b/sound/soc/rockchip/rockchip_i2s.c
> [...]
>> @@ -385,8 +387,6 @@ static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
>>   static bool rockchip_i2s_precious_reg(struct device *dev, unsigned int reg)
>>   {
>>       switch (reg) {
>> -    case I2S_FIFOLR:
>> -        return true;
>>       default:
>>           return false;
>>       }
> 
>    Shouldn't this be folded into simple *return* false now?
That is more reasonable, thank you.
> 
> WBR, Sergei
> 
> 
> 
> 
> 
