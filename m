Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaIKQGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:06:33 -0400
Received: from www.xora.org.uk ([80.68.91.202]:43319 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaIKQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:06:31 -0400
Date: Thu, 11 Sep 2014 17:06:27 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
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
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Message-ID: <20140911160627.GU6558@xora-haswell.xora.org.uk>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <20140911132935.068DCC408F6@trevor.secretlab.ca>
 <20140911153739.GA24416@localhost>
 <5411C664.4060007@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411C664.4060007@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:57:24PM +0100, Sudeep Holla wrote:
> 
> 
> On 11/09/14 16:37, Catalin Marinas wrote:
> >On Thu, Sep 11, 2014 at 02:29:34PM +0100, Grant Likely wrote:
> >>Regarding the requests to refactor ACPICA to work better for ARM. I
> >>completely agree that it should be done, but I do not think it should be
> >>a prerequisite to getting this core support merged. That kind of
> >>refactoring is far easier to justify when it has immediate improvement
> >>on the mainline codebase, and it gives us a working baseline to test
> >>against. Doing it the other way around just makes things harder.
> >
> >I have to disagree here. As I said, I'm perfectly fine with refactoring
> >happening later but I'm not happy with compiling in code with undefined
> >behaviour on ARM that may actually be executed at run-time.
> >
> >I'm being told one of the main advantages of ACPI is forward
> >compatibility: running older kernels on newer hardware (potentially with
> >newer ACPI version tables). ACPI 5.1 includes partial support for ARM
> >but the S and C states are not defined yet. We therefore assume that
> >hardware vendors deploying servers using ACPI would not provide such
> >yet to be defined information in ACPI 5.1 tables.
> >
> >What if in a year time we get ACPI 5.2 or 6 (or an errata update)
> >covering the S and C states for ARM? I would expect hardware vendors
> >to take advantage and provide such information in ACPI tables. Can we
> >guarantee that a kernel with the current ACPI patches wouldn't blow up
> >when it tries to interpret the new tables? If we can't guarantee this,
> >we rather fix it now. Some suggestions:
> >
> >a) Make sure code which doesn't have a clear behaviour on ARM is not
> >    compiled in and doesn't even try to interpret such tables on ARM (you
> >    could just go for the latter but I'm not sure how feasible it is)
> 
> This what we have suggested in past especially for this S-state support.
> Currently the core acpi code compiles in sleep support unconditionally.
> That doesn't mean we need to do the same on ARM64, we can easily make
> sure that's not enabled for ARM64 until we have clarification on how to
> support them on ARM in ACPI specification.
> 
> I just pointed out at one "out of spec" workaround done for x86
> "unconditionally" in the code just to tell that it won't work on ARM.
> That shouldn't be misunderstood as demand for refactoring as we have no
> clue how S-state would look on ARM to take up any such task.
> 
For the sleep.c case I worked on this and sent some updates to Hanjun so
it should be compiled out in the next version of the patches.

Graeme

