Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaIARDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:03:05 -0400
Received: from www.xora.org.uk ([80.68.91.202]:53100 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaIARDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:03:02 -0400
Date: Mon, 1 Sep 2014 18:03:00 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support
 for probing from ACPI
Message-ID: <20140901170259.GK2953@xora-haswell.xora.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <2861461.8zNpLC3I2n@wuerfel>
 <20140901152854.GJ2953@xora-haswell.xora.org.uk>
 <20140901165333.GE608@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901165333.GE608@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 05:53:33PM +0100, Catalin Marinas wrote:
> On Mon, Sep 01, 2014 at 04:28:54PM +0100, Graeme Gregory wrote:
> > On Mon, Sep 01, 2014 at 05:17:51PM +0200, Arnd Bergmann wrote:
> > > On Monday 01 September 2014 23:06:00 Hanjun Guo wrote:
> > > > +#ifdef CONFIG_ACPI
> > > > +/* Configure some sensible defaults for ACPI mode */
> > > > +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> > > > +                                   acpi_handle *ahandle)
> > > > +{
> > > > +       if (!ahandle)
> > > > +               return -ENOSYS;
> > > > +
> > > > +       config->phy_interface = PHY_INTERFACE_MODE_MII;
> > > > 
> > > 
> > > Please remove the #ifdef and use 
> > > 
> > > 	if (!IS_ENABLED(CONFIG_ACPI) || !ahandle)
> > > 
> > > to check for ACPI support. This should result in the same object code
> > > in all cases, but give better compile-time coverage when ACPI is
> > > disabled.
> > > 
> > struct acpi_handle does not exist in the case !CONFIG_ACPI
> 
> Confused. Then how come smsc911x_drv_probe() has this line:
> 
> 	acpi_handle *ahandle = ACPI_HANDLE(&pdev->dev);
> 
> without any #ifdef's.
> 
It is possible I confused myself as some types moved around in ACPI
recently. I will re-check!

Graeme

