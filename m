Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJ2BAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:00:34 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:40505 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJ2BAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:00:32 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jinkun.hong@rock-chips.com
X-FST-TO: jack.dai@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jinkun.hong@rock-chips.com
X-UNIQUE-TAG: <cefd307592dc76559f403d92b25ee31f>
X-DNS-TYPE: 0
Message-ID: <54503C19.9060607@rock-chips.com>
Date: Wed, 29 Oct 2014 09:00:09 +0800
From: Hong jinkun <jinkun.hong@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v7 1/3] power-domain: add power domain drivers for Rockchip
 platform
References: <1414135761-3406-1-git-send-email-jinkun.hong@rock-chips.com> <1414135761-3406-2-git-send-email-jinkun.hong@rock-chips.com> <20141024164431.GE19933@dtor-ws> <20141027233904.GD7594@dtor-ws>
In-Reply-To: <20141027233904.GD7594@dtor-ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014/10/28 7:39, Dmitry Torokhov 写道:
> On Fri, Oct 24, 2014 at 09:44:31AM -0700, Dmitry Torokhov wrote:
>> Hi Jinkun,
>>
>> On Fri, Oct 24, 2014 at 12:29:19AM -0700, jinkun.hong wrote:
>>> +static int rockchip_pd_power(struct rockchip_domain *pd, bool power_on)
>>> +{
>>> +	int ret = 0;
>>> +	struct rockchip_dev_entry *de;
>>> +
>>> +	mutex_lock(&pd->dev_lock);
>>> +	/* no clk, set power domain will fail */
>>> +	if (list_empty(&pd->dev_list)) {
>>> +		pr_err("%s: no devices in %s power domain\n", __func__,
>>> +			pd->base.name);
>>> +		goto out;
>>> +	}
>>> +
>>> +	list_for_each_entry(de, &pd->dev_list, node) {
>>> +		pm_clk_resume(de->dev);
>>> +	}
>>> +
>>> +	ret = rockchip_pmu_set_power_domain(pd, power_on);
>>> +
>>> +	list_for_each_entry(de, &pd->dev_list, node) {
>>> +		pm_clk_suspend(de->dev);
>>> +	}
>>> +out:
>>> +	mutex_unlock(&pd->dev_lock);
>>> +	return ret;
>>> +}
>> For my education, could you please tell me why we need to enable all
>> clocks of all devices in a power domain when we are talking to the PMU
>> and then turn them immediately off?
Sorry for late reply.RK3288 reset circuit are first asynchronous reset 
and then sync revoked.
All reset revocation actions are needed to synchronize the clocks.
If there is no clock open, power_up reset will cause the corresponding 
reset can not be undone, there will be risks.
>> Would not we want to enable clocks
>> in start()) callbacks, like Ulf mentioned?
Can you tell me which one patch it. Thank you!
> Jinkun, any update on this question?
>
> Thanks.
>


