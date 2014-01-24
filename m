Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaAXU5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:57:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaAXU5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:57:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH 09/20] ARM64 / ACPI: Implement core functions for parsing MADT table
Date: Fri, 24 Jan 2014 21:57:15 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Charles Garcia-Tobin" <Charles.Garcia-Tobin@arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <52E15756.4060705@arm.com> <52E287EE.70407@linaro.org>
In-Reply-To: <52E287EE.70407@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401242157.15495.arnd@arndb.de>
X-Provags-ID: V02:K0:uoU/2hSLGgV1/S8C9uUzwNWhazEKWli5JCFRdNReA22
 Vx/q3Aj4Rhs3dL4ruUj0Ztvwg3YB8f823a2SZOWMWtSYadAgbS
 91GPNChM86C6ybnvoDAy0e3Dl9XI6HXaW1y28Z7V7eOt4JK67C
 3Y1L0qz3KTrysGl7k6d0TBwNnnnNTRR9/562KGSnncT9TZ8Hdk
 +Kchi2v8K3UzvgtwEPXU07JyQOlr2y30+szpRA7n4bgPXjFCRe
 JruySbwC9EgOEE1sS1pfipUxqMMGmwwL6tLLKJrP8gAZnO6CO9
 1GwQ/tasOi36M2WPqWEMPoMNvv9qp1sREqQZarKSE887aeW+t3
 fcfztN5som9xBdcMEdVk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014, Hanjun Guo wrote:
> >> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> >> index e108d9c..c335c6d 100644
> >> --- a/arch/arm64/include/asm/acpi.h
> >> +++ b/arch/arm64/include/asm/acpi.h
> >> @@ -83,6 +83,9 @@ void arch_fix_phys_package_id(int num, u32 slot);
> >>   extern int (*acpi_suspend_lowlevel)(void);
> >>   #define acpi_wakeup_address (0)
> >>   
> >> +#define MAX_GIC_CPU_INTERFACE 256
> > I'll bite. Where on Earth is this value coming from?
> 
> I just thought 256 is big enough for now :(
> Yes, should be a larger number for GICv3.

Could this just be set to NR_CPUS? That way it will be large enough for
any system you can actually run on.

	Arnd
