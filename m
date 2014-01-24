Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaAXPoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:44:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49191 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbaAXPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:44:18 -0500
Date: Fri, 24 Jan 2014 15:44:17 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro
 CLOCKSOURCE_ACPI_DECLARE
Message-ID: <20140124154417.GB4758@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
 <CACRpkdYKwaH5DX27irzmcTDAMhQMUhuzz6N7mjKWv9tZchv0Ug@mail.gmail.com>
 <20140122114537.GA15591@e106331-lin.cambridge.arm.com>
 <52E1B1DE.5050507@linaro.org>
 <20140124120815.GH814@e106331-lin.cambridge.arm.com>
 <20140124151513.GD19052@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124151513.GD19052@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 03:15:13PM +0000, Catalin Marinas wrote:
> Do we still need the chosen node to be passed via DT for command line,
> even if the kernel uses ACPI?

It depends on how the kernel is booted.

If not booted as a UEFI application, then the user would have to provide
a dtb to pass the command line.

If booted as a UEFI application, the kernel can retrieve the commandline
from UEFI and handle it appropriately (this _might_ involve the EFI stub
building a dtb with a chosen node and pasing that to the kernel, but
that could change as it's within the kernel). In that case, the user
need not build a dtb manually.

However, I'd expect that we use a restricted dtb with only a /chosen
node for passing additional data as an equivalent to x86's bootargs
(which would contain the location of ACPI tables and possibly other
stuff like initrd location if not passed on the command line). That
makes the very early logic in the kernel much simpler, and it gives us
an extensible format that should limit headaches in future.

So if booted with ACPI we _might_ have a restricted chosen-only dtb,
which _might_ be passed to the kernel explicitly by the user.

Thanks,
Mark.
