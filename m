Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaJTHWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:22:21 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60368 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaJTHWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:22:18 -0400
Date: Mon, 20 Oct 2014 08:22:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC 6/7] mfd: qcom-smd-rpm: Driver for the Qualcomm RPM over SMD
Message-ID: <20141020072211.GC25349@x1>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-7-git-send-email-bjorn.andersson@sonymobile.com>
 <20141008084017.GD20647@lee--X1>
 <20141017135553.GA28882@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141017135553.GA28882@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2014, Bjorn Andersson wrote:
> On Wed 08 Oct 01:40 PDT 2014, Lee Jones wrote:

[...]

> > > +static struct qcom_smd_driver qcom_smd_rpm_driver = {
> > > +	.probe = qcom_smd_rpm_probe,
> > > +	.remove = qcom_smd_rpm_remove,
> > > +	.callback = qcom_smd_rpm_callback,
> > > +	.driver  = {
> > > +		.name  = "qcom_smd_rpm",
> > > +		.owner = THIS_MODULE,
> > > +		.of_match_table = qcom_smd_rpm_of_match,
> > > +	},
> > > +};
> > > +
> > > +module_qcom_smd_driver(qcom_smd_rpm_driver);
> > 
> > I don't like this.  What's wrong with the existing platform driver
> > code?
> > 
> 
> I started off with having smd child devices as platform drivers and had some
> accessor functions to find the open handles that triggered the probe() and
> register the callback with those. But this didn't feel very sane, so I did
> implemented a custom driver struct and probe prototype to simplify writing
> drivers.
> 
> May I ask why you dislike this? This is how it's done in so many other places
> in the kernel...

I don't believe that's the case.  All owners of their own
module_*_driver() registration calls are busses (see below), whereas
'qcom_smd' is just a driver.  Things would soon get out of control if
we allowed every driver in the kernel to supply their own driver
registration information variants.

$ git grep "^module_.*_driver(" | \
  cut -d: -f2 | cut -d'(' -f1 | sort | uniq

module_acpi_driver
module_amba_driver
module_comedi_driver
module_comedi_pci_driver
module_comedi_pcmcia_driver
module_comedi_usb_driver
module_gameport_driver
module_hid_driver
module_i2c_driver
module_mcb_driver
module_mipi_dsi_driver
module_pci_driver
module_pcmcia_driver
module_platform_driver
module_serio_driver
module_spi_driver
module_spmi_driver
module_usb_composite_driver
module_usb_driver
module_usb_serial_driver
module_virtio_driver

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
