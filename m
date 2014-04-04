Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaDDMO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:14:27 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:40643 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaDDMOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:14:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140404100919.GO14763@sirena.org.uk>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
	<CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
	<20140404100919.GO14763@sirena.org.uk>
Date: Fri, 4 Apr 2014 17:44:23 +0530
Message-ID: <CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
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

On Fri, Apr 4, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 04, 2014 at 08:30:38AM +0530, Harini Katakam wrote:
>> On Fri, Apr 4, 2014 at 3:04 AM, Mark Brown <broonie@kernel.org> wrote:
>> > On Thu, Apr 03, 2014 at 04:40:31PM +0530, Harini Katakam wrote:
>
>> >> +Optional properties:
>> >> +- num-cs             : Number of chip selects used.
>
>> > How does this translate to the hardware?
>
>> This IP can drive 4 slaves.
>> The CS line to be driven is selected in spi device structure and
>> that is driven by the software.
>
> So why specify this in the binding at all?  If the device always has the
> same number of chip selects it's redundant.

I'm sorry, I should have explained that better.
The IP can support upto 4 chip selects.
The num-cs value here is the number of chip selects actually used on the board.

>
>> >> +             num-cs = /bits/ 16 <4>;
>
>> > What's going on with the /bits/ - is this something that's required for
>> > the property?
>
>> The master->num-chipselect property is 16 bit but writing <4> here directly
>> leads to 0 being read in of_property_read (because it's big endian).
>> Instead using of property read u32 and then copying, we decided to do this.
>> This was discussed on v2 between Michal and Rob:
>
> No, don't do that.  You're contorting the binding to serve Linux's
> implementation needs and you've not documented this requirement either.
> If there *was* a need to have the number be 16 bits you'd need to
> document that reqirement in the binding, though like I say I don't think
> the number needs to be there at all.

OK. I'll remove the /bits/ 16 and handle it in the driver.

Regards,
Harini
