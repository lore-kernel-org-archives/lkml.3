Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaICCBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:01:54 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:49192 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaICCBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:01:52 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <6755663fa93828723c47ed680a67144a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54067674.3040007@rock-chips.com>
Date: Wed, 03 Sep 2014 10:01:24 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v7 3/5] RTC: RK808: add RTC driver for RK808
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>	<1409564586-18421-1-git-send-email-zyw@rock-chips.com> <CAD=FV=X-hSHKe4_QRxFLejok-qVYM_FyXO7L7X6AzW8sTaVPnQ@mail.gmail.com>
In-Reply-To: <CAD=FV=X-hSHKe4_QRxFLejok-qVYM_FyXO7L7X6AzW8sTaVPnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/02/2014 11:58 AM, Doug Anderson wrote:
>> +static int rk808_rtc_probe(struct platform_device *pdev)
>> >+{
>> >+       struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
>> >+       struct rk808_rtc *rk808_rtc;
>> >+       struct rtc_time tm;
>> >+       int ret;
>> >+
>> >+       rk808_rtc = devm_kzalloc(&pdev->dev, sizeof(*rk808_rtc), GFP_KERNEL);
>> >+       if (rk808_rtc == NULL)
>> >+               return -ENOMEM;
>> >+
>> >+       platform_set_drvdata(pdev, rk808_rtc);
>> >+       rk808_rtc->rk808 = rk808;
>> >+
>> >+       /* start rtc running by default, and use shadowed timer. */
>> >+       ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
>> >+                                BIT_RTC_CTRL_REG_STOP_RTC_M |
>> >+                                BIT_RTC_CTRL_REG_RTC_READSEL_M,
>> >+                                BIT_RTC_CTRL_REG_RTC_READSEL_M);
> I think this should still be setting to 0, not to
> BIT_RTC_CTRL_REG_RTC_READSEL_M.  Otherwise the first read of the time
> will return that time that was frozen at probe time, right?  AKA: if
> probe happens at 11:00:00 and then we read the time at 11:00:05 we'll
> still read 11:00:00 the first time.
>
  Sorry, I did not describe correctly, in the previous mail.
  Actually, RK808 has a "GET_TIME" switch bit. When "GET_TIME" bit rising thansiton to 1,
  the current time will save in a shadowed register.
  If "READSEL" = 1, read rtc time register, return the frozen time.
  If we need the real time, clr this "READSEL" bit.


