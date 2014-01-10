Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaAJUkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:40:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58506 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860AbaAJUkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:40:31 -0500
Message-ID: <52D05ABD.30904@codeaurora.org>
Date: Fri, 10 Jan 2014 12:40:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
References: <1389325833-16535-1-git-send-email-msalter@redhat.com> <1389325833-16535-5-git-send-email-msalter@redhat.com>
In-Reply-To: <1389325833-16535-5-git-send-email-msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some minor nitpicks

On 01/09/14 19:50, Mark Salter wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c1f1a7e..78a79a6a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1842,6 +1842,17 @@ config UACCESS_WITH_MEMCPY
>  	  However, if the CPU data cache is using a write-allocate mode,
>  	  this option is unlikely to provide any performance gain.
>  
> +config EARLY_IOREMAP
> +	depends on MMU
> +	bool "Provide early_ioremap() support for kernel initialization."

Please drop the full stop.

> +	select GENERIC_EARLY_IOREMAP
> +	help
> +	  Provide a mechanism for kernel initialisation code to temporarily
> +	  map, in a highmem-agnostic way, memory pages in before ioremap()
> +	  and friends are available (before paging_init() has run). It uses
> +	  the same virtual memory range as kmap so all early mappings must
> +	  be unapped before paging_init() is called.

s/unapped/unmapped/

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

