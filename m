Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbaGAQ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:57:00 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:59320 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaGAQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <4224745.HqdT4QrZdr@wuerfel>
References: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>
	<1403183091-27876-2-git-send-email-ulf.hansson@linaro.org>
	<4224745.HqdT4QrZdr@wuerfel>
Date: Tue, 1 Jul 2014 18:56:55 +0200
Message-ID: <CAPDyKFogpZWCc5v1--dqDO7wHvsRp-rKgP2qGZw+HwCuJKZ0zQ@mail.gmail.com>
Subject: Re: [RFC 1/2] pwrseq: Add subsystem to handle complex power sequences
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Rob Herring <robh+dt@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2014 17:42, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 19 June 2014 15:04:50 Ulf Hansson wrote:
>> +Power sequence DT bindings
>> +
>> +Each power sequence method has a corresponding "power-method" property string.
>> +This property shall be set in a subnode for a device. That subnode should also
>> +describe resourses which are specific to that power method.
>> +
>> +Do note, power sequences as such isn't encoded through DT. Instead those are
>> +implemented by each power method.
>> +
>> +Required subnode properties:
>> +- power-method: should contain the string for the power method to bind.
>> +
>> +       Supported power methods: None.
>> +
>> +Example:
>> +
>> +Note, the "clock" power method in this example isn't actually supported, but
>> +used to visualize how a childnode could be described.
>
> I'm not too thrilled about adding another top-level concept for these.

I agree, but when you collects the requirements from the discussions
we have had around this topic - I don't think we can find another
solution. But I might be wrong.

> This seems to duplicate some things that pm-domains do, but does them
> in a somewhata different way. Would it be possible to instead integrate
> it into the pm-domain code?

No, I don't think so.

That main argument would be that runtime PM is not fine grained
enough, but there are several other reasons.

Please refer to previous discussions.

>
> I also agree with Olof that having a standalone child device node is
> not the best representation. If you want to represent an SDIO device
> device that has some references to clocks, regulators, etc, then put
> that device into the tree and give it those properties.

Could you elaborate on why?

Where would a card (SDIO/SD/MMC) be better placed - unless as a child
node under a mmc host device?

> That would also let you worry about the sequencing in driver code rather
> than trying to come up with a completely generic model for it.

So in principle your are suggesting to "pre-probe" all discoverable
devices/buses, not just for SDIO ( aka mmc subsystem).

Will that even work for modules?

Kind regards
Uffe

>
>         Arnd
