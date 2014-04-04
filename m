Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaDDOaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:30:23 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46769 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaDDOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
	<CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
	<20140404100919.GO14763@sirena.org.uk>
	<CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
	<20140404124637.GT14763@sirena.org.uk>
	<CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
Date: Fri, 4 Apr 2014 20:00:19 +0530
Message-ID: <CAFcVECJYdW0=r425tWs8y6DJDNh3c75TAzg7+UCNRgLP8WHf+A@mail.gmail.com>
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

Hi,

On Fri, Apr 4, 2014 at 7:38 PM, Harini Katakam
<harinikatakamlinux@gmail.com> wrote:
> Hi Mark,
>
> On Fri, Apr 4, 2014 at 6:16 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Fri, Apr 04, 2014 at 05:44:23PM +0530, Harini Katakam wrote:
>>> On Fri, Apr 4, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
>>> > On Fri, Apr 04, 2014 at 08:30:38AM +0530, Harini Katakam wrote:
>>
>>> >> This IP can drive 4 slaves.
>>> >> The CS line to be driven is selected in spi device structure and
>>> >> that is driven by the software.
>>
>>> > So why specify this in the binding at all?  If the device always has the
>>> > same number of chip selects it's redundant.
>>
>>> I'm sorry, I should have explained that better.
>>> The IP can support upto 4 chip selects.
>>> The num-cs value here is the number of chip selects actually used on the board.
>>
>> Why does that need to be configured?  Surely the presence of slaves is
>> enough information.
>
> OK. I understand.
> Can you comment on the case where a decoder is used?
>
> There is support for adding a decoder where extended slaves can be selected
> through the IP's control register.
> (This is not currently implemented in the driver but will be in the future.)
>
> How should the driver know whether it is 4 or 16 select lines for example?
> This has to be written to master->num_chipselect.
>
> Regards,
> Harini

Just adding to my above comment.
Alternately, I could not use the "num-cs" property and add another
optional property to be used only when required.
The driver sets a default value already.

Regards,
Harini
