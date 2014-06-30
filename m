Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaF3KrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:47:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31951 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752486AbaF3KrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:47:09 -0400
Date: Mon, 30 Jun 2014 11:46:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 13/13] ARM64 / ACPI: Enable ARM64 in Kconfig
Message-ID: <20140630104652.GG28951@arm.com>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
 <1403840976-7456-14-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403840976-7456-14-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:49:36AM +0100, Hanjun Guo wrote:
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 7de5e3f..33d6dbb 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -8,10 +8,10 @@ config ACPI_SCAN_BIOS_NOT_EFI
>  menuconfig ACPI
>  	bool "ACPI (Advanced Configuration and Power Interface) Support"
>  	depends on !IA64_HP_SIM
> -	depends on IA64 || X86
> +	depends on IA64 || X86 || ARM64

I still don't understand what the point of enabling ACPI for arm64
during this series is. Do you get any working arm64 functionality
(on hardware or model) without subsequent patches? If it's just for
compilation reasons, the best we could do is depending on (ARM64 &&
COMPILE_TEST) but even though I would not merge this patch until we have
most of the arm64 required features in place (some of which are
introduced by the upcoming ACPI version).

>  	depends on PCI
>  	select PNP
> -	default y
> +	default y if !ARM64

For the benefit of single Image, I think you can default to y here.

-- 
Catalin
