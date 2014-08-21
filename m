Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaHUHj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:39:59 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1831 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaHUHj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:39:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Aug 2014 00:26:07 -0700
Message-ID: <53F5A249.7030008@nvidia.com>
Date: Thu, 21 Aug 2014 10:39:53 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, <rui.zhang@intel.com>,
        <edubezval@gmail.com>, <thierry.reding@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com> <1407320706-17440-5-git-send-email-mperttunen@nvidia.com> <53F4FC18.90804@wwwdotorg.org>
In-Reply-To: <53F4FC18.90804@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/08/14 22:50, Stephen Warren wrote:
> On 08/06/2014 04:25 AM, Mikko Perttunen wrote:
>> This adds support for the Tegra SOCTHERM thermal sensing and management
>> system found in the Tegra124 system-on-chip. This initial driver supports
>> temperature polling for four thermal zones.
>
> Since both the Tegra DT patches and this driver all rely on a new header
> added by patch 1/4, I guess this whole series needs to be applied in one
> branch. I think it makes sense to apply it to the Tegra since it's
> likely to have more conflicts there and fewer in the thermal
> maintainer's tree. It can be applied in a topic branch that can be
> merged into the thermal maintainer's tree if required to resolve
> conflicts there.
>
> Rui, Eduardo, do you agree?
>
>> diff --git a/drivers/thermal/tegra_soctherm.c
>> b/drivers/thermal/tegra_soctherm.c
>
>> +static struct of_device_id tegra_soctherm_of_match[] = {
>> +    { .compatible = "nvidia,tegra124-soctherm" },
>> +    { },
>> +};
>> +MODULE_DEVICE_TABLE(of, tegra_soctherm_of_match);
>> +
>> +static int thermctl_temp_offsets[] = {
>> +    SENSOR_TEMP1, SENSOR_TEMP2, SENSOR_TEMP1, SENSOR_TEMP2
>> +};
>> +
>> +static int thermctl_temp_shifts[] = {
>> +    16, 16, 0, 0
>> +};
>
> Can any/all of those be const?

Yes!

>
> I don't pretend to know anything about the soctherm HW, but I see no
> gross issues in the code structure, so,
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks; I'll need to do a v5 anyway, so I'll fix the things you 
mentioned while doing it.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
