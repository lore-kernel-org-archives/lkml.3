Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbbAPKSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:18:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35618 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbAPKSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:18:38 -0500
MIME-Version: 1.0
In-Reply-To: <20150113114101.GO12302@n2100.arm.linux.org.uk>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
	<1918116.UxUgDPTmcq@wuerfel>
	<CAAVeFuL2MKRA7YLm_wsyftNy-sxgEYPrmqBm8XTRZQb66YF-qw@mail.gmail.com>
	<1628217.66frkAqHMc@wuerfel>
	<CAAVeFuJhiten-eVLCa2sMG-nsRwjPMiZap8UJM1kNCuRyK-b1w@mail.gmail.com>
	<20141217104428.GV11285@n2100.arm.linux.org.uk>
	<CACRpkdZbGjNecrggrFr_18zjobXMBpkrSjBMAUfyfs2ZCebB0w@mail.gmail.com>
	<20150113114101.GO12302@n2100.arm.linux.org.uk>
Date: Fri, 16 Jan 2015 11:18:37 +0100
Message-ID: <CACRpkdYNU8MgnZz2kqLFQMiDSeMCuWRkAVXW4BVcMqLT2muBVw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:41 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 13, 2015 at 09:06:15AM +0100, Linus Walleij wrote:
>> On Wed, Dec 17, 2014 at 11:44 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Wed, Dec 17, 2014 at 11:45:01AM +0900, Alexandre Courbot wrote:
>> >> Actually we are not that far from being able to do completely without
>> >> any GPIO number, and maybe that's what we should aim for. I think the
>> >> only remaining offender is the sysfs interface.
>> >
>> > And that is a user API, and there's lots of users of it (eg, on Raspberry
>> > Pi platforms.)  So changing it isn't going to be easy - I'd say that it's
>> > impractical.
>> >
>> > What you're suggesting would be like re-numbering Linux syscalls.
>>
>> The problem is that right now if we set the .base of a gpio_chip
>> to -1 for dynamic allocation of GPIO numbers and we have more
>> than one GPIO chip in the system, the numbers basically depend
>> on probe order, and may theoretically even differ between two boots.
>>
>> So in these cases preserving the ABI means preserving the
>> unpredictability of these assigned numbers or something.
>>
>> For the old usecases with a single GPIO controller and a fixed
>> base offset of e.g. 0 (which I suspect was implicit in the initial
>> design of the subsystem) things work fine as always, it's these new
>> dynamic use cases that destabilize the ABI.
>
> Since GPIOs are exported through sysfs into userland by GPIO number,
> and we know that there are users of it (see
> https://github.com/pilight/wiringX) which hard encode GPIO numbers,
> so this is *really* something that we as kernel developers can't
> change without breaking such users.

I agree.

In some other thread I came up with the idea that if
we add enumerated aliases for the GPIO controllers in the
device tree (so that each can be assigned a sequence number,
like we do on the PL011 ttys) we can assign them numbers
starting from 0.

The only reason that dynamic GPIO start from some random
high offset is that the on-chip GPIOs are assumed to be present
at offset 0+, so this is done so that the dynamic controllers
avoid colliding with them. (At least that is how I understand it.)
So on a fully DT-enabled system assigning numbers starting
from 0 should be kind of default.

Yours,
Linus Walleij
