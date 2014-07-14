Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaGNOW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:22:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:22437 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755236AbaGNOWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:22:48 -0400
Date: Mon, 14 Jul 2014 15:22:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/7] arm/arm64: Unexport restart handlers
Message-ID: <20140714142232.GB1112@arm.com>
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
 <1405265431-4561-8-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405265431-4561-8-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 04:30:31PM +0100, Guenter Roeck wrote:
> Implementing a restart handler in a module don't make sense
> as there would be no guarantee that the module is loaded when
> a restart is needed. Unexport arm_pm_restart to ensure that
> no one gets the idea to do it anyway.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v4: No change
> v3: No change
> v2: No change
> 
>  arch/arm/kernel/process.c   | 1 -
>  arch/arm64/kernel/process.c | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 5d191e3..25c7f00 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -125,7 +125,6 @@ void (*pm_power_off)(void);
>  EXPORT_SYMBOL(pm_power_off);
>  
>  void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
> -EXPORT_SYMBOL_GPL(arm_pm_restart);

Unless I miss something, how is this different from registering a
restart notifier from a module (blocking_notifier_chain_register is
exported)?

-- 
Catalin
