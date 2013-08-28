Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3H1Cn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:43:27 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36666 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3H1Cn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130827152405.GQ19893@e106331-lin.cambridge.arm.com>
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
 <1374301266-26726-3-git-send-email-prabhakar.csengg@gmail.com>
 <5217A3E7.50706@samsung.com> <CA+V-a8tStFRbELAmZL=418VpR9SJgp8uo_4hrtny2UEMEoXakg@mail.gmail.com>
 <20130827152405.GQ19893@e106331-lin.cambridge.arm.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 28 Aug 2013 08:13:04 +0530
Message-ID: <CA+V-a8vuYNNiXJ+iGgceaTqHdM_Q9X2dVDyiHHZPJ+-rSbJgLQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] media: i2c: adv7343: add OF support
To: Mark Rutland <mark.rutland@arm.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        LDOC <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 27, 2013 at 8:54 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> [fixing up devicetree list address]
>
Thanks!

> On Mon, Aug 26, 2013 at 03:41:45AM +0100, Prabhakar Lad wrote:
>> Hi Sylwester,
>>
>> On Fri, Aug 23, 2013 at 11:33 PM, Sylwester Nawrocki
>> <s.nawrocki@samsung.com> wrote:
>> > Cc: DT binding maintainers
>
> Cheers!
>
>> >
>> > On 07/20/2013 08:21 AM, Lad, Prabhakar wrote:
>> >> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>> >>
>> >> add OF support for the adv7343 driver.
>> >>
>> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >> ---
>> > [...]
>> >>  .../devicetree/bindings/media/i2c/adv7343.txt      |   48 ++++++++++++++++++++
>> >>  drivers/media/i2c/adv7343.c                        |   46 ++++++++++++++++++-
>> >>  2 files changed, 93 insertions(+), 1 deletion(-)
>> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> >> new file mode 100644
>> >> index 0000000..5653bc2
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> >> @@ -0,0 +1,48 @@
>> >> +* Analog Devices adv7343 video encoder
>> >> +
>> >> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
>> >> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
>> >> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
>> >> +definition (SD), enhanced definition (ED), or high definition (HD) video
>> >> +formats.
>> >> +
>> >> +Required Properties :
>> >> +- compatible: Must be "adi,adv7343"
>> >> +
>> >> +Optional Properties :
>> >> +- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
>> >> +                           micro ampere level. All DACs and the internal PLL
>> >> +                           circuit are disabled.
>
> This seems to be a boolean property, and I couldn't find any description
> in the linked datasheet of the constraints under which the unit may be
> put into sleep mode.
>
> Why do we require this property in the dt? Can the driver not always put
> a adv734x into sleep mode if it wants to, and then wake it up as
> required?
>
The adv7343 decoder, fits on da850/dm6467 etc.. For the da850 it supports
only SD where as the dm6467 supports HD/SD/ED for which DAC 1-6 of
Register 0x0 varies for this board so I added them as the platform data
but I got a review comment in the ML asking to add entire register as
the pdata instead of DAC 1-6, so because of which it is being converted
in the same way for DT.

>> >
>> > Sorry for getting back so late to this. I realize this is already queued in
>> > the media tree. But this binding doesn't look good enough to me. I think it
>> > will need to be corrected during upcoming -rc period.
>> >
>> Thanks for the catch :-)
>>
>> > It might be hard to figure out only from the chip's datasheet what
>> > adi,power-mode-sleep-mode really refers to. AFAICS it is for assigning some
>> > value to a specific register. If we really need to specify register values
>> > in the device tree then it would probably make sense to describe to which
>> > register this apply. Now the name looks like derived from some structure
>> > member name in the Linux driver of the device.
>> >
>> the property is derived from the datasheet itself for example the
>> 'adi,power-mode-sleep-mode' --> Register 0x0 power mode bit 0
>> 'adi,power-mode-pll-ctrl' ---> Register 0x0 power mode bit 1
>> 'adi,dac-enable' ----> Register 0x0 power mode bit 2-7
>> 'adi,sd-dac-enable' ---> Register 0x82 SD mode register bit 1-2
>>
>> [1] http://www.analog.com/static/imported-files/data_sheets/ADV7342_7343.pdf
>>
>> >> +- adi,power-mode-pll-ctrl: PLL and oversampling control. This control allows
>> >> +                        internal PLL 1 circuit to be powered down and the
>> >> +                        oversampling to be switched off.
>
> This affects whether or not oversampling is possible. That sounds like
> it should be a run-time configurable rather than a fixed property of the
> device.
>
ditto

>> >
>> > Similar comments applies to this property.
>> >
>> >> +- ad,adv7343-power-mode-dac: array configuring the power on/off DAC's 1..6,
>> >> +                           0 = OFF and 1 = ON, Default value when this
>> >> +                           property is not specified is <0 0 0 0 0 0>.
>> >
>> > Name of the property is incorrect here. It has changed to "adi,dac-enable".
>> >
>> OK
>
> Why do we need this property at all? Might some DACs not be wired up to
> anything?
>
> Surely this could be configured at run-time as and when the user wants
> to use the DACs.
>
>>
>> >> +- ad,adv7343-sd-config-dac-out: array configure SD DAC Output's 1 and 2, 0 = OFF
>> >> +                              and 1 = ON, Default value when this property is
>> >> +                              not specified is <0 0>.
>> >
>> > Similarly, "adi,sd-dac-enable.
>> >
>> OK
>
> Again, couldn't this be done at run-time?
>
> Do we need to permanently disable/enable some DACs? If so, why?
>
ditto.

> I also note from the spec that the unit has two clocks, CLKIN_A and
> CLKIN_B that aren't in the binding, but should be. Some regulators
> too (VDD, PVDD, VAA, VDD_IO, VREF?).
>
OK

Regards,
--Prabhakar Lad
