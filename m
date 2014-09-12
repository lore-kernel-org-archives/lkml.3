Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaILRym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:54:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:7462 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaILRyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:54:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,514,1406617200"; 
   d="scan'208";a="572412274"
Message-ID: <54133333.1020406@linux.intel.com>
Date: Sat, 13 Sep 2014 01:53:55 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / platform / LPSS: disable async suspend/resume
 of LPSS devices
References: <540E91F0.2060306@linux.intel.com> <20140910075026.GB13406@lahna.fi.intel.com>
In-Reply-To: <20140910075026.GB13406@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/9/10 15:50, Mika Westerberg wrote:
> On Tue, Sep 09, 2014 at 01:36:48PM +0800, Fu, Zhonghui wrote:
>> >From 6deb00230f5df68da3ca7490402a0c537bf386bb Mon Sep 17 00:00:00 2001
>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>> Date: Tue, 9 Sep 2014 13:02:25 +0800
>> Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
>>
>> LPSS devices must suspend/resume in fixed order. Or some LPSS devices
>> will hang during the transition to ACPI_STATE_D0 state.
> In addition to the comment from Rafael, I would like to have more
> details here why we must suspend/resume the LPSS devices in certain
> order.
Sorry for late response.

After the patch "ACPI / platform / LPSS: Enable async suspend/resume of LPSS devices(commit ID: 8ce62f85a81f57e86bc120ab690facc612223188)" was merged into upstream kernel, some LPSS devices(UART, I2C) frequently hang during resume. So, my patch is actually reverting that patch.


>
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
>>  		return 1;
>>  	}
>>  
>> -- 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

