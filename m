Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIXBru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:47:50 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:38297 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIXBrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:47:48 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <64391fb7e4cb436835a7537201f4d67c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <542222BC.4060203@rock-chips.com>
Date: Wed, 24 Sep 2014 09:47:40 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] regulator: st-pwm: get voltage and duty table
 from dts
References: <1411487622-10881-1-git-send-email-zyw@rock-chips.com>	<1411487622-10881-2-git-send-email-zyw@rock-chips.com> <CAD=FV=Vhejf4JoEPUGwmBJdO+zfHgE5hgoT6V1DGtva7r_1Etg@mail.gmail.com>
In-Reply-To: <CAD=FV=Vhejf4JoEPUGwmBJdO+zfHgE5hgoT6V1DGtva7r_1Etg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/24/2014 07:43 AM, Doug Anderson wrote:
> Chris,
>
> On Tue, Sep 23, 2014 at 8:53 AM, Chris Zhong <zyw@rock-chips.com> wrote:
>> Get voltage & duty table from device tree might be better, other platforms can also use this
>> driver without any modify.
>>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
> I finally managed to get everything setup and I've now tested this
> myself on an rk3288-based board.
>
> Tested-by: Doug Anderson <dianders@chromium.org>
>
> I'd imagine the next step is for Lee to comment on the patch and when
> he's happy with it Mark Brown will land it?
>
>
> One thing that's still a bit odd (though no different than the
> behavior of the driver from before you touched it, so it shouldn't
> block landing IMHO) is that at boot time this regulator will report
> that it's at the highest voltage but the voltage won't actually change
> until the first client sets the voltage.
Yes, I knew this problem, since the default of duty cycle is 0, not a 
true value.
If we can get duty from pwm, this regulator will report a correct voltage.
>
> Also: if anyone reading is interested in this patch, it's possible
> you'll also be interested in my patch at
> <https://patchwork.kernel.org/patch/4960731/> to make sue that your
> voltage doesn't twiddle around at probe time.
>
>
> -Doug
>
>
>

