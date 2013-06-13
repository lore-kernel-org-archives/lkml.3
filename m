Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3FMSSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:18:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36334 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab3FMSSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:18:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [BUGFIX 4/9] ACPI, DOCK: avoid initializing acpi_dock_notifier_list multiple times
Date: Thu, 13 Jun 2013 20:27:48 +0200
Message-ID: <5386268.Rav0V0b5qK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371141152-9468-5-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <1371141152-9468-5-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 12:32:27 AM Jiang Liu wrote:
> Initialize acpi_dock_notifier_list from function acpi_dock_init()
> instead of dock_add() to avoid initializing it multiple times.

Well, makes sense.

Thanks,
Rafael


> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Shaohua Li <shaohua.li@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/acpi/dock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 50e38b7..8e578aa 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -967,7 +967,6 @@ static int __init dock_add(acpi_handle handle)
>  	spin_lock_init(&dock_station->dd_lock);
>  	INIT_LIST_HEAD(&dock_station->sibling);
>  	INIT_LIST_HEAD(&dock_station->hotplug_devices);
> -	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
>  	INIT_LIST_HEAD(&dock_station->dependent_devices);
>  
>  	/* we want the dock device to send uevents */
> @@ -1038,6 +1037,7 @@ int __init acpi_dock_init(void)
>  		return 0;
>  	}
>  
> +	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
>  	register_acpi_bus_notifier(&dock_acpi_notifier);
>  	pr_info(PREFIX "%s: %d docks/bays found\n",
>  		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
