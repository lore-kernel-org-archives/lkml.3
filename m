Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377Ab3E2SuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:50:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28269 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965561Ab3E2SuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:50:15 -0400
Message-ID: <1369853414.16819.56.camel@misato.fc.hp.com>
Subject: Re: possible_cpus broken in linux-next
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Date: Wed, 29 May 2013 12:50:14 -0600
In-Reply-To: <1369852557.16819.54.camel@misato.fc.hp.com>
References: <51A6367E.1060400@intel.com>
	 <1369852557.16819.54.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 12:35 -0600, Toshi Kani wrote:
> On Wed, 2013-05-29 at 10:10 -0700, Dave Hansen wrote:

 :

> Thanks for the report.  The following patch fixes the problem.
> -Toshi
> 
> ====
> From: Toshi Kani <toshi.kani@hp.com>
> Subject: [PATCH] ACPI: Fix sysfs cpu/online of offlined cpus

Typo. The subject needs to be:

Subject: [PATCH] cpu: Fix sysfs cpu/online of offlined cpus

-Toshi

> As reported by Dave Hansen, sysfs cpu/online shows 1 for
> offlined cpus at boot.
> https://lkml.org/lkml/2013/5/29/403
> 
> Fix this problem by initializing dev.offline with cpu_online()
> when registering a cpu.
> 
> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/base/cpu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 130ba0b..b9f0eec 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -281,6 +281,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>  	cpu->dev.bus = &cpu_subsys;
>  	cpu->dev.release = cpu_device_release;
>  	cpu->dev.offline_disabled = !cpu->hotpluggable;
> +	cpu->dev.offline = !cpu_online(num);
>  #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
>  	cpu->dev.bus->uevent = arch_cpu_uevent;
>  #endif


