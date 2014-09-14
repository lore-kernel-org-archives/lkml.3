Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaINC1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:27:54 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:60035 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbaINC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:27:53 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <cc660a733522e6950bf86bd4049466ab>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5414FD1F.6020603@rock-chips.com>
Date: Sun, 14 Sep 2014 10:27:43 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Subject: Re: [PATCH 5/5] ASoC: rockchip-i2s: enable "hclk" for rockchip I2S
 controller
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com> <1410568993-21874-1-git-send-email-jay.xu@rock-chips.com> <20140913163749.GK7960@sirena.org.uk>
In-Reply-To: <20140913163749.GK7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/14/2014 12:37 AM, Mark Brown 写道:
> On Sat, Sep 13, 2014 at 08:43:13AM +0800, Jianqun wrote:
> 
>> +++ b/sound/soc/rockchip/rockchip_i2s.c
>> @@ -423,6 +423,11 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
>>  		dev_err(&pdev->dev, "Can't retrieve i2s bus clock\n");
>>  		return PTR_ERR(i2s->hclk);
>>  	}
>> +	ret = clk_prepare_enable(i2s->hclk);
>> +	if (ret) {
>> +		dev_err(i2s->dev, "hclock enable failed %d\n", ret);
>> +		return ret;
>> +	}
> 
> BTW: you're also missing a clk_disable_unprepare() in the remove path
> here, please send a followup fixing that.
remove function has done the clk_disable_unprepare for "hclk".

One more thing, since "i2s_clk" is enabled at runtime_resume, and is disabled in runtime_suspend,
hasn't enable in probe, so do the "i2s_clk" to be disabled in remove ?
The current driver has disable in remove.
> 
