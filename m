Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183Ab3IDHOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:14:04 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53660 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3IDHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130902161715.GB18206@e106331-lin.cambridge.arm.com>
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
 <1374301266-26726-3-git-send-email-prabhakar.csengg@gmail.com>
 <5217A3E7.50706@samsung.com> <CA+V-a8tStFRbELAmZL=418VpR9SJgp8uo_4hrtny2UEMEoXakg@mail.gmail.com>
 <20130827152405.GQ19893@e106331-lin.cambridge.arm.com> <CA+V-a8vuYNNiXJ+iGgceaTqHdM_Q9X2dVDyiHHZPJ+-rSbJgLQ@mail.gmail.com>
 <20130902161715.GB18206@e106331-lin.cambridge.arm.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 4 Sep 2013 12:43:38 +0530
Message-ID: <CA+V-a8vwX__S=A=fYCQpvJQLTUMx0C82p=5XdsCtpMKLF5p-TA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] media: i2c: adv7343: add OF support
To: Mark Rutland <mark.rutland@arm.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Sep 2, 2013 at 9:47 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Aug 28, 2013 at 03:43:04AM +0100, Prabhakar Lad wrote:
>> Hi Mark,
>>
>> On Tue, Aug 27, 2013 at 8:54 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > [fixing up devicetree list address]
>> >
>> Thanks!
>>
>> > On Mon, Aug 26, 2013 at 03:41:45AM +0100, Prabhakar Lad wrote:
>> >> Hi Sylwester,
>> >>
>> >> On Fri, Aug 23, 2013 at 11:33 PM, Sylwester Nawrocki
>> >> <s.nawrocki@samsung.com> wrote:
>> >> > Cc: DT binding maintainers
>> >
>> > Cheers!
>> >
>> >> >
>> >> > On 07/20/2013 08:21 AM, Lad, Prabhakar wrote:
>> >> >> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>> >> >>
>> >> >> add OF support for the adv7343 driver.
>> >> >>
>> >> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >> >> ---
>> >> > [...]
>> >> >>  .../devicetree/bindings/media/i2c/adv7343.txt      |   48 ++++++++++++++++++++
>> >> >>  drivers/media/i2c/adv7343.c                        |   46 ++++++++++++++++++-
>> >> >>  2 files changed, 93 insertions(+), 1 deletion(-)
>> >> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> >> >>
>> >> >> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> >> >> new file mode 100644
>> >> >> index 0000000..5653bc2
>> >> >> --- /dev/null
>> >> >> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> >> >> @@ -0,0 +1,48 @@
>> >> >> +* Analog Devices adv7343 video encoder
>> >> >> +
>> >> >> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
>> >> >> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
>> >> >> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
>> >> >> +definition (SD), enhanced definition (ED), or high definition (HD) video
>> >> >> +formats.
>> >> >> +
>> >> >> +Required Properties :
>> >> >> +- compatible: Must be "adi,adv7343"
>> >> >> +
>> >> >> +Optional Properties :
>> >> >> +- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
>> >> >> +                           micro ampere level. All DACs and the internal PLL
>> >> >> +                           circuit are disabled.
>> >
>> > This seems to be a boolean property, and I couldn't find any description
>> > in the linked datasheet of the constraints under which the unit may be
>> > put into sleep mode.
>> >
>> > Why do we require this property in the dt? Can the driver not always put
>> > a adv734x into sleep mode if it wants to, and then wake it up as
>> > required?
>> >
>> The adv7343 decoder, fits on da850/dm6467 etc.. For the da850 it supports
>> only SD where as the dm6467 supports HD/SD/ED for which DAC 1-6 of
>> Register 0x0 varies for this board so I added them as the platform data
>> but I got a review comment in the ML asking to add entire register as
>> the pdata instead of DAC 1-6, so because of which it is being converted
>> in the same way for DT.
>
> Not everything that appears in platform data should appear in the dt.
> This seems more like a run-time decision that a description of the
> hardware.
>
> I don't see why we need the "adi,power-mode-sleep-mode" property.
>
Ok I will drop "adi,power-mode-sleep-mode" and "adi,power-mode-pll-ctrl"
property from the DT bindings and just have "adi,dac-enable",
"adi,sd-dac-enable" properties as this cannot be handled runtime.

Regards,
--Prabhakar Lad
