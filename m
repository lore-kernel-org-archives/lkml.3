Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbbAFTbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:31:05 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:59107 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbbAFTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:31:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Tue, 06 Jan 2015 20:30:40 +0100
Message-ID: <40609667.NRBYGys7aL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150106141133.GF8829@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <3538097.dWBy3R9lty@wuerfel> <20150106141133.GF8829@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:8k7kVlzJOKd5uSFKRgqHh5Kma9K9j9d+EF5eDFILpBhjXX+7RN3
 rLTXupQPbVP4+oNpSPASR7maEnv0nRUMwOlIsy4vqwlZ0zqKFtaGmoLBNzDS6Irf90Ar6VR
 1YJTlvTs18NL4jnXk/gsN9CJX8+hKO1a5r74XsOziiqabZ3jQt8COwol9UG1O19zETsSFDQ
 NvaX8cqPpqF/Qn9gZuSzA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 14:11:33 Catalin Marinas wrote:
> On Tue, Jan 06, 2015 at 01:59:27PM +0000, Arnd Bergmann wrote:
> > On Tuesday 06 January 2015 11:20:01 Catalin Marinas wrote:
> > > On Mon, Jan 05, 2015 at 08:16:30PM +0000, Arnd Bergmann wrote:
> > > > On Monday 05 January 2015 13:13:02 Catalin Marinas wrote:
> > > > > > since passing no DT tables to OS but
> > > > > > acpi=force is missing is a corner case, we can do a follow up patch to
> > > > > > fix that, does it make sense?
> > > > > 
> > > > > Not entirely. Why would no dtb and no acpi=force be a corner case? I
> > > > > thought this should be the default when only ACPI tables are passed, no
> > > > > need for an additional acpi=force argument.
> > > > 
> > > > We don't really support the case of only ACPI tables for now. The expectation
> > > > is that you always have working DT support, at least for the next few years
> > > > as ACPI features are ramping up, and without acpi=force it should not try
> > > > to use ACPI at all.
> > > 
> > > So if both DT and ACPI are present, just use DT unless acpi=force is
> > > passed. So far I think we agree but what I want to avoid is always
> > > mandating acpi=force even when the DT tables are missing (in the long
> > > run).
> > > 
> > > Now, what's preventing a vendor firmware from providing only ACPI
> > > tables? Do we enforce it in some way (arm-acpi.txt, kernel warning etc.)
> > > that both DT and ACPI are supported, or at least that dts files are
> > > merged in the kernel first?
> > 
> > We have no way of enforcing what a board vendor ships, so if they want
> > to have ACPI-only machines for MS Windows, they just won't work by
> > default on Linux.
> 
> What do you mean by "won't work by default on Linux"? Assuming no
> additional drivers are needed (i.e. a few devices mentioned in SBSA and
> the rest on a PCIe bus, using existing drivers without further
> modifications), do you still want mainline to fail to boot on such
> ACPI-only systems?

I mean it won't work without acpi=force on the command line.

> > Once ACPI support is mature enough, we can also have a whitelist or a
> > different default for using it automatically when no DT is present.
> 
> Having a white-list requires some for of SoC identification. Does ACPI
> provide such thing (like "model" or "compatible" strings in the top DT
> node)?

This is independent of the SoC: All SoCs we support have DT drivers, so
machines like this would be board whose vendor doesn't care about Linux,
but happens to use a SoC that we support. What we would need here is
a whitelist of boards.

> > For drivers merged upstream, I would insist that every driver merged
> > for an ARM64 platform has a documented DT binding that is used in the
> > driver.
> 
> That's fine by me. I just hope that for hardware aimed at ACPI we won't
> need many non-PCIe drivers.

Yes, that is a reasonable assumption. Looking at the AMD patches that
were posted already, there are however a few devices that are not on
the PCI bus:

- pl011 uart
- pl022 spi
- pl061 gpio
- pl330 dma
- designware i2c
- custom 10gbit ethernet
- probably some I forgot

Most of these will likely just not be needed on servers (pl330) or
handled by AML (spi, i2c, gpio) transparently without needing a
driver, but we do need to support the ethernet port and the uart.
I expect that other SoCs come with different ethernet implementations
that are also not discoverable through PCI.

	Arnd
