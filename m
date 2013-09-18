Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3IRSwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:52:22 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45003 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3IRSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130918165401.GO19937@titan.lakedaemon.net>
References: <1379519624-4267-1-git-send-email-jean.pihet@linaro.org>
	<20130918184509.0ad0a5be@skate>
	<20130918165401.GO19937@titan.lakedaemon.net>
Date: Wed, 18 Sep 2013 20:52:20 +0200
Message-ID: <CAFrcx1n7SPgdSOf09nNOkqF7GuLvVsnrYdOdUZy77VVRzjBEwQ@mail.gmail.com>
Subject: Re: [PATCH] arm: mvebu: use the main timer as clock source from DT
From: Jean Pihet <jean.pihet@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Patch Tracking <patches@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason, Thomas,

On 18 September 2013 18:54, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Sep 18, 2013 at 06:45:09PM +0200, Thomas Petazzoni wrote:
>> Dear Jean Pihet,
>>
>> On Wed, 18 Sep 2013 17:53:44 +0200, Jean Pihet wrote:
>> > This commit:
>> >   573145f08c2b92c45498468afbbba909f6ce6135
>> >   clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
>> >
>> > replaced a call to the driver's timer initialization by a call to
>> > clocksource_of_init(). However, it failed to select CONFIG_CLKSRC_OF.
>> >
>> > Fix this by selecting CONFIG_CLKSRC_OF for Armada370/XP machines.
>> > Without this change the kernel is stuck at: 'Calibrating delay
>> > loop...'.
>> >
>> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> > Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
>> > ---
>> >  arch/arm/mach-mvebu/Kconfig | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
>> > index 9eb63d7..25e6c00 100644
>> > --- a/arch/arm/mach-mvebu/Kconfig
>> > +++ b/arch/arm/mach-mvebu/Kconfig
>> > @@ -26,6 +26,7 @@ config MACH_ARMADA_370_XP
>> >     select HAVE_SMP
>> >     select CACHE_L2X0
>> >     select CPU_PJ4B
>> > +   select CLKSRC_OF
>>
>> I disagree. This should go to drivers/clocksource/Kconfig, because it's
>> the clocksource driver that uses CLOCKSOURCE_OF_DECLARE. See what is
>> already done in drivers/clocksource/Kconfig for other drivers.
>
> Ack.  I missed the 'select ARMADA_370_XP_TIMER' for this block since it
> was outside the context.
I agree. I just did like the other platforms in arch/arm are doing
which is obviously wrong.

> Jean, please fix this up and resubmit to Daniel Lezcano.
Just re-submitted the new version.

>
> I'll drop this version from my tree.
Ok, thx. Sorry for the extra handling.

>
> thx,
>
> Jason.

Thx,
Jean
