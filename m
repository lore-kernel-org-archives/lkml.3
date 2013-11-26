Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3KZI2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:28:38 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:40580 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3KZI2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <52932DB9.4090805@ti.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
 <1385057731-4348-5-git-send-email-prabhakar.csengg@gmail.com> <52932DB9.4090805@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 26 Nov 2013 13:58:12 +0530
Message-ID: <CA+V-a8uSdSMhBaFTbJDwPYz=in2r_STAUzRs+HEwAH1yjBq96Q@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] gpio: davinci: add OF support
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

Thanks for the review.

On Mon, Nov 25, 2013 at 4:30 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On Thursday 21 November 2013 11:45 PM, Prabhakar Lad wrote:
>> From: KV Sujith <sujithkv@ti.com>
>>
>> This patch adds OF parser support for davinci gpio
>> driver and also appropriate documentation in gpio-davinci.txt
>> located at Documentation/devicetree/bindings/gpio/.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>> Signed-off-by: KV Sujith <sujithkv@ti.com>
>> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>> [prabhakar.csengg@gmail.com: simplified the OF code, removed
>>               unnecessary DT property and also simplified
>>               the commit message]
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  .../devicetree/bindings/gpio/gpio-davinci.txt      |   41 ++++++++++++++
>>  drivers/gpio/gpio-davinci.c                        |   57 ++++++++++++++++++--
>>  2 files changed, 95 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> new file mode 100644
>> index 0000000..a2e839d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> @@ -0,0 +1,41 @@
>> +Davinci GPIO controller bindings
>> +
>> +Required Properties:
>> +- compatible: should be "ti,dm6441-gpio"
>> +
>> +- reg: Physical base address of the controller and the size of memory mapped
>> +       registers.
>> +
>> +- gpio-controller : Marks the device node as a gpio controller.
>> +
>> +- interrupt-parent: phandle of the parent interrupt controller.
>> +
>> +- interrupts: Array of GPIO interrupt number. Only banked or unbanked IRQs are
>> +           supported at a time.
>
> If this is true..
>
>> +
>> +- ti,ngpio: The number of GPIO pins supported.
>> +
>> +- ti,davinci-gpio-unbanked: The number of GPIOs that have an individual interrupt
>> +                          line to processor.
>
> .. then why do you need to maintain this separately? Number of elements
> in interrupts property should give you this answer, no?
>
> There can certainly be devices (past and future) which use a mixture of
> banked and unbanked IRQs. So a binding which does not take care of this
> is likely to change in future and that is a problem since it brings in
> backward compatibility of the binding into picture.
>
> The right thing would be to define the DT node per-bank similar to what
> is done on OMAP rather than for all banks together. That way there can
> be a separate property which determines whether that bank supports
> direct-mapped or banked IRQs (or that could be inferred if the number of
> tuples in the interrupts property is more than one).
>
Can you point me to the OMAP implementation.

Regards,
--Prabhakar Lad
