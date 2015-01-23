Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbbAWI44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:56:56 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52446 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbbAWI4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:56:53 -0500
MIME-Version: 1.0
In-Reply-To: <7hvbjy30an.fsf@deeprootsystems.com>
References: <1421919253-4784-1-git-send-email-geert+renesas@glider.be>
	<1421919253-4784-4-git-send-email-geert+renesas@glider.be>
	<7hvbjy30an.fsf@deeprootsystems.com>
Date: Fri, 23 Jan 2015 09:56:51 +0100
X-Google-Sender-Auth: 8kuD0TNrnMT6LZkWs1qvfDhPChE
Message-ID: <CAMuHMdUMcyXdgv+xdd8Zo67rYnfh6JaSWfr1H3c6NrQs=JsNLg@mail.gmail.com>
Subject: Re: [PATCH v3/resend 3/4] drivers: bus: Add Simple Power-Managed Bus
 DT Bindings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Thu, Jan 22, 2015 at 11:42 PM, Kevin Hilman <khilman@kernel.org> wrote:
> Geert Uytterhoeven <geert+renesas@glider.be> writes:
>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Tested-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> ---
>> v3:
>>   - Add Tested-by,
>>   - Document required properties inherited from "simple-bus",
>>   - Document required "reg" property for "renesas,bsc",
>>   - Move "ranges" before "reg" in the example,
>>
>> v2:
>>   - New.
>> ---
>>  .../devicetree/bindings/bus/simple-pm-bus.txt      | 52 ++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/bus/simple-pm-bus.txt
>>
>> diff --git a/Documentation/devicetree/bindings/bus/simple-pm-bus.txt b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
>> new file mode 100644
>> index 0000000000000000..d03abf7fd8e3997a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
>> @@ -0,0 +1,52 @@
>> +Simple Power-Managed Bus
>> +========================
>> +
>> +A Simple Power-Managed Bus is a transparent bus that doesn't need a real
>> +driver, as it's typically initialized by the boot loader.
>> +
>> +However, its bus controller is part of a PM domain, or under the control of a
>> +functional clock.  Hence, the bus controller's PM domain and/or clock must be
>> +enabled for child devices connected to the bus (either on-SoC or externally)
>> +to function.
>> +
>> +
>> +Generic compatible values and properties
>> +----------------------------------------
>> +
>> +Required properties:
>> +  - compatible: Must be at least one of the vendor-specific compatible values
>> +             from a vendor-specific section below, and "simple-bus" as a
>> +             fallback.
>
> What happened to the idea of using something like "simple-pm-bus"?

I think that's a decision to make by the (successor of the) ePAPR committee.
At least it would be nice to get some feedback from the DT review team
about this.

If we go that road, the vendor-specific compatible value should still be
documented, else checkpatch will complain when encountering it in a DTS.
Then, should it become

    compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus",
"simple-bus";

or should "simple-bus" just be added to of_default_bus_match_table[], so we
can drop "simple-bus" from the list in the DTS:

    compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus";

> There's nothing vendor-specific in the driver at all, so the
> vendor-specific binding seem like clutter to me and will result in
> continuing to add vendor-specific compatibles without any
> vendor-specific code.

So far not many users or other interested parties chimed in, so that's
still to be seen. If/when this happens, we can remove the vendor-specific
matching from the driver, and add a quirk, to add a "simple-pm-bus"
compatible value where needed, to platform code, right?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
