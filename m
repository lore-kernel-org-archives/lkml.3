Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaDDDAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:00:45 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34910 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDDAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140403213446.GB14763@sirena.org.uk>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
Date: Fri, 4 Apr 2014 08:30:38 +0530
Message-ID: <CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation
 for Cadence SPI
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 4, 2014 at 3:04 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 03, 2014 at 04:40:31PM +0530, Harini Katakam wrote:
>
>> +Optional properties:
>> +- num-cs             : Number of chip selects used.
>
> How does this translate to the hardware?

This IP can drive 4 slaves.
The CS line to be driven is selected in spi device structure and
that is driven by the software.

>
>> +             num-cs = /bits/ 16 <4>;
>
> What's going on with the /bits/ - is this something that's required for
> the property?

The master->num-chipselect property is 16 bit but writing <4> here directly
leads to 0 being read in of_property_read (because it's big endian).
Instead using of property read u32 and then copying, we decided to do this.
This was discussed on v2 between Michal and Rob:
>>>> +               num-chip-select = /bits/ 16 <4>;
>>
>> I was expecting you will comment this a little bit. :-)
>> Because all just reading this num-cs as 32bit and then
>> assigning this value to master->num_chipselect which is 16bit.
>
> Well, everyone else has that problem then. Obviously it takes a bit
> more care than just reading into a u32, but that is a kernel problem
> and not a problem of the binding.
They are not reading it directly with read_u32 but they are using
intermediate u32 value which is assigned to u16 which is fine.
This pattern is in most drivers(maybe all).
The point is if binding should or can't simplify driver code.
And from your reaction above I expect that it is up to driver
owner and binding doc how you want to do it.

Regards,
Harini
