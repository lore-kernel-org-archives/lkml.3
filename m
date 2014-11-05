Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaKEBC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:02:29 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:42261 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaKEBC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:02:28 -0500
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <9272b58185e80cb3ebed20c8b5c4957b>
X-DNS-TYPE: 1
Message-ID: <54597714.3050406@rock-chips.com>
Date: Wed, 05 Nov 2014 09:02:12 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>
CC: Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?IuaItOWFi+mcliAoSmFjayk=?= =?UTF-8?B?Ig==?= 
	<dkl@rock-chips.com>,
        Addy Ke <addy.ke@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jianqun Xu <xjq@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: rockchip: change hierarchy for some clocks
References: <1414747777-12625-1-git-send-email-kever.yang@rock-chips.com> <CAD=FV=VByf=YKw7q4L2493C-z9uJ3dTSk9WZyCFdOkSjD2XoDw@mail.gmail.com>
In-Reply-To: <CAD=FV=VByf=YKw7q4L2493C-z9uJ3dTSk9WZyCFdOkSjD2XoDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 11/05/2014 05:32 AM, Doug Anderson wrote:
> Kever
>
> On Fri, Oct 31, 2014 at 2:29 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
>> This patch change the hierarchy for some clocks, to met the following
>> bus hierarchy:
>> hclk_usb_peri is bus clock for
>> |- hclk_otg0,
>> |- hclk_host0,
>> |- hclk_host1,
>> |- hclk_hsic
>>
>> hclk_emem is bus clock for
>> |- hclk_nandc0
>> |- hclk_nandc1
>>
>> hclk_mem is bus clock for
>> |- hclk_sdmmc
>> |- hclk_sdio0
>> |- hclk_sdio1
>> |- hclk_emmc
> So as I understand it the "parent" clocks aren't really parents but
> are actually peer clocks.  That is if "hclk_usb_peri" is gated
> "hclk_otg0" continues to run.  ...but the OTG periperhal is useless
> without "hclk_usb_peri" also being enabled.
Correct.
>
> There doesn't seem to be any real downside to modeling thing as you
> have done it, though it's not quite a true representation of the
> world.  A slightly more true representation would be to make it so
> that whenever "hclk_otg0" is enabled/disabled that it makes an
> enable/disable call to "hclk_usb_peri".  I think you'd have to
> subclass the gate clock and patch your stuff in the "enable" function.
>
> I'm personally OK with things landing as you've described it (I can
> see no downside), but it seems like this at least deserves a comment
> (either in the code or the commit message).
I will update the commit message in new version, I describe it
in a private mail ask for how to handle this kind of clock, but not
in this patch, I will add it.
>
> If Mike T. thinks that we should use a more truthful model or if
> there's some better way to express this, you should of course listen
> to him and not to me.
Sure, I'm always looks for a better way for these kind of clocks,
there are many other clocks like *_arbi and *_niu still on rk3288
are not handled by any module which we have to use
CLK_IGNORE_UNUSED tag when disable unused init.

- Kever
