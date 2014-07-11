Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaGKANT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:13:19 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:32917 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGKANR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:13:17 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 20:13:16 EDT
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: jim.epost@gmail.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <dabc621f84f282cc6676cccb1659d34b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53BF2C18.10808@rock-chips.com>
Date: Fri, 11 Jul 2014 08:13:12 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, sfr@canb.auug.org.au,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Heiko <heiko@sntech.de>
Subject: Re: randconfig build error with next-20140710, in sound/soc/rockchip/rockchip_i2s.c
References: <CA+r1ZhgB=BG5jsSaWBLMvRUjZ=X4gKJzv6KysyvPSOtFuUTbng@mail.gmail.com> <53BF2AB8.7050307@rock-chips.com>
In-Reply-To: <53BF2AB8.7050307@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Heiko:

FYI

On 2014年07月11日 08:07, Jianqun wrote:
> Hi Heiko:
> 
> Is it caused by the headfile ?
> #include <linux/module.h>
> 
> Adviced by the maintainers, I tried not to include the headfile one by one, then to compile
> driver each time, I found that is success to compile it without module.h, of course
> I just compiled driver with command "ARCH=arm".
> 
> Look up the codes, I found the functions like
> 	MODULE_DESCRIPTION
> will be defined as
> 	#define MODULE_DESCRIPTION(x)	/* x */
> so the code in rockchip iis driver
> 	"MODULE_DESCRIPTION("ROCKCHIP IIS ASoC Interface") "
> will be defined as
> 	"ROCKCHIP IIS ASoC Interface"
> that should cause the error while robot to compile.
> 
> Am I right ?
> 
> If it is, do I need to make a new patch or just reply to the mail ? or how ...
> 
> 
> On 2014年07月10日 21:53, Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>> sound/soc/rockchip/rockchip_i2s.c:526:20: error: expected declaration specifiers
>>  or ‘...’ before string constant
>>  MODULE_DESCRIPTION("ROCKCHIP IIS ASoC Interface");
>>                     ^
>> sound/soc/rockchip/rockchip_i2s.c:527:15: error: expected declaration specifiers
>>  or ‘...’ before string constant
>>  MODULE_AUTHOR("jianqun <jay.xu@rock-chips.com>");
>>                ^
>> sound/soc/rockchip/rockchip_i2s.c:528:16: error: expected declaration specifiers
>>  or ‘...’ before string constant
>>  MODULE_LICENSE("GPL v2");
>>                 ^
>> sound/soc/rockchip/rockchip_i2s.c:529:14: error: expected declaration specifiers
>>  or ‘...’ before string constant
>>  MODULE_ALIAS("platform:" DRV_NAME);
>>               ^
>> sound/soc/rockchip/rockchip_i2s.c:530:1: warning: data definition has no type or
>>  storage class [enabled by default]
>>  MODULE_DEVICE_TABLE(of, rockchip_i2s_match);
>>  ^
>> sound/soc/rockchip/rockchip_i2s.c:530:1: error: type defaults to ‘int’
>> in declaration of ‘MODULE_DEVICE_TABLE’ [-Werror=implicit-int]
>> sound/soc/rockchip/rockchip_i2s.c:530:1: warning: parameter names (without types
>> ) in function declaration [enabled by default]
>> cc1: some warnings being treated as errors
>> make[3]: *** [sound/soc/rockchip/rockchip_i2s.o] Error 1
>>
> 

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

