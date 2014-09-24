Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaIXLx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:53:56 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48012 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaIXLxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <54227038.2020805@free-electrons.com>
References: <1411311493-24344-1-git-send-email-wens@csie.org>
 <1411311493-24344-4-git-send-email-wens@csie.org> <20140924063738.GQ15315@lukather>
 <CAGb2v64voZpK_82wtkErRowR0vjEUALNUwvCx_sd8Q5wb4Hq-g@mail.gmail.com> <54227038.2020805@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 24 Sep 2014 19:53:33 +0800
X-Google-Sender-Auth: pTku4SgYi6jtK7Rknk4wr8TQhoY
Message-ID: <CAGb2v64yGmdLeWmA=+nxD85DbQf_xxUNx3n3oedFZi51uc50+w@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 3/6] ARM: dts: sunxi: Add Allwinner A80 dtsi
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        yhf <yhf@merrii.com>, ctl <ctl@merrii.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 3:18 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:
> Hi Chen-Yu,
>
>
>>>> +
>>>> +     memory {
>>>> +             reg = <0x20000000 0x40000000>;
>>>
>>> Usually, what we put there was the maximum amount of RAM that can be
>>> handled by the SoC. I think that it can go above 1GB
>>
>> With LPAE, it can handle 8GB. But the DT won't take 64bit values.
>> I'm not sure how to get it in. I'll look around for examples.
>
> You can have a look on what we did for Armada XP:
>
> arch/arm/boot/dts/armada-370-xp.dtsi
> arch/arm/boot/dts/armada-xp.dtsi
> arch/arm/boot/dts/armada-xp-gp.dts
>
> I created a skeleton64.dtsi for this case

Thanks for the tip. Before I send v2, I do have a question. I'm using

    ranges = <0 0 0 0x20000000>;

in the clocks and soc node to avoid having to use 64bit values for all
addresses and sizes. Would this be undesirable, even bad practice maybe?

http://linux-sunxi.org/A80/Memory_map is a document I pieced together
from Allwinner's SDK header files. AFAIK only the memory goes above
the 4GB limit. All peripherals are under 512 MB, 256MB even.


Thanks
ChenYu
