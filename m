Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3IKMZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:25:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44766 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab3IKMZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:25:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuangzhi.li@intel.com, fei.li@intel.com
Subject: Re: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
Date: Wed, 11 Sep 2013 14:36:31 +0200
Message-ID: <37297227.So9eVdeflb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378921377.26153.26.camel@cliu38-desktop-build>
References: <1378921377.26153.26.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 01:42:57 AM Chuansheng Liu wrote:
> 
> Currently the acpi_os_sleep() is using the schedule_timeout_interruptible(),
> which can be interrupted by signal, which causes the real sleep time is shorter.
> 
> According to the ACPI spec:
> The Sleep term is used to implement long-term timing requirements.
> Execution is delayed for at least the required number of milliseconds.
> 
> The sleeping time should be at least of the required number msecs, here
> using msleep() to implement it.
> 
> Also if the real time is shorter, we meet the device POWER ON issue.

What exactly is the "power on" issue?

Rafael


> CC: lizhuangzhi <zhuangzhi.li@intel.com>
> CC: Li Fei <fei.li@intel.com>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/acpi/osl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e5f416c..b1629b5 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -820,7 +820,7 @@ acpi_status acpi_os_remove_interrupt_handler(u32 irq, acpi_osd_handler handler)
>  
>  void acpi_os_sleep(u64 ms)
>  {
> -	schedule_timeout_interruptible(msecs_to_jiffies(ms));
> +	msleep(ms);
>  }
>  
>  void acpi_os_stall(u32 us)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
