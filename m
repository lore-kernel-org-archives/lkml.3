Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaDEXnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 19:43:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63740 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaDEXn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 19:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAFcVEC+vWwepHgsCAP63YG2F_0ZXKMck1YYwi7XU3JQdpC9ZQw@mail.gmail.com>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
	<CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
	<20140404100919.GO14763@sirena.org.uk>
	<CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
	<20140404124637.GT14763@sirena.org.uk>
	<CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
	<CAFcVECJYdW0=r425tWs8y6DJDNh3c75TAzg7+UCNRgLP8WHf+A@mail.gmail.com>
	<CAEgOgz56hhFCy6sjZmw+Wn6uT4rU8mXSpazscPG_uJ-==-uXLw@mail.gmail.com>
	<CAFcVEC+vWwepHgsCAP63YG2F_0ZXKMck1YYwi7XU3JQdpC9ZQw@mail.gmail.com>
Date: Sun, 6 Apr 2014 09:43:25 +1000
X-Google-Sender-Auth: 2Sfl2ngpjFTGxdU4bY1Ialh8LvM
Message-ID: <CAEgOgz5XsOYXyPTpUzx_j=+Z19oksTT5TB8G3r9KbYakrQvgHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation
 for Cadence SPI
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2014 at 4:05 PM, Harini Katakam
<harinikatakamlinux@gmail.com> wrote:
> Hi Peter,
>
> On Sat, Apr 5, 2014 at 4:44 AM, Peter Crosthwaite
> <peter.crosthwaite@xilinx.com> wrote:
>> On Sat, Apr 5, 2014 at 12:30 AM, Harini Katakam
>> <harinikatakamlinux@gmail.com> wrote:
>>> Hi,
>>>
>>> On Fri, Apr 4, 2014 at 7:38 PM, Harini Katakam
>>> <harinikatakamlinux@gmail.com> wrote:
>>>> Hi Mark,
>>>>
>>>> On Fri, Apr 4, 2014 at 6:16 PM, Mark Brown <broonie@kernel.org> wrote:
>>>>> On Fri, Apr 04, 2014 at 05:44:23PM +0530, Harini Katakam wrote:
>>>>>> On Fri, Apr 4, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
>>>>>> > On Fri, Apr 04, 2014 at 08:30:38AM +0530, Harini Katakam wrote:
>>>>>
>>>>>> >> This IP can drive 4 slaves.
>>>>>> >> The sCS line to be driven is selected in spi device structure and
>>>>>> >> that is driven by the software.
>>>>>
>>>>>> > So why specify this in the binding at all?  If the device always has the
>>>>>> > same number of chip selects it's redundant.
>>>>>
>>>>>> I'm sorry, I should have explained that better.
>>>>>> The IP can support upto 4 chip selects.
>>>>>> The num-cs value here is the number of chip selects actually used on the board.
>>
>> Shouldnt it be a property of the controller not the board? How for
>> example do we differentiate between different implementations of
>> cadence SPI controller that only supports up to two CS lines? My
>> thinking is that this property should always be present and = 4 in the
>> Zynq case as the controller always has 4 physical CS lines coming out
>> (before any decoders, pin muxes or slaves etc.).
>>
>>>>>
>>>>> Why does that need to be configured?  Surely the presence of slaves is
>>>>> enough information.
>>
>> And presence of slaves / board info is inferable from subnodes.
>>
>>>>
>>>> OK. I understand.
>>>> Can you comment on the case where a decoder is used?
>>>>
>>>> There is support for adding a decoder where extended slaves can be selected
>>>> through the IP's control register.
>>>> (This is not currently implemented in the driver but will be in the future.)
>>>>
>>
>> I think thats seperate information. is-decoded-cs property of something.
>>
>>>> How should the driver know whether it is 4 or 16 select lines for example?
>>>> This has to be written to master->num_chipselect.
>>>>
>>
>> If you only have one property (== 4) how do you tell the difference
>> between 4 un-decoded CS lines vs 2 decoded CS lines?
>>
>
> If an SoC implements 2 CS and sets "decoder" property,
> then we'd configure the register with "select decode" bit and write
> 0b0011 to the slave select field to select 4th slave.
>
> If decoder property is not set, then we'd write 0b1000 to select 4th slave.
>

What are your proposed dt bindings for these differing options - what
is num-cs in each case?

> But yes, if the SoC only implements 2 CS, doesn't use decoder but
> if there is an erroneous input to set_cs for 4th slave, it would be a problem.
>

Sure, that's an error condition though that should be caught by SPI
because master->num_chipselect would only be 2 right?

Regards,
Peter

>>
>> I think num-cs has validity as the number of CS lines implemented in
>> the controller. For any given SoC, it's constant but could differ
>> between SoCs.
>>
>
> I dint consider that this property will be useful to SoC's implementing <4 CS;
> master->num_chipselect (when set to this property's value)
> will be used to check error conditions.
>
> Regards,
> Harini
