Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaGADLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 23:11:53 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:35586 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbaGADLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 23:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <1404184262-6178-1-git-send-email-xerofoify@gmail.com>
References: <1404184262-6178-1-git-send-email-xerofoify@gmail.com>
Date: Mon, 30 Jun 2014 23:11:51 -0400
Message-ID: <CAPDOMVhBv58nNdGyDPw3xsZ3AwpsnkQRGYvcAjL27mjOn5fiRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Deletes arch/arm/mach-gemini/idle.c
From: Nick Krause <xerofoify@gmail.com>
To: ulli.kroll@googlemail.com
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only one patch please disregard patch 1/2.
Cheers Nick

On Mon, Jun 30, 2014 at 11:11 PM, Nicholas Krause <xerofoify@gmail.com> wrote:
> This patch deletes the above file in order to remove the function
> in this file that may cause races. In addition this function is
> no longer needed due to commit 8182a34d85698 fixing this issue.
> Therefore gemmi_idle is no longer needed and due to in being the
> only function in this file I am removing it.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/arm/mach-gemini/idle.c | 30 ------------------------------
>  1 file changed, 30 deletions(-)
>  delete mode 100644 arch/arm/mach-gemini/idle.c
>
> diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
> deleted file mode 100644
> index 2880f5a..0000000
> --- a/arch/arm/mach-gemini/idle.c
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -/*
> - * arch/arm/mach-gemini/idle.c
> - */
> -
> -#include <linux/init.h>
> -#include <asm/system_misc.h>
> -#include <asm/proc-fns.h>
> -
> -static void gemini_idle(void)
> -{
> -       /*
> -        * Because of broken hardware we have to enable interrupts or the CPU
> -        * will never wakeup... Acctualy it is not very good to enable
> -        * interrupts first since scheduler can miss a tick, but there is
> -        * no other way around this. Platforms that needs it for power saving
> -        * should enable it in init code, since by default it is
> -        * disabled.
> -        */
> -
> -       local_irq_disable();
> -       cpu_do_idle();
> -}
> -
> -static int __init gemini_idle_init(void)
> -{
> -       arm_pm_idle = gemini_idle;
> -       return 0;
> -}
> -
> -arch_initcall(gemini_idle_init);
> --
> 1.9.1
>
