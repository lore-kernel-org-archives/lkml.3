Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbaGBBKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:10:10 -0400
Received: from regular2.263xmail.com ([211.157.152.4]:43135 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233AbaGBBKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:10:06 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 21:10:05 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: huangtao@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: huangtao@rock-chips.com
X-UNIQUE-TAG: <9790f353cdf8195cdadc56e7318f3e83>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53B359FD.3080809@rock-chips.com>
Date: Wed, 02 Jul 2014 09:01:49 +0800
From: Huang Tao <huangtao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: jianqun <xjq@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        zhangqing@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com
Subject: Re: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com> <1404204458-30881-1-git-send-email-xjq@rock-chips.com> <20140701170747.GA15028@sirena.org.uk>
In-Reply-To: <20140701170747.GA15028@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark:

于 2014年07月02日 01:07, Mark Brown 写道:
>> +static inline void i2s_writel(struct rk_i2s_dev *i2s, u32 value,
>> > +			      unsigned int offset)
>> > +{
>> > +	writel_relaxed(value, i2s->regs + offset);
>> > +}
>> > +
>> > +static inline u32 i2s_readl(struct rk_i2s_dev *i2s, unsigned int offset)
>> > +{
>> > +	return readl_relaxed(i2s->regs + offset);
>> > +}
> Perhaps use regmap?  The main advantage would be the debug
> infrastructure, though you could also use _update_bits() to reduce the
> amount of time spent locked.
>
Are you sure? This is a I2S driver, we can write the register directly,
do not through I2C or SPI bus.
Write a register is only a few instructions on ARM, but write through
regmap, it may take a long path.
I think it will just consume CPU power and make the whole thing more
complex.
Could you tell me what benefits we can get if use regmap? Or something I
just missing?

