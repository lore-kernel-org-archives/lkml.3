Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaG2P1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:27:18 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51115 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbaG2P1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <53D79AD3.8020700@suse.de>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-4-git-send-email-afaerber@suse.de>
	<CABxcv=kP2PCcNCtM1WUXx5wGG4m-jdw-P1dw0boaSwdJpoX=jQ@mail.gmail.com>
	<CAD=FV=V-7+Jj7b8-fQL1PiQhNmhiGOPJzitGd__OUQLDteO_8g@mail.gmail.com>
	<CABxcv=nDsKSdDtVZKpcTP+=3pbeTswJRCUvvXVx98p+1Zzz0Bg@mail.gmail.com>
	<53D79AD3.8020700@suse.de>
Date: Tue, 29 Jul 2014 08:27:13 -0700
X-Google-Sender-Auth: hWkjrymmw22ryYQwtMj8yxxAXgA
Message-ID: <CAD=FV=VMuP3necmUqpzd2igvkr3BDcf_01b-0vuDvyQpsNxoRw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos5250: Fold common ChromeOS parts
 into Snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Tue, Jul 29, 2014 at 6:00 AM, Andreas Färber <afaerber@suse.de> wrote:
> Hi Javier and Doug,
>
> Am 25.07.2014 19:02, schrieb Javier Martinez Canillas:
>> On Fri, Jul 25, 2014 at 6:43 PM, Doug Anderson <dianders@chromium.org> wrote:
>>> On Fri, Jul 25, 2014 at 9:35 AM, Javier Martinez Canillas
>>> <javier@dowhile0.org> wrote:
>>>> Hello Andreas,
>>>>
>>>> On Fri, Jul 18, 2014 at 7:20 PM, Andreas Färber <afaerber@suse.de> wrote:
>>>>>
>>>>> +       memory {
>>>>> +               reg = <0x40000000 0x80000000>;
>>>>> +       };
>>>>> +
>>>>> +       chosen {
>>>>> +       };
>>>>> +
>>>>
>>>> Is there a reason for an empty chosen node? Same for the Spring DTS.
>>>
>>> I know that the bootloader (U-Boot) fills this in.  I'd have to double
>>> check how the bootloader handles the node not being there to begin
>>> with.
>>
>> Yes, U-Boot fills this but if the node does not exist in the FDT, it
>> creates one. Take a look at fdt_chosen() in common/fdt_support.c [0].
>>
>> So I think it's better to just remove it since is empty.
>
> Hm, in different context it was stated that device trees shouldn't rely
> on bootloader behavior (for a /memory node on Zynq we ended up
> specifying the size cell with the real value despite U-Boot overriding
> it to a lesser value).
>
> Can we instead settle on filling this node with defaults? :)
> bootargs = "console=tty1"; would be my choice for Spring. Would that be
> applicable for Snow as well?

Personally I think that there's not a lot of use for including
bootargs.  Every single person will need different bootargs since
everyone will have a different boot source (eMMC partitioin 0, eMMC
partition3, SD card, USB, etc).  You have to rely on the bootloader
for _something_.


> Not sure how to specify that via linux,stdout-path property.
>
> I believe this would be a follow-up patch either way.

Right


> Since there's at least two series out there trying to fiddle with
> -cros-common.dtsi, including one that drops the slot sub-node of the MMC
> and one that adds CPU power supply, it would be nice if we can get the
> -cros-common parts sorted out and applied. Can you ack/review 1-2?
> Should I squash them in a v3?

Yeah, it will be a fight to see who gets landed first...  :-P

I was thinking you were going to spin the patches and I'd do another
batch of review, but I think I can mark the first two as Reveiwed-by
if it's helpful to you.  Let me do one more double-check when I get to
my desk.

-Doug
