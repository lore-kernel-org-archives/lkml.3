Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbbAGNHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:07:09 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50341 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbbAGNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:07:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Rob Herring <robh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Wed, 07 Jan 2015 14:06:28 +0100
Message-ID: <1520439.Y1rXzXY1eS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <2161376.07iV9ANMSk@wuerfel> <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:eZxW3GH1E1v90dnLWONKrZd4gNG1u5w1rDjUt5f3bgwD2OaeXXE
 VTImmcdUm9HGsxs7VCA9+U/q39l81DGzg0Iqm/dfgl3xGCmhJigq9CK/be0ASOXlCS3JE+/
 bZIQhwyQ7FhNsl/UZWgk17HLm77LBOtbFri2/ZgrH153TfI+vEu8LRXbXhAUE19KkoP+/2M
 Yo9xIsZi+hUJrdLCbVUjg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 11:50:39 Catalin Marinas wrote:
> On Wed, Jan 07, 2015 at 10:36:13AM +0000, Arnd Bergmann wrote:
> > On Tuesday 06 January 2015 23:55:58 Jon Masters wrote:
> > > On 01/06/2015 05:06 PM, Jon Masters wrote:
> > > > On 01/06/2015 02:21 PM, Arnd Bergmann wrote:
> > > >> On Tuesday 06 January 2015 11:24:43 Jon Masters wrote:
> > > >>> On 01/06/2015 06:20 AM, Catalin Marinas wrote:
> > > >>>
> > > >>>> Now, what's preventing a vendor firmware from providing only ACPI
> > > >>>> tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
> > > >>>> that both DT and ACPI are supported, or at least that dts files are
> > > >>>> merged in the kernel first?
> > > >>>
> > > >>> I know of some (server) firmware that will only provide ACPI in the
> > > >>> medium term, so this is coming.
> > > >>
> > > >> Medium term is fine, as long as they are not expecting their hardware
> > > >> to be supported by Linux before ACPI support is stable enough for
> > > >> general consumption.
> > > > 
> > > > To be clear, I think that's reasonable for upstream. I may love ACPI,
> > > > but vendors can always ship kernels with a config supporting ACPI only
> > > > platforms in the interim period if they have a commercial justification
> > > > and that doesn't have to be supported in terms of the upstream default.
> > 
> > I would hope that none of the ACPI-only machines are meant to run Linux
> > as a primary operating system, that would be very sad.
> 
> I keep hearing different stories around this. I think this goes back to
> the last point on Al's to-do list, the reason _why_ vendors need ACPI.
> As you mentioned some time ago, I would also like to see a summary of
> such reasons included in the cover letter for the arm64 ACPI patches. In
> the meantime, we can assume that DT is required.

Right, if we can finish the discussion about the reason for having ACPI,
we can skip a lot of pointless back-and-forth on the other issues.

> From what I gathered so far, the main reason for _some_ vendors is not
> support for "other" OS but actually features that ACPI has and DT
> doesn't (like AML; I deliberately ignore statements like "industry
> standard"). _If_ such reasons are sound, maybe they have a case for
> ACPI-only machines targeted primarily at Linux.

What I got from the replies from HP, Huawei and from earlier discussions
with Jon is that they all hope to get to the point of relying on AML
alone to bridge the differences between SoC families. However, I don't
see that happening with the limited hardware compatibility that the
existing SBSA provides:

> In theory, it may be beneficial to the kernel maintainers as such
> ACPI-only machine would potentially require less kernel driver code
> compared to DT. For example, no need for pin control, clocks or voltage
> regulator drivers as they are handled in AML. Of course, the counter
> argument is that it's harder to debug when problems appear but I would
> expect on such ACPI-only machines that the hardware vendor is very
> active on solving them (I'm more thinking for machines that sit in some
> data centre and are actively maintained rather than some board I keep in
> my house; for the latter, I definitely prefer DT and full control).

The main problem here is that can AML only cover part of the problem:
it can talk to a clock controller e.g. over I2C, SPI, GPIO, UART
or IPMI, but you still need a device driver in the kernel to talk to
those, and SBSA doesn't mandate a specific implementation so you can
expect every other SoC that is coming out to have a different one.

Similarly, SBSA is rather vague about some peripherals it mandates,
and if a new SoC has a slightly different AHCI variation, there is
nothing you can do about it in AML.

x86 gets around this problem by having an extreme level of hardware
backwards compatibility, so you don't even need AML for this and
can generally boot a (almost) full-featured Linux kernel with
acpi=off on the command line.

> > Vendors that are interested in Linux support should instead work on getting
> > their hardware supported upstream so they don't need a private kernel to
> > match their private firmware.
> 
> I agree, irrespective of whether they target ACPI longer term or not.
> 
> As I said yesterday, at some point in the future, ACPI-only SoC support
> may not require any new kernel code, just usual PCIe drivers that may
> already be there. If we ever get to that stage (it's not a kernel
> problem, it's more about SoC standardisation), vendors would be able to
> run mainline kernels without additional driver code with a few SoC
> differences handled by AML (e.g. clocks). At that point, I don't see any
> incentive for them to upstream additional driver code (e.g. clocks) just
> to support a DT-only kernel. We are probably still a long way, nothing
> to worry about just yet ;).

Agreed on all points, yes.

	Arnd
