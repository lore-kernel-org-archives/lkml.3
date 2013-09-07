Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3IGABF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:01:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37393 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3IGABD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, yinghai@kernel.org, bhelgaas@google.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] ACPI/Resource: Add memory prefetch check support
Date: Sat, 07 Sep 2013 02:11:58 +0200
Message-ID: <30641406.PKxpUfsNWU@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378477486-8758-2-git-send-email-tianyu.lan@intel.com>
References: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com> <1378477486-8758-2-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 10:24:43 AM Lan Tianyu wrote:
> This patch is to check mem address space's acpi resource caching ability
> and set prefetch flag of struct resource if it's prefetchable.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Looks good to me.

Thanks,
Rafael


> ---
>  drivers/acpi/resource.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index b7201fc..929f416 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -202,6 +202,9 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>  		res->flags = acpi_dev_memresource_flags(len,
>  						addr.info.mem.write_protect,
>  						window);
> +
> +		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> +			res->flags |= IORESOURCE_PREFETCH;
>  		break;
>  	case ACPI_IO_RANGE:
>  		io_decode = addr.granularity == 0xfff ?
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
