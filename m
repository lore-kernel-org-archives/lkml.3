Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaGBK55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:57:57 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:38248 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaGBK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:57:54 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: huangtao@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <b432b527b264dded77e2bddbc2c9a331>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53B3E5AA.9060300@rock-chips.com>
Date: Wed, 02 Jul 2014 18:57:46 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Huang Tao <huangtao@rock-chips.com>, Mark Brown <broonie@kernel.org>
CC: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        kfx@rock-chips.com
Subject: Re: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com> <1404204458-30881-1-git-send-email-xjq@rock-chips.com> <20140701170747.GA15028@sirena.org.uk> <53B359FD.3080809@rock-chips.com>
In-Reply-To: <53B359FD.3080809@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark:

Since regmap_update_bits is int style, I have to error check every time after call it.
Also I find that the tegra_i2s.c call the function without error checking,

Could you tell me the right way to handle the regmap_update_bits ?


Best Regards

On 2014年07月02日 09:01, Huang Tao wrote:
> Hi, Mark:
> 
> 于 2014年07月02日 01:07, Mark Brown 写道:
>>> +static inline void i2s_writel(struct rk_i2s_dev *i2s, u32 value,
>>>> +			      unsigned int offset)
>>>> +{
>>>> +	writel_relaxed(value, i2s->regs + offset);
>>>> +}
>>>> +
>>>> +static inline u32 i2s_readl(struct rk_i2s_dev *i2s, unsigned int offset)
>>>> +{
>>>> +	return readl_relaxed(i2s->regs + offset);
>>>> +}
>> Perhaps use regmap?  The main advantage would be the debug
>> infrastructure, though you could also use _update_bits() to reduce the
>> amount of time spent locked.
>>
> Are you sure? This is a I2S driver, we can write the register directly,
> do not through I2C or SPI bus.
> Write a register is only a few instructions on ARM, but write through
> regmap, it may take a long path.
> I think it will just consume CPU power and make the whole thing more
> complex.
> Could you tell me what benefits we can get if use regmap? Or something I
> just missing?
> 
> 
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

