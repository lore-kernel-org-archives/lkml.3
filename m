Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3AaUPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:15:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36937 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab3AaUPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:15:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [RESEND PATCH 1/4] ACPI/PM: Fix acpi_bus_get_device() check in drivers/acpi/device_pm.c
Date: Thu, 31 Jan 2013 21:21:57 +0100
Message-ID: <3199804.hxRfeorGhh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5109E366.4090703@jp.fujitsu.com>
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <5109E189.7040105@jp.fujitsu.com> <5109E366.4090703@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 31, 2013 12:22:14 PM Yasuaki Ishimatsu wrote:
> I fogot to change subject. So I resend a patch.

I have applied patches [1-3/4] to my bleeding-edge branch, but please note that
something (probably your MUA) added a space in front of every line originally
starting with a space.

Thanks,
Rafael


> ---
> acpi_bus_get_device() returns int not acpi_status.
> 
> The patch change not to apply ACPI_FAILURE() to the return value of
> acpi_bus_get_device().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>   drivers/acpi/device_pm.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-pm/drivers/acpi/device_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/device_pm.c	2013-01-31 11:04:30.000000000 +0900
> +++ linux-pm/drivers/acpi/device_pm.c	2013-01-31 11:28:51.366849592 +0900
> @@ -213,7 +213,7 @@ int acpi_pm_device_sleep_state(struct de
>   	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
>   	struct acpi_device *adev;
>   
> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
> +	if (!handle || acpi_bus_get_device(handle, &adev)) {
>   		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
>   		return -ENODEV;
>   	}
> @@ -290,7 +290,7 @@ int acpi_pm_device_run_wake(struct devic
>   		return -EINVAL;
>   
>   	handle = DEVICE_ACPI_HANDLE(phys_dev);
> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
> +	if (!handle || acpi_bus_get_device(handle, &adev)) {
>   		dev_dbg(phys_dev, "ACPI handle without context in %s!\n",
>   			__func__);
>   		return -ENODEV;
> @@ -334,7 +334,7 @@ int acpi_pm_device_sleep_wake(struct dev
>   		return -EINVAL;
>   
>   	handle = DEVICE_ACPI_HANDLE(dev);
> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
> +	if (!handle || acpi_bus_get_device(handle, &adev)) {
>   		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
>   		return -ENODEV;
>   	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
