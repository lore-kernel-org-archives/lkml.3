Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaFPRDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:03:14 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64764 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaFPRDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:03:12 -0400
Date: Mon, 16 Jun 2014 18:03:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/7] mfd: add atmel-hlcdc driver
Message-ID: <20140616170301.GC14323@lee--X1>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
 <1402329860-27520-2-git-send-email-boris.brezillon@free-electrons.com>
 <20140616125030.GT14323@lee--X1>
 <539EEFD8.20703@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <539EEFD8.20703@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Boris BREZILLON wrote:
> On 16/06/2014 14:50, Lee Jones wrote:
> >> The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
> >> family or sama5d3 family) exposes 2 subdevices:
> >> - a display controller (controlled by a DRM driver)
> >> - a PWM chip
> >>
> >> Add support for the MFD device which will just retrieve HLCDC clocks and
> >> create a regmap so that subdevices can access the HLCDC register range
> >> concurrently.
> >>
> >> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >> ---
> >>  .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  41 ++++++++
> >>  drivers/mfd/Kconfig                                |  11 ++
> >>  drivers/mfd/Makefile                               |   1 +
> >>  drivers/mfd/atmel-hlcdc.c                          | 116 +++++++++++++++++++++
> >>  include/linux/mfd/atmel-hlcdc.h                    |  78 ++++++++++++++
> >>  5 files changed, 247 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
> >>  create mode 100644 drivers/mfd/atmel-hlcdc.c
> >>  create mode 100644 include/linux/mfd/atmel-hlcdc.h
> >> diff --git a/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
> >> new file mode 100644
> >> index 0000000..f5b69cb
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt

[...]

> >> +		hlcdc-display-controller {
> >> +			compatible = "atmel,hlcdc-dc";
> >> +			interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
> > I assume you're using the 3rd parameter for flags.  If so, please use
> > the defines.
> 
> No, the third parameter encodes the irq priority (from 0 to 7 IIRC).

Ah okay.  Can you point me to the documentation for this IRQ
controller please?  I'd like to have a quick peek.  It might be worth
defining the priority to prevent confusion, also you definitely should
document it in your binding.

[...]

> >> +static struct platform_driver atmel_hlcdc_driver = {
> >> +	.probe = atmel_hlcdc_probe,
> >> +	.remove = atmel_hlcdc_remove,
> >> +	.driver = {
> >> +		.name = "atmel-hlcdc",
> >> +		.owner = THIS_MODULE,
> >> +		.of_match_table = atmel_hlcdc_match,
> > Is this driver DT only?
> 
> Yes it is.

So it should depend on OF in the Kconfig entry.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
