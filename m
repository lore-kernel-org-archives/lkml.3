Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab3DYURp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:17:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59680 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab3DYURo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:17:44 -0400
Message-ID: <51798F51.9010401@ti.com>
Date: Thu, 25 Apr 2013 16:17:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Hongbo Zhang <hongbo.zhang@stericsson.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/2] thermal: db8500_cpufreq_cooling: remove usage of
 IS_ERR_OR_NULL()
References: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com> <1366899214-22639-3-git-send-email-eduardo.valentin@ti.com> <20130425174635.GB25783@flint.arm.linux.org.uk>
In-Reply-To: <20130425174635.GB25783@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-04-2013 13:46, Russell King wrote:
> On Thu, Apr 25, 2013 at 10:13:34AM -0400, Eduardo Valentin wrote:
>> diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
>> index 21419851..786d192 100644
>> --- a/drivers/thermal/db8500_cpufreq_cooling.c
>> +++ b/drivers/thermal/db8500_cpufreq_cooling.c
>> @@ -37,7 +37,7 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
>>   	cpumask_set_cpu(0, &mask_val);
>>   	cdev = cpufreq_cooling_register(&mask_val);
>>
>> -	if (IS_ERR_OR_NULL(cdev)) {
>> +	if (IS_ERR(cdev)) {
>>   		dev_err(&pdev->dev, "Failed to register cooling device\n");
>>   		return PTR_ERR(cdev);
>
> Correct.  cpufreq_cooling_register() returns either an error-pointer or
> a valid pointer.
>

Thanks for your review!

