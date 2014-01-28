Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaA1ASV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:18:21 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51873 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaA1AST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:18:19 -0500
Date: Mon, 27 Jan 2014 16:18:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Jorg Otte <jrg.otte@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: reduce log level for message "ACPI: \_PR_.CPU4:
 failed to get CPU APIC ID"
In-Reply-To: <1390804498-30311-1-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1401271615580.17114@chino.kir.corp.google.com>
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com> <1390804498-30311-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Jiang Liu wrote:

> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index c9311be..c29c2c3 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -261,7 +261,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>  
>  	apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
>  	if (apic_id < 0) {
> -		acpi_handle_err(pr->handle, "failed to get CPU APIC ID.\n");
> +		acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
>  		return -ENODEV;
>  	}

Don't we already leave some artifact in the kernel log at boot about apic 
ids that don't get registered?  I'm wondering if we should have this 
warning at all.
