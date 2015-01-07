Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbbAGLvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:51:00 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56612 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbAGLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:50:57 -0500
Date: Wed, 7 Jan 2015 11:50:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "jcm@redhat.com" <jcm@redhat.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <54AC5C57.7050504@redhat.com>
 <54ACBC5E.3040905@redhat.com>
 <2161376.07iV9ANMSk@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2161376.07iV9ANMSk@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:36:13AM +0000, Arnd Bergmann wrote:
> On Tuesday 06 January 2015 23:55:58 Jon Masters wrote:
> > On 01/06/2015 05:06 PM, Jon Masters wrote:
> > > On 01/06/2015 02:21 PM, Arnd Bergmann wrote:
> > >> On Tuesday 06 January 2015 11:24:43 Jon Masters wrote:
> > >>> On 01/06/2015 06:20 AM, Catalin Marinas wrote:
> > >>>
> > >>>> Now, what's preventing a vendor firmware from providing only ACPI
> > >>>> tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
> > >>>> that both DT and ACPI are supported, or at least that dts files are
> > >>>> merged in the kernel first?
> > >>>
> > >>> I know of some (server) firmware that will only provide ACPI in the
> > >>> medium term, so this is coming.
> > >>
> > >> Medium term is fine, as long as they are not expecting their hardware
> > >> to be supported by Linux before ACPI support is stable enough for
> > >> general consumption.
> > > 
> > > To be clear, I think that's reasonable for upstream. I may love ACPI,
> > > but vendors can always ship kernels with a config supporting ACPI only
> > > platforms in the interim period if they have a commercial justification
> > > and that doesn't have to be supported in terms of the upstream default.
> 
> I would hope that none of the ACPI-only machines are meant to run Linux
> as a primary operating system, that would be very sad.

I keep hearing different stories around this. I think this goes back to
the last point on Al's to-do list, the reason _why_ vendors need ACPI.
As you mentioned some time ago, I would also like to see a summary of
such reasons included in the cover letter for the arm64 ACPI patches. In
the meantime, we can assume that DT is required.

>From what I gathered so far, the main reason for _some_ vendors is not
support for "other" OS but actually features that ACPI has and DT
doesn't (like AML; I deliberately ignore statements like "industry
standard"). _If_ such reasons are sound, maybe they have a case for
ACPI-only machines targeted primarily at Linux.

In theory, it may be beneficial to the kernel maintainers as such
ACPI-only machine would potentially require less kernel driver code
compared to DT. For example, no need for pin control, clocks or voltage
regulator drivers as they are handled in AML. Of course, the counter
argument is that it's harder to debug when problems appear but I would
expect on such ACPI-only machines that the hardware vendor is very
active on solving them (I'm more thinking for machines that sit in some
data centre and are actively maintained rather than some board I keep in
my house; for the latter, I definitely prefer DT and full control).

> Vendors that are interested in Linux support should instead work on getting
> their hardware supported upstream so they don't need a private kernel to
> match their private firmware.

I agree, irrespective of whether they target ACPI longer term or not.

As I said yesterday, at some point in the future, ACPI-only SoC support
may not require any new kernel code, just usual PCIe drivers that may
already be there. If we ever get to that stage (it's not a kernel
problem, it's more about SoC standardisation), vendors would be able to
run mainline kernels without additional driver code with a few SoC
differences handled by AML (e.g. clocks). At that point, I don't see any
incentive for them to upstream additional driver code (e.g. clocks) just
to support a DT-only kernel. We are probably still a long way, nothing
to worry about just yet ;).

-- 
Catalin
