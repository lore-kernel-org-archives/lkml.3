Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaGaVBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:01:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54891 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751120AbaGaVBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:01:31 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: Re: [PATCH] ACPI/Processor: Add CPU_STARTING_FROZEN check in the acpi_cpu_soft_notify()
Date: Thu, 31 Jul 2014 23:20:04 +0200
Message-ID: <1560513.OlLhy0HTTU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406798426-16483-1-git-send-email-tianyu.lan@intel.com>
References: <1406798426-16483-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 05:20:26 PM Lan Tianyu wrote:
> The callback of CPU_STARTING event can't sleep and so acpi_cpu_soft_notify()
> return directly when CPU_STARTING event is triggered. But cpu hotplug also
> happens during S2RAM. The action will become CPU_STARTING_FROZEN. This
> patch is to fix missing check the frozen event.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

There is work to restructure the handling of CPU_TASKS_FROZEN under way
and Chen Gong is driving it.  That's likely to conflict with the last
two patches from you.  Can you pleaes coordinate with Gong?

Rafael


> ---
>  drivers/acpi/processor_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 4fcbd67..66e2249 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -125,7 +125,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>  	 * CPU_STARTING and CPU_DYING must not sleep. Return here since
>  	 * acpi_bus_get_device() may sleep.
>  	 */
> -	if (action == CPU_STARTING || action == CPU_DYING)
> +	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING || action == CPU_DYING)
>  		return NOTIFY_DONE;
>  
>  	if (!pr || acpi_bus_get_device(pr->handle, &device))
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
