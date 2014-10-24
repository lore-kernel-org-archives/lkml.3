Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaJXJrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:47:13 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:1749 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaJXJrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:47:09 -0400
Message-ID: <544A2017.7020804@imgtec.com>
Date: Fri, 24 Oct 2014 10:47:03 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>
CC: <linux-pm@vger.kernel.org>, <adi-buildroot-devel@lists.sourceforge.net>,
        <linux390@de.ibm.com>, <linux-alpha@vger.kernel.org>,
        <linux-am33-list@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-c6x-dev@linux-c6x.org>, <linux-cris-kernel@axis.com>,
        <linux-hexagon@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <linux@openrisc.net>, <linux-m68k@vger.kernel.org>,
        <linux-metag@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-parisc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-xtensa@linux-xtensa.org>, <sparclinux@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <user-mode-linux-user@lists.sourceforge.net>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v2 08/47] kernel: Move pm_power_off to common code
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-9-git-send-email-linux@roeck-us.net>
In-Reply-To: <1413864783-3271-9-git-send-email-linux@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On 21/10/14 05:12, Guenter Roeck wrote:
> pm_power_off is defined for all architectures. Move it to common code.
> 
> Have all architectures call do_kernel_power_off instead of pm_power_off.
> Some architectures point pm_power_off to machine_power_off. For those,
> call do_kernel_power_off from machine_power_off instead.
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Hirokazu Takata <takata@linux-m32r.org>
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
> Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
> Acked-by: Richard Weinberger <richard@nod.at>
> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

For metag:
Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
> index 483dff9..8d95773 100644
> --- a/arch/metag/kernel/process.c
> +++ b/arch/metag/kernel/process.c
> @@ -67,9 +67,6 @@ void arch_cpu_idle_dead(void)
>  }
>  #endif
>  
> -void (*pm_power_off)(void);
> -EXPORT_SYMBOL(pm_power_off);
> -
>  void (*soc_restart)(char *cmd);
>  void (*soc_halt)(void);
>  
> @@ -90,8 +87,7 @@ void machine_halt(void)
>  
>  void machine_power_off(void)
>  {
> -	if (pm_power_off)
> -		pm_power_off();
> +	do_kernel_power_off();
>  	smp_send_stop();
>  	hard_processor_halt(HALT_OK);
>  }
