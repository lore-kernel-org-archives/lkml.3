Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3IGAEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:04:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37399 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3IGAEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:04:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, yinghai@kernel.org, bhelgaas@google.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] ACPI/Resource: Add address translation support
Date: Sat, 07 Sep 2013 02:15:05 +0200
Message-ID: <12539726.iB4h1i35EF@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378477486-8758-3-git-send-email-tianyu.lan@intel.com>
References: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com> <1378477486-8758-3-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 10:24:44 AM Lan Tianyu wrote:
> According ACPI 5.0 spec Section 19.1.8
> "For bridges, translate addresses across the bridge, this is the
> offset that must be added to the address on the secondary side
> to obtain the address on the primary side. Non-bridge devices
> must list 0."

Can you please have a look into the previous versions of the spec and double
check that this change won't confuse systems that implement them?

Otherwise it looks OK to me.

Thanks,
Rafael


> This patch is to add address translation offset to the start/end
> of struct resource in the acpi_dev_resource_address_space().
> Further more, non-bridge device's translation_offset should 0.
> So this change will affect other devices.
> 
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/resource.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 929f416..84bc3db 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -192,8 +192,8 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>  	if (ACPI_FAILURE(status))
>  		return true;
>  
> -	res->start = addr.minimum;
> -	res->end = addr.maximum;
> +	res->start = addr.minimum + addr.translation_offset;
> +	res->end = addr.maximum + addr.translation_offset;
>  	window = addr.producer_consumer == ACPI_PRODUCER;
>  
>  	switch(addr.resource_type) {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
