Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3AaXoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:44:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33859 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3AaXoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:44:04 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <510B018D.4050800@jp.fujitsu.com>
Date: Fri, 1 Feb 2013 08:43:09 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [RESEND PATCH 1/4] ACPI/PM: Fix acpi_bus_get_device() check in
 drivers/acpi/device_pm.c
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <5109E189.7040105@jp.fujitsu.com> <5109E366.4090703@jp.fujitsu.com> <3199804.hxRfeorGhh@vostro.rjw.lan>
In-Reply-To: <3199804.hxRfeorGhh@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

2013/02/01 5:21, Rafael J. Wysocki wrote:
> On Thursday, January 31, 2013 12:22:14 PM Yasuaki Ishimatsu wrote:
>> I fogot to change subject. So I resend a patch.
>
> I have applied patches [1-3/4] to my bleeding-edge branch,

Thanks.

> but please note that
> something (probably your MUA) added a space in front of every line originally
> starting with a space.

I apologize for bothering you.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> Rafael
>
>
>> ---
>> acpi_bus_get_device() returns int not acpi_status.
>>
>> The patch change not to apply ACPI_FAILURE() to the return value of
>> acpi_bus_get_device().
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>>    drivers/acpi/device_pm.c |    6 +++---
>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> Index: linux-pm/drivers/acpi/device_pm.c
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/device_pm.c	2013-01-31 11:04:30.000000000 +0900
>> +++ linux-pm/drivers/acpi/device_pm.c	2013-01-31 11:28:51.366849592 +0900
>> @@ -213,7 +213,7 @@ int acpi_pm_device_sleep_state(struct de
>>    	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
>>    	struct acpi_device *adev;
>>
>> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
>> +	if (!handle || acpi_bus_get_device(handle, &adev)) {
>>    		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
>>    		return -ENODEV;
>>    	}
>> @@ -290,7 +290,7 @@ int acpi_pm_device_run_wake(struct devic
>>    		return -EINVAL;
>>
>>    	handle = DEVICE_ACPI_HANDLE(phys_dev);
>> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
>> +	if (!handle || acpi_bus_get_device(handle, &adev)) {
>>    		dev_dbg(phys_dev, "ACPI handle without context in %s!\n",
>>    			__func__);
>>    		return -ENODEV;
>> @@ -334,7 +334,7 @@ int acpi_pm_device_sleep_wake(struct dev
>>    		return -EINVAL;
>>
>>    	handle = DEVICE_ACPI_HANDLE(dev);
>> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
>> +	if (!handle || acpi_bus_get_device(handle, &adev)) {
>>    		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
>>    		return -ENODEV;
>>    	}
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


