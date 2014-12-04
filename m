Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaLDSUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:20:51 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44865 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaLDSUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:20:50 -0500
Date: Thu, 4 Dec 2014 18:20:49 +0000
From: Will Deacon <will.deacon@arm.com>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Message-ID: <20141204182049.GB7749@arm.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417707993-82290-1-git-send-email-agraf@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:46:33PM +0000, Alexander Graf wrote:
> With binutils 2.25 the default alignment for 32bit arm sections changed to
> have everything 64k aligned. Armv7 binaries built with this binutils version
> run successfully on an arm64 system.
> 
> Since effectively there is now the chance to run armv7 code on arm64 even
> with 64k page size, it doesn't make sense to block people from enabling
> CONFIG_COMPAT on those configurations.

Is there a distro available that is built with a recent enough binutils for
this? I'd really like to run our regression tests to check that page-size
assumptions don't exist for things like shm.

Will

> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> ---
>  arch/arm64/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9532f8d..3cf4f238 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
>  
>  config COMPAT
>  	bool "Kernel support for 32-bit EL0"
> -	depends on !ARM64_64K_PAGES
>  	select COMPAT_BINFMT_ELF
>  	select HAVE_UID16
>  	select OLD_SIGSUSPEND3
> -- 
> 1.7.12.4
> 
> 
