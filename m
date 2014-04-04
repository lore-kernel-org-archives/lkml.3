Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaDDM2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:28:12 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:38533 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDDM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140404110837.GS14763@sirena.org.uk>
References: <1396544587-10876-1-git-send-email-punnaia@xilinx.com>
	<203181a5-626f-437e-8efe-983a9d78ec5d@AM1EHSMHS017.ehs.local>
	<20140403212940.GY14763@sirena.org.uk>
	<CAFcVECJiSm8MMJ37c-Qfsu-UE0jgEYRmeGZ8OQG97wyRMaJ1LQ@mail.gmail.com>
	<20140404110837.GS14763@sirena.org.uk>
Date: Fri, 4 Apr 2014 17:56:47 +0530
Message-ID: <CAFcVECLLcVEh+P1EELAZEZhRhUFM--t3pmytv2y10pwCkoxFJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] SPI: Add support for Zynq Quad SPI controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 4, 2014 at 4:38 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 04, 2014 at 08:59:47AM +0530, Harini Katakam wrote:
>> On Fri, Apr 4, 2014 at 2:59 AM, Mark Brown <broonie@kernel.org> wrote:
>
>> > Why would a transfer be being set up without a transfer being provided?
>
>> The setup function calls this function before a transfer is initiated.
>> In this case NULL is passed to setup_transfer (see below) and
>> SPI is initialized with default clock configuration.
>> This initialization is necessary because otherwise this clock config
>> would be done
>> only after SPI is enabled in prepare_hardware, which is wrong.
>> (I'm checking for master->busy in setup to address your previous
>> comment on SPI).
>
> The requirement for setup() to work when other transfers are in progress
> is clear and unambiguous, it really isn't acceptable to reconfigure
> hardware in use by a runing transfer in setup().
>

OK. I'll remove setup_transfer here and handle clock configuration elsewhere.

>> I explained the same in SPI v2 changes and this valid there too.
>
> This is v2?
>

No. This "Zynq QSPI" patch is v1.
I was referring to "Cadence SPI" v2 patch in which you pointed to these
comments.

Sorry for the confusion.

<snip>

>> >> +static int __maybe_unused zynq_qspi_suspend(struct device *_dev)
>> >> +{
>> >> +     struct platform_device *pdev = container_of(_dev,
>> >> +                     struct platform_device, dev);
>> >> +     struct spi_master *master = platform_get_drvdata(pdev);
>> >> +
>> >> +     spi_master_suspend(master);
>> >> +
>> >> +     zynq_unprepare_transfer_hardware(master);
>
>> > Why are you unpreparing the hardware - the framework should be doing
>> > that for you if the device is active, if it's not you've got an extra
>> > clock disable here?
>
>> I called unprepare_hardware  becuase it does the things necessary
>> after master suspend - disable clock and controller.
>> (I thought this was your suggestion for SPI?)
>
> Why are these things required after the core has already idled the
> device (using exactly the same function)?

Ok. It's unecessary I'll remove it.

Regards,
Harini
