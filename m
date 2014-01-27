Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaA0JTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:19:44 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34235 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaA0JTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:19:41 -0500
MIME-Version: 1.0
In-Reply-To: <1390804498-30311-1-git-send-email-jiang.liu@linux.intel.com>
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com>
	<1390804498-30311-1-git-send-email-jiang.liu@linux.intel.com>
Date: Mon, 27 Jan 2014 10:19:41 +0100
Message-ID: <CADDKRnDZPpUgbRN6tJeXBAC9=M+5HN57ArL9yYA237ELkKMvCg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: reduce log level for message "ACPI: \_PR_.CPU4:
 failed to get CPU APIC ID"
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-27 Jiang Liu <jiang.liu@linux.intel.com>:
> Commit b981513f806d (ACPI / scan: bail out early if failed to parse
> APIC ID for CPU) emits an error message if ACPI processor driver fails
> to query APIC ID for the CPU.
>
> Originally it's designed to catch BIOS bugs for CPU hot-addition. But
> it accidently reveals another type of BIOS bug that:
> 1) BIOS implements ACPI objects for all possible instead of present
>    CPUs. (It's legal per ACPI specification.)
> 2) BIOS doesn't implement _STA method for CPU objects. OSPM assumes
>    that all CPU objects are present and functioning and binds ACPI
>    processor driver to those CPU objects, which then triggers the error
>    message. According to ACPI spec, BIOS should implement _STA method
>    for those absent CPUs at least.
>
> Though it's a BIOS bug in essential, there are some BIOSes in the fields
> which are implmented in this way. So reduce the log level from ERR to
> DEBUG to accommodate these existing BIOSes.
>
> Fixes: b981513f806d (ACPI / scan: bail out early if failed to parse APIC ID for CPU)
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/acpi_processor.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index c9311be..c29c2c3 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -261,7 +261,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>
>         apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
>         if (apic_id < 0) {
> -               acpi_handle_err(pr->handle, "failed to get CPU APIC ID.\n");
> +               acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
>                 return -ENODEV;
>         }
>         pr->apic_id = apic_id;
> --
> 1.7.10.4
>

Thanks, the patch works for me.

Jörg
