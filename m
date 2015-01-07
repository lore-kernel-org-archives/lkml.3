Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbbAGObE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:31:04 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:59017 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbAGOa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:30:59 -0500
Message-ID: <54AD431F.6060403@gmail.com>
Date: Wed, 07 Jan 2015 15:30:55 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "antoine.tenart@free-electrons.com" 
	<antoine.tenart@free-electrons.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] clk: berlin: bg2q: remove non-exist "smemc" gate
 clock
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com> <1420016272-6789-4-git-send-email-jszhang@marvell.com> <54AD3EAE.6090009@gmail.com> <20150107222209.64ed24a0@xhacker>
In-Reply-To: <20150107222209.64ed24a0@xhacker>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.2015 15:22, Jisheng Zhang wrote:
> Dear Sebastian,
>
> On Wed, 7 Jan 2015 06:11:58 -0800
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
>> On 31.12.2014 09:57, Jisheng Zhang wrote:
>>> The "smemc" clock is removed on BG2Q SoCs. In fact, bit19 of clkenable
>>> register is for nfc. Current code use bit19 for non-exist "smemc"
>>> incorrectly, this prevents eMMC from working due to the sdhci's
>>> "core" clk is still gated.
>>>
>>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
>>> Cc: stable@vger.kernel.org # 3.16+
>>> ---
>>>    drivers/clk/berlin/bg2q.c | 1 -
>>>    1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
>>> index 21784e4..440ef81 100644
>>> --- a/drivers/clk/berlin/bg2q.c
>>> +++ b/drivers/clk/berlin/bg2q.c
>>> @@ -285,7 +285,6 @@ static const struct berlin2_gate_data bg2q_gates[]
>>> __initconst = { { "pbridge",	"perif",	15,
>>> CLK_IGNORE_UNUSED }, { "sdio",	"perif",	16,
>>> CLK_IGNORE_UNUSED }, { "nfc",	"perif",	18 },
>
> The nfc here is really confusing, we call it as nfccore internally. Is it better
> to rename it as nfccore?

I guess it comes from some early Marvell BSP code, if there is no
issues with the name, e.g. something already depends on "nfc", feel
free to rename it to something more meaningful.

>>> -	{ "smemc",	"perif",	19 },
>>
>> Jisheng,
>>
>> if bit 19 is for nfc, how does that work out with bit 18 which is
>> still assigned to nfc? Can you re-evaluate clkenable registers for
>
> bit 19 is for nfcEcc, the "io" clock; bit 18 is for nfcCore, the "core" clock.

Ok, then both bits should be dealt with accordingly, i.e. rename
"smemc" to "nfcecc" and use it in the corresponding dts node.

If this clk_gate just disables a clock that is fed into another
gateable clock module, I can live with removing it - although I
still think it is best to leave the clk_gate in place and pick
another name that does not collide with any other clock name.

>> BG2Q and fix it up accordingly? I'd suggest to still disable as many
>
> I'll recheck the clk driver for BG2Q.

Ok, thanks a lot!

Sebastian

