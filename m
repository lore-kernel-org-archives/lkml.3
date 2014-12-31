Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaLaCV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 21:21:59 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:43374 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaLaCV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 21:21:58 -0500
X-263anti-spam: KSV:0;BIG:0;ABS:1;DNS:5;ATT:0;SPF:S;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ADDR-CHECKED: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 50.2.43.38
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <67717b35421476a6dd1806cce71c5c0e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 5
Message-ID: <54A35DB6.8070200@rock-chips.com>
Date: Wed, 31 Dec 2014 10:21:42 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: heiko@sntech.de, dianders@chromium.org, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] regulator: rk808: add dvs support
References: <1418612879-16094-1-git-send-email-zyw@rock-chips.com> <1418612879-16094-3-git-send-email-zyw@rock-chips.com> <20141229172555.GE17800@sirena.org.uk> <54A216E2.4090504@rock-chips.com> <20141230170445.GP17800@sirena.org.uk>
In-Reply-To: <20141230170445.GP17800@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/31/2014 01:04 AM, Mark Brown wrote:
> On Tue, Dec 30, 2014 at 11:07:14AM +0800, Chris Zhong wrote:
>> On 12/30/2014 01:25 AM, Mark Brown wrote:
>>> So, this seems a bit odd.  What we appear to be doing here is
>>> alternating between the two different voltage setting registers which is
>>> all well and good but makes me wonder why we're bothering - it's a bit
>>> more work than just sticking with one.  We do get...
>> you mean check the old_selector and selector? I think
>> _regulator_do_set_voltage have done it.
> No, I mean that we may as well just always write to the same register
> and save a bunch of code.
No, when we pull down DVSn pin, the voltage value is from 
RK808_BUCK1_ON_VSEL_REG,
and when we pull up DVSn pin, the voltage value if from 
RK808_BUCK1_ON_VSEL_REG+2.
We want to this dvs function for a better voltage wave, avoid overshoot, 
if someone do not
need this function, they could remove the setting of DVSn pin in dts 
file, and at that time,
rk808_regulator will use a same register for setting voltage.


>>> ...this but unless the voltage typically ramps much faster than spec
>>> it's never clear to me that we're actually winning by polling the pin
>>> instead of just dead reckoning the time, it's more work for the CPU to
>>> poll the GPIO than to sleep after all.
>> Actually, it's slower than spec, so I think getting this dvsok pin state
>> is safer than delay.
> Well, that suggests that the spec is wrong which ought to be fixed
> anyway oughtn't it?  Or are you saying that the delay is inconsistent as
> well as slower than advertised?
the spec said 2/4/6/10 mv/us, but the ramp will change depending on the 
load.
So I think the dvsok pin is more accurate, since it It will soon change, 
once the
regulator is completed. the delay is a fixed time. it is faster than 
dvsok pin.



