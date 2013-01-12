Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3ALWep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:34:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39126 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab3ALWeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:34:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 07/22] ACPI: Separate acpi_bus_trim to support two steps.
Date: Sat, 12 Jan 2013 23:40:32 +0100
Message-ID: <3028581.u7PNshx4kV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-8-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:34 PM Yinghai Lu wrote:
> Current all acpi_bus_trim callers have rmdevice to 1.
> that means it will remove all acpi devices.
> 
> When 0, is passed, it will keep the parent.
> 
> For root bus hotremove support, we need to have pci device to be
> removed before acpi devices.
> 
> So try to keep all acpi devices, and only stop drivers with them.
> 
> This change should be safe because all current callers all have 1 passed.

I'm not sure how the chanelog is related to the patch itself.

The patch modifies the behavior of acpi_bus_trim() to avoid removing all
devices (not just the start point) for rmdevice==0, which doesn't really change
the functionality, because all callers pass rmdevice=1 anyway.

Yes, we can make this change, but why is it necessary?

And why don't we remove the rmdevice argument from acpi_bus_trim() altogether?

Rafael


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/scan.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index e380345..db7664e 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1669,10 +1669,7 @@ int acpi_bus_trim(struct acpi_device *start, int rmdevice)
>  			child = parent;
>  			parent = parent->parent;
>  
> -			if (level == 0)
> -				err = acpi_bus_remove(child, rmdevice);
> -			else
> -				err = acpi_bus_remove(child, 1);
> +			err = acpi_bus_remove(child, rmdevice);
>  
>  			continue;
>  		}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
