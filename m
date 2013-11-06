Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3KFGEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 01:04:04 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2079 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3KFGEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 01:04:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Nov 2013 22:02:58 -0800
Message-ID: <5279DBD6.9090708@nvidia.com>
Date: Wed, 6 Nov 2013 14:04:06 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
CC: "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Jinyoung Park <jinyoungp@nvidia.com>
Subject: Re: [PATCH] thermal: Fix binding problem when there is thermal zone
 params
References: <1382090587-9602-1-git-send-email-wni@nvidia.com>
 <1383715752.2073.11.camel@rzhang1-mobl4>
In-Reply-To: <1383715752.2073.11.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 01:29 PM, Zhang Rui wrote:
> On Fri, 2013-10-18 at 18:03 +0800, Wei Ni wrote:
>> @@ -247,7 +247,7 @@ static void bind_cdev(struct thermal_cooling_device *cdev)
>>  		if (!pos->tzp && !pos->ops->bind)
>>  			continue;
>>  
>> -		if (!pos->tzp && pos->ops->bind) {
>> +		if (pos->ops->bind) {
>>  			ret = pos->ops->bind(pos, cdev);
>>  			if (ret)
>>  				print_bind_err_msg(pos, cdev, ret);
> IMO, we should also add
> +		continue;
> after binding with pos->ops->bind(), to void binding via pos->tzp->tbp
> again, no?

Oh, yes, you are right. I will add it.

> 
> thanks,
> rui
>> @@ -282,8 +282,8 @@ static void bind_tz(struct thermal_zone_device *tz)
>>  
>>  	mutex_lock(&thermal_list_lock);
>>  
>> -	/* If there is no platform data, try to use ops->bind */
>> -	if (!tzp && tz->ops->bind) {
>> +	/* If there is ops->bind, try to use ops->bind */
>> +	if (tz->ops->bind) {
>>  		list_for_each_entry(pos, &thermal_cdev_list, node) {
>>  			ret = tz->ops->bind(tz, pos);
>>  			if (ret)
> 
> 

