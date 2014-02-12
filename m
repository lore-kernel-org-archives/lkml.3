Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaBLFXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:23:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50226 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaBLFXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:23:35 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52FB0533.3020908@jp.fujitsu.com>
Date: Wed, 12 Feb 2014 14:22:59 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] ACPI / container: Fix error code path in container_device_attach()
References: <1575051.TZgsd5D5jn@vostro.rjw.lan>
In-Reply-To: <1575051.TZgsd5D5jn@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/12 9:05), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> To avoid leaking memory on errors from device_register(), do a
> put_device() on the device object in question in the error code
> path of container_device_attach().
>
> Fixes: caa73ea158de (ACPI / hotplug / driver core: Handle containers in a special way)
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---

Looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>
> 3.14 material.
>
> Thanks!
>
> ---
>   drivers/acpi/container.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> Index: linux-pm/drivers/acpi/container.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/container.c
> +++ linux-pm/drivers/acpi/container.c
> @@ -82,9 +82,10 @@ static int container_device_attach(struc
>   	ACPI_COMPANION_SET(dev, adev);
>   	dev->release = acpi_container_release;
>   	ret = device_register(dev);
> -	if (ret)
> +	if (ret) {
> +		put_device(dev);
>   		return ret;
> -
> +	}
>   	adev->driver_data = dev;
>   	return 1;
>   }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


