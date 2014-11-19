Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaKSK1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:27:34 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:58438 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKSK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:27:31 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: sonnyrao@chromium.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <408b8315b578fe79ce1dc628650a8f65>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <546C70A1.9090707@rock-chips.com>
Date: Wed, 19 Nov 2014 18:27:45 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Kever Yang <kever.yang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        ZhenFu Fang <fzf@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <chris.zhong@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] ARM: dts: fix PWM clock found on RK3288 Socs
References: <1416367554-15185-1-git-send-email-caesar.wang@rock-chips.com> <CAD=FV=W+WU3j7OWKTxtGUv1Jt7qPesGXSOsoM=bsD5C15jttvA@mail.gmail.com>
In-Reply-To: <CAD=FV=W+WU3j7OWKTxtGUv1Jt7qPesGXSOsoM=bsD5C15jttvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

在 2014/11/19 13:14, Doug Anderson 写道:
> Caesar,
>
> On Tue, Nov 18, 2014 at 7:25 PM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
>> We use the new PWM IP on RK3288,but the PWM's clock indeed incorrect.
>>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   arch/arm/boot/dts/rk3288.dtsi | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
> Right, I reported this when Kever was doing his "unused clocks" patch.
> That's why this clock is currently "ignore unused".
>
> ...but though your change is right, I'd rather your change doesn't
> land quite yet.  It totally wrecks havoc with the PWM regulator used
> on many rk3288 boards and will glitch the main "logic" voltage at
> bootup.  I have some patches that are MASSIVELY WIP:
>
> https://chromium-review.googlesource.com/230640
> WIP: regulator: pwm: Tell regulator framework that we can't turn off
>
> https://chromium-review.googlesource.com/230641
> WIP: PWM: handle the fact that firmware might have left us enabled
>
> https://chromium-review.googlesource.com/230642
> WIP: pwm-regulator stuff
>
> I think that last one might blow up into several patches.  We need to
> solve the problems from those patches before yours can really land.
>
>
> It's pretty high on my list to finish the above patches, but right now
> suspend/resume issues are higher priority so it's a bit stalled...  If
> someone wants to hijack any of the above patches please let me know--I
> won't be offended.

OK,I see.


> -Doug
>
>
>

-- 
Best regards,
Caesar


