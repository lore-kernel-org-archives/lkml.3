Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3BSIFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:05:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50300 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3BSIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:05:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51233235.5040002@jp.fujitsu.com>
Date: Tue, 19 Feb 2013 17:05:09 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 4/7] ACPI / scan: Introduce acpi_scan_handler_matching()
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <18167652.ZolVinXqGN@vostro.rjw.lan>
In-Reply-To: <18167652.ZolVinXqGN@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/18 0:23, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Introduce new helper routine acpi_scan_handler_matching() for
> checking if the given ACPI scan handler matches a given device ID
> and rework acpi_scan_match_handler() to use the new routine (that
> routine will also be useful for other purposes in the future).
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/acpi/scan.c |   30 ++++++++++++++++++++----------
>   1 file changed, 20 insertions(+), 10 deletions(-)
>
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -1658,22 +1658,32 @@ static int acpi_bus_type_and_status(acpi
>   	return 0;
>   }
>
> +static bool acpi_scan_handler_matching(struct acpi_scan_handler *handler,
> +				       char *idstr,
> +				       const struct acpi_device_id **matchid)
> +{
> +	const struct acpi_device_id *devid;
> +
> +	for (devid = handler->ids; devid->id[0]; devid++)
> +		if (!strcmp((char *)devid->id, idstr)) {
> +			if (matchid)
> +				*matchid = devid;
> +
> +			return true;
> +		}
> +
> +	return false;
> +}
> +
>   static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
>   					const struct acpi_device_id **matchid)
>   {
>   	struct acpi_scan_handler *handler;
>
> -	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
> -		const struct acpi_device_id *devid;
> +	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node)
> +		if (acpi_scan_handler_matching(handler, idstr, matchid))
> +			return handler;
>
> -		for (devid = handler->ids; devid->id[0]; devid++)
> -			if (!strcmp((char *)devid->id, idstr)) {
> -				if (matchid)
> -					*matchid = devid;
> -
> -				return handler;
> -			}
> -	}
>   	return NULL;
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


