Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3GLAZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:25:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44977 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3GLAZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:25:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <51DF4CB6.4060903@jp.fujitsu.com>
Date: Fri, 12 Jul 2013 09:24:22 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / memhotplug: Fix a stale pointer in error path
References: <1373474833-14047-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1373474833-14047-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/11 1:47), Toshi Kani wrote:
> device->driver_data needs to be cleared when releasing its data,
> mem_device, in an error path of acpi_memory_device_add().
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/acpi/acpi_memhotplug.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index c711d11..999adb5 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -323,6 +323,7 @@ static int acpi_memory_device_add(struct acpi_device *device,
>   	/* Get the range from the _CRS */
>   	result = acpi_memory_get_device_resources(mem_device);
>   	if (result) {
> +		device->driver_data = NULL;
>   		kfree(mem_device);
>   		return result;
>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


