Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHTOlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:41:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50923 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750942AbaHTOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:41:12 -0400
Date: Wed, 20 Aug 2014 15:38:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v2 06/18] ARM64 / ACPI: Parse MADT to map logical cpu to
 MPIDR and get cpu_possible/present_map
Message-ID: <20140820143817.GN24600@localhost>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
 <1407166105-17675-7-git-send-email-hanjun.guo@linaro.org>
 <20140818142728.GS20043@localhost>
 <53F2FE8E.60307@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F2FE8E.60307@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:36:46AM +0100, Hanjun Guo wrote:
> On 2014-8-18 22:27, Catalin Marinas wrote:
> > On Mon, Aug 04, 2014 at 04:28:13PM +0100, Hanjun Guo wrote:
> >> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> >> index 6e04868..e877967 100644
> >> --- a/arch/arm64/include/asm/acpi.h
> >> +++ b/arch/arm64/include/asm/acpi.h
> >> @@ -64,6 +64,8 @@ static inline void arch_fix_phys_package_id(int num, u32 slot) { }
> >>  extern int (*acpi_suspend_lowlevel)(void);
> >>  #define acpi_wakeup_address 0
> >>  
> >> +#define MAX_GIC_CPU_INTERFACE 65535
> > 
> > Does this need to be more than NR_CPUS?
> 
> Sometimes yes, CPU structure entries in MADT just like CPU nodes in
> device tree, the number of them may more than NR_CPUS.

I have a more general question here. In ACPI, is MADT the only way to
build a CPU topology? It looks weird that we use GIC properties to
create the cpu_logical_map(). A side-effect is that the GIC-related
functions are now scattered all over the kernel rather than being
contained in the GIC driver itself.

-- 
Catalin
