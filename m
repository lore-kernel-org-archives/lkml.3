Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaIIWEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:04:33 -0400
Received: from www.xora.org.uk ([80.68.91.202]:38968 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaIIWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:04:31 -0400
Date: Tue, 9 Sep 2014 23:04:23 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Mark Rutland <Mark.Rutland@arm.com>,
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
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 03/17] ARM64 / ACPI: Introduce lowlevel suspend
 function
Message-ID: <20140909220423.GL6558@xora-haswell.xora.org.uk>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <1409583475-6978-4-git-send-email-hanjun.guo@linaro.org>
 <20140909163529.GA6370@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909163529.GA6370@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:35:29PM +0100, Catalin Marinas wrote:
> On Mon, Sep 01, 2014 at 03:57:41PM +0100, Hanjun Guo wrote:
> > From: Graeme Gregory <graeme.gregory@linaro.org>
> > 
> > acpi_wakeup_address is used on x86 as the address bios jumps into
> > when machine wakes up from suspend. As arm64 does not have such a
> > bios this mechanism will be provided by other means. But the define
> > is still required inside the acpi core.
> > 
> > Introduce a null stub for acpi_suspend_lowlevel as this is also
> > required by core. This will be filled in when standards are
> > defined for arm64 ACPI global power states.
> 
> Do we actually plan to use these on arm64? I'm worried most of these
> don't make sense on arm64 (the aim is to use PSCI). Is it possible to
> refactor the core code so that we don't have to define dummy macros or
> variables just to be able to build the kernel?
> 
Currently ia64 does the same as this for stubbing out the functions.

We did investigate removing the code but that ultimately ended with more
functions and variables stubbed then this.

Graeme

