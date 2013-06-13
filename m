Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3FMSUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:20:47 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36356 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3FMSUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:20:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [BUGFIX 6/9] ACPI, DOCK: mark initialization functions with __init
Date: Thu, 13 Jun 2013 20:29:59 +0200
Message-ID: <4725934.hjsbtR4hAr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371141152-9468-7-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <1371141152-9468-7-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 12:32:29 AM Jiang Liu wrote:
> Mark all initialization functions with __init to reduce memory
> consumption at runtime.

Again, this is a *cleanup*, not a fix.  Please don't mix cleanups with fixes,
especially with ones you want to go into 3.10, because the cleanups aren't
3.10 material for sure.

Thanks,
Rafael


> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Shaohua Li <shaohua.li@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/acpi/dock.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index cd2d5df..da3314d 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -94,7 +94,7 @@ struct dock_dependent_device {
>   *
>   * Add the dependent device to the dock's dependent device list.
>   */
> -static int
> +static int __init
>  add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
>  {
>  	struct dock_dependent_device *dd;
> @@ -192,7 +192,7 @@ static int is_dock(acpi_handle handle)
>  	return 1;
>  }
>  
> -static int is_ejectable(acpi_handle handle)
> +static int __init is_ejectable(acpi_handle handle)
>  {
>  	acpi_status status;
>  	acpi_handle tmp;
> @@ -203,7 +203,7 @@ static int is_ejectable(acpi_handle handle)
>  	return 1;
>  }
>  
> -static int is_ata(acpi_handle handle)
> +static int __init is_ata(acpi_handle handle)
>  {
>  	acpi_handle tmp;
>  
> @@ -216,7 +216,7 @@ static int is_ata(acpi_handle handle)
>  	return 0;
>  }
>  
> -static int is_battery(acpi_handle handle)
> +static int __init is_battery(acpi_handle handle)
>  {
>  	struct acpi_device_info *info;
>  	int ret = 1;
> @@ -232,7 +232,7 @@ static int is_battery(acpi_handle handle)
>  	return ret;
>  }
>  
> -static int is_ejectable_bay(acpi_handle handle)
> +static int __init is_ejectable_bay(acpi_handle handle)
>  {
>  	acpi_handle phandle;
>  
> @@ -809,7 +809,7 @@ static struct notifier_block dock_acpi_notifier = {
>   * check to see if an object has an _EJD method.  If it does, then it
>   * will see if it is dependent on the dock station.
>   */
> -static acpi_status
> +static acpi_status __init
>  find_dock_devices(acpi_handle handle, u32 lvl, void *context, void **rv)
>  {
>  	acpi_status status;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
