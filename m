Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaJ2J6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:58:19 -0400
Received: from mo68.mail-out.ovh.net ([178.32.228.68]:47160 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaJ2J6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:58:15 -0400
X-Greylist: delayed 83696 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 05:58:15 EDT
Message-ID: <5450B86D.7060301@neo-technologies.fr>
Date: Wed, 29 Oct 2014 10:50:37 +0100
From: NEO-Technologies / Julien CHAUVEAU 
	<julien.chauveau@neo-technologies.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Addy Ke <addy.ke@rock-chips.com>
Subject: Re: [PATCH v2] ARM: dts: rockchip: use internal pull-up resistors
 on I2C busses
References: <1414492597-13566-1-git-send-email-julien.chauveau@neo-technologies.fr> <CAD=FV=Vs9NT3hMS_Z0dOuwyBdxCsMddqohWFYOGYbM2ePm9PrQ@mail.gmail.com>
In-Reply-To: <CAD=FV=Vs9NT3hMS_Z0dOuwyBdxCsMddqohWFYOGYbM2ePm9PrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13293218727112016097
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Le 29/10/2014 05:45, Doug Anderson a écrit :
> Julien,
>
> On Tue, Oct 28, 2014 at 3:36 AM, Julien CHAUVEAU
> <julien.chauveau@neo-technologies.fr> wrote:
>> According to the I2C bus specification, it is required to use pull-up resistors
>> on the clock and data lines. Probing the I2C busses with i2cdetect results in
>> bad results when no devices are connected and no external resistors are used.
>>
>> This patch configures the I2C busses to use the internal pull-up resistors
>> on the RK3066, RK3188 and RK3288 Rockchip processors. It should also be noted
>> that these default pull settings match the original configuration on these SoCs.
>>
>> Below is the results of using i2cdetect on a I2C bus with no devices connected
>> before (1) and after (2) applying this patch.
>>
>> (1) root@localhost:~# i2cdetect -y 3
>>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
>> 00:          03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
>> 10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
>> 20: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
>> 30: -- -- -- -- -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x81, state: 2
>> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 2
>> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 2
>> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
>> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
>> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
>> ...
>>
>> (2) root@localhost:~# i2cdetect -y 3
>>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
>> 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
>> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 70: -- -- -- -- -- -- -- --
>>
>> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
>> ---
>> Changes since v1:
>> - fix the rk3066a pull settings (only available is pull_none/pull_default)
>> - remove the warnings in the results of i2cdetect
>>
>>   arch/arm/boot/dts/rk3066a.dtsi | 20 ++++++++++----------
>>   arch/arm/boot/dts/rk3188.dtsi  | 20 ++++++++++----------
>>   arch/arm/boot/dts/rk3288.dtsi  | 24 ++++++++++++------------
>>   3 files changed, 32 insertions(+), 32 deletions(-)
> I won't NAK this change myself, but I have to say I'm not a huge fan.
> On exynos boards the i2c has pulls by default, so there is precedent
> for what you're proposing at least.
>
> ...but I'll also say that most sane boards have external pulls on i2c
> and don't rely on the internal pulls.  If you've got a board where the
> internal pull works well enough (lucky you!) then I think you should
> override the pinctrl for just that board.

At the SoC level, it is IMHO better to enable the internal pull-up 
resistors.

Because the files rk3066a.dtsi, rk3188.dtsi and rk3288.dtsi are not 
board-specific, I think it is wrong to presume that correct pull-up 
resistors are applied to the I2C lines on the board.

Furthermore, as I explained to Addy on the linux-rockchip mailing list, 
it is harmless to enable the internal pull-up resistors on the SoC, but 
of course you need to keep the external pull-up resistors on the board 
(so, do not remove them!).

Moreover, if you absolutely want to disable the internal pull-up 
resistors for one or another board, it is IMHO better to do it at the 
board level, but not at the SoC level.

To each is own...

Julien/
//
/
