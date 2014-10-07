Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbaJGXXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:23:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61970 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932653AbaJGXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:23:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, adi-buildroot-devel@lists.sourceforge.net,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-am33-list@redhat.com,
        linux-cris-kernel@axis.com, linux-efi@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 44/44] kernel: Remove pm_power_off
Date: Wed, 08 Oct 2014 01:43:07 +0200
Message-ID: <1469166.g4FqVc5SJX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412659726-29957-45-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-45-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 06, 2014 10:28:46 PM Guenter Roeck wrote:
> No users of pm_power_off are left, so it is safe to remove the function.
> 
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

ACK

> ---
>  include/linux/pm.h              |  1 -
>  kernel/power/poweroff_handler.c | 10 +---------
>  2 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 45271b5..fce7645 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -31,7 +31,6 @@
>  /*
>   * Callbacks for platform drivers to implement.
>   */
> -extern void (*pm_power_off)(void);
>  extern void (*pm_power_off_prepare)(void);
>  
>  /*
> diff --git a/kernel/power/poweroff_handler.c b/kernel/power/poweroff_handler.c
> index 96f59ef..01a3a39 100644
> --- a/kernel/power/poweroff_handler.c
> +++ b/kernel/power/poweroff_handler.c
> @@ -20,12 +20,6 @@
>  #include <linux/types.h>
>  
>  /*
> - * If set, calling this function will power off the system immediately.
> - */
> -void (*pm_power_off)(void);
> -EXPORT_SYMBOL(pm_power_off);
> -
> -/*
>   *	Notifier list for kernel code which wants to be called
>   *	to power off the system.
>   */
> @@ -163,8 +157,6 @@ int register_poweroff_handler_simple(void (*handler)(void), int priority)
>   */
>  void do_kernel_poweroff(void)
>  {
> -	if (pm_power_off)
> -		pm_power_off();
>  	atomic_notifier_call_chain(&poweroff_handler_list, 0, NULL);
>  }
>  
> @@ -175,6 +167,6 @@ void do_kernel_poweroff(void)
>   */
>  bool have_kernel_poweroff(void)
>  {
> -	return pm_power_off != NULL || poweroff_handler_list.head != NULL;
> +	return poweroff_handler_list.head != NULL;
>  }
>  EXPORT_SYMBOL(have_kernel_poweroff);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
