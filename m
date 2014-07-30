Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaG3JAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:00:23 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:52194 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaG3JAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:00:22 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: jarkko.nikula@linux.intel.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <5690a384de205775823593d2234d35b2>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53D8B420.9050504@rock-chips.com>
Date: Wed, 30 Jul 2014 17:00:16 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>, broonie@kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        tbleung@chromium.org, dgreid@chromium.org, kevin.strasser@intel.com,
        swarren@nvidia.com, ralph.birt@maximintegrated.com
CC: heiko@sntech.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: max98090 not need to return fail if fail to request
 hpdet irq.
References: <1406685010-25108-1-git-send-email-xjq@rock-chips.com> <53D890C7.4080201@linux.intel.com>
In-Reply-To: <53D890C7.4080201@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014年07月30日 14:29, Jarkko Nikula wrote:
> On 07/30/2014 04:50 AM, jianqun wrote:
>> From: xujianqun <xjq@rock-chips.com>
>>
>> Since hardware may not MUST to use IRQ pin of max98090 as jack detect, the
>> driver can work well without it, can report jack trigger to CPU by a GPIO.
>>
>> But here driver will register fail caused by failed to request irq.
>>
>> Signed-off-by: xujianqun <xjq@rock-chips.com>
>> ---
>>   sound/soc/codecs/max98090.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
>> index 566919c..bc124ff 100644
>> --- a/sound/soc/codecs/max98090.c
>> +++ b/sound/soc/codecs/max98090.c
>> @@ -2515,6 +2515,8 @@ static int max98090_probe(struct snd_soc_codec *codec)
>>         max98090_add_widgets(codec);
>>   +    return 0;
>> +
>>   err_access:
>>       return ret;
>>   }
> I would say it's better to call request_threaded_irq() conditionally when max98090->irq is valid in the same max98090_probe(). Also code should return instantly in case of request_threaded_irq() fails for valid irq.
> 
> Now code is still printing needless error message in case max98090->irq is invalid or not specified and continue probing in case request_threaded_irq() fails for valid irq.
> 

Add a valid check could be better, thanks Jarkko~

I'm working a board with max98090, this is a really problem for me now,
the IRQ shouldn't cause the driver fail to register.

-- 
-------------
许 剑 群 Jay
Rockchip Electronics Co.Ltd
****************************************************************************
*IMPORTANT NOTICE:*This email is from Fuzhou Rockchip Electronics Co.,
Ltd .The contents of this email and any attachments may contain
information that is privileged, confidential and/or exempt from
disclosure under applicable law and relevant NDA. If you are not the
intended recipient, you are hereby notified that any disclosure,
copying, distribution, or use of the information is STRICTLY PROHIBITED.
Please immediately contact the sender as soon as possible and destroy
the material in its entirety in any format. Thank you.
****************************************************************************

