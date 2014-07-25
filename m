Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaGYRCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:02:37 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42635 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaGYRCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:02:35 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.62.104]
In-Reply-To: <CAD=FV=V-7+Jj7b8-fQL1PiQhNmhiGOPJzitGd__OUQLDteO_8g@mail.gmail.com>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-4-git-send-email-afaerber@suse.de>
	<CABxcv=kP2PCcNCtM1WUXx5wGG4m-jdw-P1dw0boaSwdJpoX=jQ@mail.gmail.com>
	<CAD=FV=V-7+Jj7b8-fQL1PiQhNmhiGOPJzitGd__OUQLDteO_8g@mail.gmail.com>
Date: Fri, 25 Jul 2014 19:02:34 +0200
Message-ID: <CABxcv=nDsKSdDtVZKpcTP+=3pbeTswJRCUvvXVx98p+1Zzz0Bg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos5250: Fold common ChromeOS parts
 into Snow
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Doug Anderson <dianders@chromium.org>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
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

Hello Doug,

On Fri, Jul 25, 2014 at 6:43 PM, Doug Anderson <dianders@chromium.org> wrote:
> Javier,
>
> On Fri, Jul 25, 2014 at 9:35 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
>> Hello Andreas,
>>
>> On Fri, Jul 18, 2014 at 7:20 PM, Andreas Färber <afaerber@suse.de> wrote:
>>>
>>> +       memory {
>>> +               reg = <0x40000000 0x80000000>;
>>> +       };
>>> +
>>> +       chosen {
>>> +       };
>>> +
>>
>> Is there a reason for an empty chosen node? Same for the Spring DTS.
>
> I know that the bootloader (U-Boot) fills this in.  I'd have to double
> check how the bootloader handles the node not being there to begin
> with.

Yes, U-Boot fills this but if the node does not exist in the FDT, it
creates one. Take a look at fdt_chosen() in common/fdt_support.c [0].

So I think it's better to just remove it since is empty.

Best regards,
Javier

[0]: https://chromium.googlesource.com/chromiumos/third_party/u-boot/+/master/common/fdt_support.c#215
