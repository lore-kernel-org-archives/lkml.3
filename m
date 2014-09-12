Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaILQdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:33:02 -0400
Received: from www.xora.org.uk ([80.68.91.202]:46628 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaILQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:32:58 -0400
Date: Fri, 12 Sep 2014 17:32:54 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 05/18] ARM64 / ACPI: Introduce sleep-arm.c
Message-ID: <20140912163254.GC9234@xora-haswell.xora.org.uk>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-6-git-send-email-hanjun.guo@linaro.org>
 <20140912145102.GB5532@arm.com>
 <20140912151850.GB9234@xora-haswell.xora.org.uk>
 <20140912154903.GE5532@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912154903.GE5532@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:49:03PM +0100, Catalin Marinas wrote:
> On Fri, Sep 12, 2014 at 04:18:51PM +0100, Graeme Gregory wrote:
> > On Fri, Sep 12, 2014 at 03:51:02PM +0100, Catalin Marinas wrote:
> > > On Fri, Sep 12, 2014 at 03:00:03PM +0100, Hanjun Guo wrote:
> > > > --- a/drivers/acpi/Makefile
> > > > +++ b/drivers/acpi/Makefile
> > > > @@ -23,7 +23,11 @@ acpi-y				+= nvs.o
> > > >  
> > > >  # Power management related files
> > > >  acpi-y				+= wakeup.o
> > > > +ifeq ($(ARCH), arm64)
> > > > +acpi-y				+= sleep-arm.o
> > > > +else # X86, IA64
> > > >  acpi-y				+= sleep.o
> > > > +endif
> > > >  acpi-y				+= device_pm.o
> > > >  acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
> > > 
> > > What about:
> > > 
> > > -acpi-y				+= sleep.o
> > > +acpi-$(CONFIG_ACPI_SLEEP)	+= sleep.o
> > > 
> > > and make CONFIG_ACPI_SLEEP depend on !ARM64? Does the kernel compile if
> > > you disable CONFIG_ACPI_SLEEP?
> > 
> > sleep.c is still needed in the case CONFIG_ACPI_SLEEP=n
> > 
> > basically the two functions I stubbed are always called by bus.c
> 
> So the two functions are:
> 
> acpi_target_system_state() - already defined in acpi_bus.h when
> CONFIG_ACPI_SLEEP is off.
> 
> acpi_sleep_init() - this one doesn't have a dummy implementation for
> !ACPI_SLEEP.
> 
> Now, for x86, do we need acpi_sleep_init() when CONFIG_ACPI_SLEEP is
> off? If not, we could simply add a dummy acpi_sleep_init() function when
> !ACPI_SLEEP and don't enable the config option for arm64.
> 
It looks to me that it still does processing for the S5 state which is
soft off.

It sets up the operations to be called when entering this state and also
sets up a notifier.

Graeme

