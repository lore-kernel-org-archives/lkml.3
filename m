Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3J1GNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:13:05 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48143 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3J1GND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <1382857012-2971-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382857012-2971-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Mon, 28 Oct 2013 14:13:01 +0800
Message-ID: <CAOLK0pxe0tsgo1+U8WT4-9cxTxS9MKaiGhLd2S-T-T7imPyd7A@mail.gmail.com>
Subject: Re: [PATCH] ACPI: remove unused ACPI_PROCFS Kconfig param
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Len Brown <lenb@kernel.org>, rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/27 Michael Opdenacker <michael.opdenacker@free-electrons.com>:
> This patch removes the ACPI_PROCFS parameter
> (support for legacy /proc/acpi), which is defined
> but no longer used anywhere in the makefiles and source code.
>

I think this should be not removed now. Since there are still interfaces
under /proc/acpi (E.G, /proc/acpi/wakeup and /proc/acpi/lid/*).

The origin commit which introduces the kconfig is to make some
interfaces that have backup interfaces in the sysfs configurable before
removing them actually.

So we still need this kconfig when try to remove remaining /proc/acpi
interfaces.

commit b981c591891dc8885de36498d38fa8d8a5481069
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jan 29 11:02:30 2007 +0800

    ACPI: add a Kconfig option for ACPI procfs interface

    Add a kconfig option CONFIG_ACPI_PROCFS to make procfs interface
    a configurable attribute of ACPI.

    No procfs interface is actually deprecated,
    and no sysfs interface is added in this patch.

    CONGI_ACPI_PROCFS is used to mark procfs interface as deprecated
    once the same function is duplicated in sysfs.


> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/acpi/Kconfig | 13 -------------
>  1 file changed, 13 deletions(-)
>
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 6efe2ac..201cfb7 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -43,19 +43,6 @@ config ACPI_SLEEP
>         depends on SUSPEND || HIBERNATION
>         default y
>
> -config ACPI_PROCFS
> -       bool "Deprecated /proc/acpi files"
> -       depends on PROC_FS
> -       help
> -         For backwards compatibility, this option allows
> -         deprecated /proc/acpi/ files to exist, even when
> -         they have been replaced by functions in /sys.
> -
> -         This option has no effect on /proc/acpi/ files
> -         and functions which do not yet exist in /sys.
> -
> -         Say N to delete /proc/acpi/ files that have moved to /sys/
> -
>  config ACPI_PROCFS_POWER
>         bool "Deprecated power /proc/acpi directories"
>         depends on PROC_FS
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
