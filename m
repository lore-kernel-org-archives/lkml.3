Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaDDXO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:14:59 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:40553 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaDDXOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:14:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAFcVECJYdW0=r425tWs8y6DJDNh3c75TAzg7+UCNRgLP8WHf+A@mail.gmail.com>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
	<CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
	<20140404100919.GO14763@sirena.org.uk>
	<CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
	<20140404124637.GT14763@sirena.org.uk>
	<CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
	<CAFcVECJYdW0=r425tWs8y6DJDNh3c75TAzg7+UCNRgLP8WHf+A@mail.gmail.com>
Date: Sat, 5 Apr 2014 09:14:48 +1000
X-Google-Sender-Auth: KTxy4qQbhJgfHO0deetQ0Js9gK8
Message-ID: <CAEgOgz56hhFCy6sjZmw+Wn6uT4rU8mXSpazscPG_uJ-==-uXLw@mail.gmail.com>
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

On Sat, Apr 5, 2014 at 12:30 AM, Harini Katakam
<harinikatakamlinux@gmail.com> wrote:
> Hi,
>
> On Fri, Apr 4, 2014 at 7:38 PM, Harini Katakam
> <harinikatakamlinux@gmail.com> wrote:
>> Hi Mark,
>>
>> On Fri, Apr 4, 2014 at 6:16 PM, Mark Brown <broonie@kernel.org> wrote:
>>> On Fri, Apr 04, 2014 at 05:44:23PM +0530, Harini Katakam wrote:
>>>> On Fri, Apr 4, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
>>>> > On Fri, Apr 04, 2014 at 08:30:38AM +0530, Harini Katakam wrote:
>>>
>>>> >> This IP can drive 4 slaves.
>>>> >> The CS line to be driven is selected in spi device structure and
>>>> >> that is driven by the software.
>>>
>>>> > So why specify this in the binding at all?  If the device always has the
>>>> > same number of chip selects it's redundant.
>>>
>>>> I'm sorry, I should have explained that better.
>>>> The IP can support upto 4 chip selects.
>>>> The num-cs value here is the number of chip selects actually used on the board.

Shouldnt it be a property of the controller not the board? How for
example do we differentiate between different implementations of
cadence SPI controller that only supports up to two CS lines? My
thinking is that this property should always be present and = 4 in the
Zynq case as the controller always has 4 physical CS lines coming out
(before any decoders, pin muxes or slaves etc.).

>>>
>>> Why does that need to be configured?  Surely the presence of slaves is
>>> enough information.

And presence of slaves / board info is inferable from subnodes.

>>
>> OK. I understand.
>> Can you comment on the case where a decoder is used?
>>
>> There is support for adding a decoder where extended slaves can be selected
>> through the IP's control register.
>> (This is not currently implemented in the driver but will be in the future.)
>>

I think thats seperate information. is-decoded-cs property of something.

>> How should the driver know whether it is 4 or 16 select lines for example?
>> This has to be written to master->num_chipselect.
>>

If you only have one property (== 4) how do you tell the difference
between 4 un-decoded CS lines vs 2 decoded CS lines?

>> Regards,
>> Harini
>
> Just adding to my above comment.
> Alternately, I could not use the "num-cs" property and add another
> optional property to be used only when required.

I think num-cs has validity as the number of CS lines implemented in
the controller. For any given SoC, it's constant but could differ
between SoCs.

Regards,
Peter

> The driver sets a default value already.
>
> Regards,
> Harini
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
