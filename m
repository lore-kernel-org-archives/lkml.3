Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaIBN1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:27:12 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13258 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105AbaIBN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:27:09 -0400
Date: Tue, 2 Sep 2014 14:26:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC PATCH for Juno 1/2] net: smsc911x add support for probing
 from ACPI
Message-ID: <20140902132651.GF27056@arm.com>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <20140901170447.GF608@arm.com>
 <21764799.KDNDm9XRax@wuerfel>
 <20140901173245.GM2953@xora-haswell.xora.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901173245.GM2953@xora-haswell.xora.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 06:32:45PM +0100, Graeme Gregory wrote:
> On Mon, Sep 01, 2014 at 07:11:44PM +0200, Arnd Bergmann wrote:
> > On Monday 01 September 2014 18:04:47 Catalin Marinas wrote:
> > > On Mon, Sep 01, 2014 at 04:06:00PM +0100, Hanjun Guo wrote:
> > > > +#ifdef CONFIG_ACPI
> > > > +/* Configure some sensible defaults for ACPI mode */
> > > > +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> > > > +                                 acpi_handle *ahandle)
> > > > +{
> > > > +     if (!ahandle)
> > > > +             return -ENOSYS;
> > > > +
> > > > +     config->phy_interface = PHY_INTERFACE_MODE_MII;
> > > > +
> > > > +     config->flags |= SMSC911X_USE_32BIT;
> > > > +
> > > > +     config->irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_HIGH;
> > > > +
> > > > +     config->irq_type = SMSC911X_IRQ_TYPE_PUSH_PULL;
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +#else
> > > 
> > > I don't like this and it shows issues we have with ACPI on certain ARM
> > > platforms. You hard-code these values to match the Juno platform. What
> > > if we get another SoC which has different configuration here? For DT, we
> > > have the smsc911x_probe_config_dt() which reads the relevant information
> > > from DT. I think this kind of configuration would be more suitable as
> > > _DSD properties and sharing the similar names with DT (but we go back to
> > > the question about who's in charge of the _DSD properties).
> > 
> > Good point, I totally missed that.
> > 
> > There is of course the possibility to set those values based on the
> > acpi_device_id, but that is exactly the part that _DSD is trying to
> > avoid.
> 
> This will of course most likely be replaced by _DSD values. I just
> hardcoded for now as _DSD is not yet in the kernel and issues around
> maintenance of bindings are not solved (unless this happened at KS where
> I was not present).

Not much at the KS, I think it will need to be followed up on lkml
(https://lkml.org/lkml/2014/8/17/10 is the last I'm aware of, not sure
about any updates in the meantime).

While the above gets sorted, what's the position from an ARM
perspective (and covered by Documentation/arm64/arm-acpi.txt)? I think
the "Device Enumeration" section in this document is fine, it's just the
kernel infrastructure missing.

Alternatively, you can say _DSD is not allowed (yet?) but I don't
particularly like basing the configuration on acpi_device_id like in
this patch. Which would leave us with ignoring any SoC containing
devices that require such specific configuration.

-- 
Catalin
