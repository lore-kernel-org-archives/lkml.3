Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaEHGaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:30:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:58831 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaEHGaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:30:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1009,1389772800"; 
   d="scan'208";a="508175454"
Date: Thu, 8 May 2014 14:28:57 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/2] x86, hpet: Make boot_hpet_disable extern
Message-ID: <20140508062857.GA1065@feng-snb>
References: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping for comments for these 2 patches. Thanks!

- Feng

On Thu, Apr 24, 2014 at 04:18:17PM +0800, Feng Tang wrote:
> HPET on some platform has accuracy problem. Making
> "boot_hpet_disable" extern so that we can runtime disable
> the HPET timer by using quirk to check the platform.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  arch/x86/include/asm/hpet.h |    1 +
>  arch/x86/kernel/hpet.c      |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
> index b18df57..36f7125 100644
> --- a/arch/x86/include/asm/hpet.h
> +++ b/arch/x86/include/asm/hpet.h
> @@ -63,6 +63,7 @@
>  /* hpet memory map physical address */
>  extern unsigned long hpet_address;
>  extern unsigned long force_hpet_address;
> +extern int boot_hpet_disable;
>  extern u8 hpet_blockid;
>  extern int hpet_force_user;
>  extern u8 hpet_msi_disable;
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 8d80ae0..4177bfb 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -88,7 +88,7 @@ static inline void hpet_clear_mapping(void)
>  /*
>   * HPET command line enable / disable
>   */
> -static int boot_hpet_disable;
> +int boot_hpet_disable;
>  int hpet_force_user;
>  static int hpet_verbose;
>  
> -- 
> 1.7.9.5
