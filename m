Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbaAVPRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:17:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57476 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932142AbaAVPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:17:51 -0500
Date: Wed, 22 Jan 2014 15:17:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro
 CLOCKSOURCE_ACPI_DECLARE
Message-ID: <20140122151749.GA1519@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <52DCE790.6080809@linaro.org>
 <20140122114616.GB15591@e106331-lin.cambridge.arm.com>
 <3140612.0s75qS6VKb@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3140612.0s75qS6VKb@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 02:56:05PM +0000, Arnd Bergmann wrote:
> On Wednesday 22 January 2014 11:46:16 Mark Rutland wrote:
> > On Mon, Jan 20, 2014 at 09:08:32AM +0000, Hanjun Guo wrote:
> > > On 2014-1-17 22:21, Arnd Bergmann wrote:
> > > > On Friday 17 January 2014, Hanjun Guo wrote:
> > > >>
> > > >> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > > >>
> > > >> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
> > > >> name from the ACPI timer table is matched with all the registered
> > > >> timer controllers and matching initialisation routine is invoked.
> > > > 
> > > > I wouldn't anticipate this infrastructure to be required. Shouldn't all
> > > > ARMv8 machines have an architected timer?
> > > 
> > > I not sure of this, could anyone can give some guidance? if only arch
> > > timer is available for ARM64, this will make thing very simple.
> > 
> > All ARMv8 systems should have an architected timer.
> > 
> > However, they may also have other timers (e.g. global timers for use
> > when CPUs are in low power states and their local architected timers
> > aren't active).
> 
> But all other timers could be regular platform drivers I suppose. No
> need for special infrastructure for those.

Except for the fact that some timers / clocksources that we already have
in 32-bit land will likely be reused in 64-bit SoC designs. People will
want to use the same driver for both 32-bit and 64-bit kernels, and thus
we need CLOCKSOURCE_OF_DECLARE in 64-bit kernels.

Those platforms which will have ACPI will likely reuse existing timer IP
blocks, and will want to make minimal changes to the driver, which will
likely be using CLOCKSOURCE_OF_DECLARE. We can't change these to
platform drivers or we can break existing systems because the timers
will be registered too late.

I don't see how we can share drivers between 32-bit and 64-bit kernels
without sharing a common driver model, and I think it makes sense to
have some uniformity across drivers (i.e. always use
CLOCKSOURCE_*_DECLARE rather than sometimes using platform drivers).

Thanks,
Mark.
