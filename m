Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130Ab3IDOs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:48:26 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52309 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934454Ab3IDOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:48:23 -0400
Date: Wed, 4 Sep 2013 15:48:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 2/2] media: i2c: adv7343: add OF support
Message-ID: <20130904144809.GN18206@e106331-lin.cambridge.arm.com>
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
 <1374301266-26726-3-git-send-email-prabhakar.csengg@gmail.com>
 <5217A3E7.50706@samsung.com>
 <CA+V-a8tStFRbELAmZL=418VpR9SJgp8uo_4hrtny2UEMEoXakg@mail.gmail.com>
 <20130827152405.GQ19893@e106331-lin.cambridge.arm.com>
 <CA+V-a8vuYNNiXJ+iGgceaTqHdM_Q9X2dVDyiHHZPJ+-rSbJgLQ@mail.gmail.com>
 <20130902161715.GB18206@e106331-lin.cambridge.arm.com>
 <CA+V-a8vwX__S=A=fYCQpvJQLTUMx0C82p=5XdsCtpMKLF5p-TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8vwX__S=A=fYCQpvJQLTUMx0C82p=5XdsCtpMKLF5p-TA@mail.gmail.com>
Thread-Topic: [PATCH v3 2/2] media: i2c: adv7343: add OF support
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 08:13:38AM +0100, Prabhakar Lad wrote:
> Hi Mark,

Hi Prabhakar,

> 
> On Mon, Sep 2, 2013 at 9:47 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Aug 28, 2013 at 03:43:04AM +0100, Prabhakar Lad wrote:
> >> Hi Mark,
> >>
> >> On Tue, Aug 27, 2013 at 8:54 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > [fixing up devicetree list address]
> >> >
> >> Thanks!
> >>
> >> > On Mon, Aug 26, 2013 at 03:41:45AM +0100, Prabhakar Lad wrote:
> >> >> Hi Sylwester,
> >> >>
> >> >> On Fri, Aug 23, 2013 at 11:33 PM, Sylwester Nawrocki
> >> >> <s.nawrocki@samsung.com> wrote:
> >> >> > Cc: DT binding maintainers
> >> >
> >> > Cheers!
> >> >
> >> >> >
> >> >> > On 07/20/2013 08:21 AM, Lad, Prabhakar wrote:
> >> >> >> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >> >> >>
> >> >> >> add OF support for the adv7343 driver.
> >> >> >>
> >> >> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> >> >> ---
> >> >> > [...]
> >> >> >>  .../devicetree/bindings/media/i2c/adv7343.txt      |   48 ++++++++++++++++++++
> >> >> >>  drivers/media/i2c/adv7343.c                        |   46 ++++++++++++++++++-
> >> >> >>  2 files changed, 93 insertions(+), 1 deletion(-)
> >> >> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
> >> >> >>
> >> >> >> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> >> >> >> new file mode 100644
> >> >> >> index 0000000..5653bc2
> >> >> >> --- /dev/null
> >> >> >> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> >> >> >> @@ -0,0 +1,48 @@
> >> >> >> +* Analog Devices adv7343 video encoder
> >> >> >> +
> >> >> >> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
> >> >> >> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
> >> >> >> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
> >> >> >> +definition (SD), enhanced definition (ED), or high definition (HD) video
> >> >> >> +formats.
> >> >> >> +
> >> >> >> +Required Properties :
> >> >> >> +- compatible: Must be "adi,adv7343"
> >> >> >> +
> >> >> >> +Optional Properties :
> >> >> >> +- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
> >> >> >> +                           micro ampere level. All DACs and the internal PLL
> >> >> >> +                           circuit are disabled.
> >> >
> >> > This seems to be a boolean property, and I couldn't find any description
> >> > in the linked datasheet of the constraints under which the unit may be
> >> > put into sleep mode.
> >> >
> >> > Why do we require this property in the dt? Can the driver not always put
> >> > a adv734x into sleep mode if it wants to, and then wake it up as
> >> > required?
> >> >
> >> The adv7343 decoder, fits on da850/dm6467 etc.. For the da850 it supports
> >> only SD where as the dm6467 supports HD/SD/ED for which DAC 1-6 of
> >> Register 0x0 varies for this board so I added them as the platform data
> >> but I got a review comment in the ML asking to add entire register as
> >> the pdata instead of DAC 1-6, so because of which it is being converted
> >> in the same way for DT.
> >
> > Not everything that appears in platform data should appear in the dt.
> > This seems more like a run-time decision that a description of the
> > hardware.
> >
> > I don't see why we need the "adi,power-mode-sleep-mode" property.
> >
> Ok I will drop "adi,power-mode-sleep-mode" and "adi,power-mode-pll-ctrl"
> property from the DT bindings and just have "adi,dac-enable",
> "adi,sd-dac-enable" properties as this cannot be handled runtime.

I'm still somewhat confused by these properties. The "adi,sd-dac-enable"
property only describes two, the "sd" DACs, and "adi,dac-enable"
describes 6. From the block diagram in the device manual, there are only
6 DACs (1...6). None of the DACs seem to be limited in what they support
(unless that's described elsewhere), so I don't understand what the "sd"
DACs are. Could you elaborate?

Which DACs are being described by each property? They seem to overlap.

Why do we need to program them as on or off? Surely that depends on
whether or not they're connected to anything and whether or not we want
something to appear on that output? Can the "REFERENCE AND CABLE DETECT"
unit tell us that?

Until the binding is clarified and stabilised, I don't think the binding
or driver should be merged.

Thanks,
Mark.
