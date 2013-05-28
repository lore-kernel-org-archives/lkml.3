Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab3E1XVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:21:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53667 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227Ab3E1XVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:21:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
Date: Wed, 29 May 2013 01:30:24 +0200
Message-ID: <1693841.iH9OWSxHyo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519E0F2A.4070602@linaro.org>
References: <519E0F2A.4070602@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
> although the chances are small, I think it should be fixed.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

This patch isn't necessary any more after the changes queued up for 3.11
in the acpi-hotplug branch of the linux-pm.git tree.

Thanks,
Rafael


> ---
>  drivers/acpi/processor_driver.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index bec717f..dd64f23 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -579,6 +579,10 @@ static int __cpuinit acpi_processor_add(struct acpi_device
> *device)
>         per_cpu(processors, pr->id) = pr;
> 
>         dev = get_cpu_device(pr->id);
> +       if (!dev) {
> +               result = -ENODEV;
> +               goto err_clear_processor;
> +       }
>         if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
>                 result = -EFAULT;
>                 goto err_clear_processor;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
