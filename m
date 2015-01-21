Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbbAUAMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:12:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56847 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751665AbbAUAMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:12:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 08/19] ACPI: Add prefetch decoding to the address space parser
Date: Wed, 21 Jan 2015 01:35:13 +0100
Message-ID: <1593565.fJ4zH7YgDd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420684386-5975-9-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-9-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 10:32:55 AM Jiang Liu wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Add support of PREFETCH attributre to ACPI address space and extended
> address space parser.

This potentially enables untested configurations which tends to uncover bugs,
so I'm concerned.

What's the possible impact of this?

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/resource.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index a56a64164410..abe3a29ad802 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -200,6 +200,9 @@ static bool acpi_decode_space(struct resource *res,
>  	if (base->producer_consumer == ACPI_PRODUCER)
>  		res->flags |= IORESOURCE_WINDOW;
>  
> +	if (base->info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> +		res->flags |= IORESOURCE_PREFETCH;
> +
>  	return !(res->flags & IORESOURCE_DISABLED);
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
