Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3BHAvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:51:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38939 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3BHAvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:51:24 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51144BD4.7070804@jp.fujitsu.com>
Date: Fri, 8 Feb 2013 09:50:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <bhelgaas@google.com>, <mika.westerberg@linux.intel.com>,
        <matthew.garrett@nebula.com>, <yinghai@kernel.org>, <liuj97@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/02] ACPI: sysfs eject support for ACPI scan handlers
References: <1360191056-13293-1-git-send-email-toshi.kani@hp.com> <1360191056-13293-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1360191056-13293-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2013/02/07 7:50, Toshi Kani wrote:
> Changed sysfs eject, acpi_eject_store(), to support ACPI scan handlers.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>   drivers/acpi/scan.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index cfd7a69..3ff632e 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -203,7 +203,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
>   		return -EINVAL;
>   	}
>   #ifndef FORCE_EJECT

> -	if (acpi_device->driver == NULL) {
> +	if (!acpi_device->driver && !acpi_device->handler) {

I don't understand the fix.

The if sentence becomes true, when both acpi_device->driver and acpi_device->handler
are NULL. It means that acpi_eject_store() runs if either acpi_device->driver or
acpi_device->handler has pointer. Is it O.K.?

I think it should be if (!acpi_device->driver || !acpi_device->handler).

Thanks,
Yasuaki Ishimatsu

>   		ret = -ENODEV;
>   		goto err;
>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


