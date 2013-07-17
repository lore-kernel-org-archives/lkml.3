Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3GQTUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:20:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51268 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014Ab3GQTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:20:30 -0400
Date: Wed, 17 Jul 2013 20:20:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Robin Holt <holt@sgi.com>,
        Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCH] arm64: use common reboot infrastructure
Message-ID: <20130717192004.GD16496@MacBook-Pro.local>
References: <1373541180-7452-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373541180-7452-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:13:00PM +0100, Marc Zyngier wrote:
> Commit 7b6d864b48d9 (reboot: arm: change reboot_mode to use enum
> reboot_mode) changed the way reboot is handled on arm, which has a
> direct impact on arm64 as we share the reset driver on the VE platform.
> 
> The obvious fix is to move arm64 to use the same infrastructure.
> 
> Cc: Robin Holt <holt@sgi.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

I just did the same before I saw your patch. Anyway, I'll take yours as
you did it first ;)

> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -25,7 +25,7 @@ int C_A_D = 1;
>  struct pid *cad_pid;
>  EXPORT_SYMBOL(cad_pid);
>  
> -#if defined(CONFIG_ARM) || defined(CONFIG_UNICORE32)
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_UNICORE32)
>  #define DEFAULT_REBOOT_MODE		= REBOOT_HARD
>  #else
>  #define DEFAULT_REBOOT_MODE

Do we need this or we could use the default (I think REBOOT_COLD is 0)?

-- 
Catalin
