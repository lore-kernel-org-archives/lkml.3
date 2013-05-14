Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab3ENUTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:19:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46827 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab3ENUTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:19:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH v2, part 2 12/18] PCI, ACPI: use hotplug-safe iterators to walk PCI buses
Date: Tue, 14 May 2013 22:28:11 +0200
Message-ID: <4477970.CvMHDHr0Cv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1368550322-1045-12-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com> <1368550322-1045-12-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 15, 2013 12:51:56 AM Jiang Liu wrote:
> Enhance ACPI reset drvier to use hotplug-safe iterators to walk PCI buses.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/reboot.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
> index a6c77e8b..532dd6d 100644
> --- a/drivers/acpi/reboot.c
> +++ b/drivers/acpi/reboot.c
> @@ -33,7 +33,7 @@ void acpi_reboot(void)
>  	switch (rr->space_id) {
>  	case ACPI_ADR_SPACE_PCI_CONFIG:
>  		/* The reset register can only live on bus 0. */
> -		bus0 = pci_find_bus(0, 0);
> +		bus0 = pci_get_bus(0, 0);
>  		if (!bus0)
>  			return;
>  		/* Form PCI device/function pair. */
> @@ -43,6 +43,7 @@ void acpi_reboot(void)
>  		/* Write the value that resets us. */
>  		pci_bus_write_config_byte(bus0, devfn,
>  				(rr->address & 0xffff), reset_value);
> +		pci_bus_put(bus0);
>  		break;
>  
>  	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
