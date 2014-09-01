Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaIAP27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:28:59 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35780 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaIAP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:28:58 -0400
Date: Mon, 1 Sep 2014 16:28:54 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-acpi@lists.linaro.org, Rob Herring <robh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-acpi@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support
 for probing from ACPI
Message-ID: <20140901152854.GJ2953@xora-haswell.xora.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <2861461.8zNpLC3I2n@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2861461.8zNpLC3I2n@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 05:17:51PM +0200, Arnd Bergmann wrote:
> On Monday 01 September 2014 23:06:00 Hanjun Guo wrote:
> > +#ifdef CONFIG_ACPI
> > +/* Configure some sensible defaults for ACPI mode */
> > +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> > +                                   acpi_handle *ahandle)
> > +{
> > +       if (!ahandle)
> > +               return -ENOSYS;
> > +
> > +       config->phy_interface = PHY_INTERFACE_MODE_MII;
> > 
> 
> Please remove the #ifdef and use 
> 
> 	if (!IS_ENABLED(CONFIG_ACPI) || !ahandle)
> 
> to check for ACPI support. This should result in the same object code
> in all cases, but give better compile-time coverage when ACPI is
> disabled.
> 
struct acpi_handle does not exist in the case !CONFIG_ACPI

> Also, -ENOSYS is probably the wrong return value. I think you mean
> -ENXIO.
> 
Yes that would make sense thanks.

Not sure if we are planning to actually upstream this patch, I guess it
depends if ARM start shipping Junos with the ACPI tables loaded on them.

Graeme

