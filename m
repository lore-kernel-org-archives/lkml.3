Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaILRv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:51:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:52223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbaILRvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,514,1406617200"; 
   d="scan'208";a="572406751"
Message-ID: <54132FFA.7050300@linux.intel.com>
Date: Sat, 13 Sep 2014 01:40:10 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / platform / LPSS: disable async suspend/resume
 of LPSS devices
References: <540E91F0.2060306@linux.intel.com> <74255682.ogZlaWiZ0J@vostro.rjw.lan>
In-Reply-To: <74255682.ogZlaWiZ0J@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi, Rafael

Sorry for late response.

Yes,Only removing the "enable" line is sufficient. I have verified this, and made a new patch as follows.

Thanks,
Zhonghui

>From 3c89c22c5b35ddbdcadecd391f2521a15ffc2f4f Mon Sep 17 00:00:00 2001
From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
Date: Sat, 13 Sep 2014 01:26:04 +0800
Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices

LPSS devices must suspend/resume in fixed order. Or some LPSS devices
will hang during the transition to ACPI_STATE_D0 state.

Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index fddc1e8..b0ea767 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -419,7 +419,6 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
 	adev->driver_data = pdata;
 	pdev = acpi_create_platform_device(adev);
 	if (!IS_ERR_OR_NULL(pdev)) {
-		device_enable_async_suspend(&pdev->dev);
 		return 1;
 	}
 
-- 1.7.1



On 2014/9/9 21:17, Rafael J. Wysocki wrote:
> On Tuesday, September 09, 2014 01:36:48 PM Fu, Zhonghui wrote:
>> From 6deb00230f5df68da3ca7490402a0c537bf386bb Mon Sep 17 00:00:00 2001
>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>> Date: Tue, 9 Sep 2014 13:02:25 +0800
>> Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
>>
>> LPSS devices must suspend/resume in fixed order. Or some LPSS devices
>> will hang during the transition to ACPI_STATE_D0 state.
>>
>> Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>> ---
>>  drivers/acpi/acpi_lpss.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
>> index fddc1e8..54e5c97 100644
>> --- a/drivers/acpi/acpi_lpss.c
>> +++ b/drivers/acpi/acpi_lpss.c
>> @@ -419,7 +419,7 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>>  	adev->driver_data = pdata;
>>  	pdev = acpi_create_platform_device(adev);
>>  	if (!IS_ERR_OR_NULL(pdev)) {
>> -		device_enable_async_suspend(&pdev->dev);
>> +		device_disable_async_suspend(&pdev->dev);
> Removing the "enable" line should be sufficient for that.  Isn't it?
>
>>  		return 1;
>>  	}
>>  
>> -- 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

