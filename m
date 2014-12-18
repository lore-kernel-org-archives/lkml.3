Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaLRJR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:17:27 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:60489 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaLRJRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:17:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, rjw@rjwysocki.net,
        lenb@kernel.org, hdegoede@redhat.com, tj@kernel.org,
        mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [Linaro-acpi] [RFC PATCH 2/2] ata: ahci_platform: Add ACPI _CLS matching
Date: Thu, 18 Dec 2014 10:17 +0100
Message-ID: <3408260.hhf4YMy6F6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418858195-22857-3-git-send-email-suravee.suthikulpanit@amd.com>
References: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com> <1418858195-22857-3-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:QjMk+7RWB8NDY27o2x9Yvw2rmPR8hCvW2TkauQ7vfoO3A4VqbAY
 cxJz+FImTivzKRI5Oi/tboYssWcE8Vqyzo4NL5I/CpZovUy4wFaRJSLfR27OfUx5QhlUAP7
 bUFU5J4fmHMLxcsEaM6qC15ZEqzXhVYTpwxlQdoSB5WHtOrE9BfTtfzfqi01NqOUFdQYtj4
 IoTaBJMtjfV44+BryzGdA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 17:16:35 Suravee Suthikulpanit wrote:
> +#ifdef CONFIG_ATA_ACPI
> +#include <linux/acpi.h>
> +#endif
>  #include "ahci.h"
>  
>  static const struct ata_port_info ahci_port_info = {
> @@ -71,6 +74,10 @@ static const struct of_device_id ahci_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);
>  
> +#ifdef CONFIG_ATA_ACPI
> +static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
> +#endif
> +
>  static struct platform_driver ahci_driver = {
>         .probe = ahci_probe,
>         .remove = ata_platform_remove_one,
> @@ -78,6 +85,9 @@ static struct platform_driver ahci_driver = {
>                 .name = "ahci",
>                 .owner = THIS_MODULE,
>                 .of_match_table = ahci_of_match,
> +#ifdef CONFIG_ATA_ACPI
> +               .acpi_cls = &ahci_cls,
> +#endif
>                 .pm = &ahci_pm_ops,
> 

It would be better to leave out the various #ifdef here, in particular the
one around the header file inclusion.

	Arnd
