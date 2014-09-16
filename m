Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaIPKNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:13:09 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33113 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaIPKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:13:06 -0400
Date: Tue, 16 Sep 2014 11:12:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "grant.likely@linaro.org" <grant.likely@linaro.org>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Message-ID: <20140916101256.GA21943@localhost>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <20140911132935.068DCC408F6@trevor.secretlab.ca>
 <20140911153739.GA24416@localhost>
 <20140915043116.9985CC407E8@trevor.secretlab.ca>
 <20140915091515.GA1577@arm.com>
 <20140915224800.BA32FC40B84@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915224800.BA32FC40B84@trevor.secretlab.ca>
Thread-Topic: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:48:00PM +0100, Grant Likely wrote:
> On Mon, 15 Sep 2014 10:15:16 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, Sep 15, 2014 at 05:31:16AM +0100, Grant Likely wrote:
> > > On Thu, 11 Sep 2014 16:37:39 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > On Thu, Sep 11, 2014 at 02:29:34PM +0100, Grant Likely wrote:
> > > > > Regarding the requests to refactor ACPICA to work better for ARM. I
> > > > > completely agree that it should be done, but I do not think it should be
> > > > > a prerequisite to getting this core support merged. That kind of
> > > > > refactoring is far easier to justify when it has immediate improvement
> > > > > on the mainline codebase, and it gives us a working baseline to test
> > > > > against. Doing it the other way around just makes things harder.
> > > > 
> > > > I have to disagree here. As I said, I'm perfectly fine with refactoring
> > > > happening later but I'm not happy with compiling in code with undefined
> > > > behaviour on ARM that may actually be executed at run-time.
> > > > 
> > > > I'm being told one of the main advantages of ACPI is forward
> > > > compatibility: running older kernels on newer hardware (potentially with
> > > > newer ACPI version tables). ACPI 5.1 includes partial support for ARM
> > > > but the S and C states are not defined yet. We therefore assume that
> > > > hardware vendors deploying servers using ACPI would not provide such
> > > > yet to be defined information in ACPI 5.1 tables.
> > > 
> > > We're good on this front. ACPI-future platforms aren't allowed to use
> > > new features when booting an older kernel.
> > 
> > Do you mean ACPI-future firmware should not provide new information to
> > older kernels?
> 
> I mean that ACPI has the mechanism so that the platform (via AML)
> doesn't try to do things that the OS doesn't understand.  AML methods are
> to use the \_REV object to determine whether or not it can use a
> feature. If, for example, the _REV is 5, then the AML must switch itself
> to code paths that don't use ACPI 6 features.

So you are talking about AML code paths and from what I understand they
should be fine.

However, what I'm talking about is _kernel_ code paths and functions
like acpi_suspend_enter(). Do you mean this function can only be called
as a result of some AML execution (it doesn't look so to me)? If not,
what guarantees do we have that ACPI-future tables exposed to an older
kernel would not trigger this kernel code path (if compiled in)?

-- 
Catalin
