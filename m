Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaKTOZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:25:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34695 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaKTOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:24:29 -0500
Message-ID: <546DF961.3050509@roeck-us.net>
Date: Thu, 20 Nov 2014 06:23:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        Linux PM <linux-pm@vger.kernel.org>
CC: Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, lm-sensors@lm-sensors.org,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCHv5 1/1] thermal: of: improve of-thermal sensor registration
 API
References: <1416492733-1624-1-git-send-email-edubezval@gmail.com> <1416492733-1624-2-git-send-email-edubezval@gmail.com> <20141120141806.GA1746@developer>
In-Reply-To: <20141120141806.GA1746@developer>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.546DF99C.0309,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 15
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 06:18 AM, Eduardo Valentin wrote:
> Hi Guenter,
>
> On Thu, Nov 20, 2014 at 10:12:13AM -0400, Eduardo Valentin wrote:
>> Different drivers request API extensions in of-thermal. For this reason,
>> additional callbacks are required to fit the new drivers needs.
>>
>> The current API implementation expects the registering sensor driver
>> to provide a get_temp and get_trend callbacks as function parameters.
>> As the amount of callbacks is growing, this patch changes the existing
>> implementation to use a .ops field to hold all the of thermal callbacks
>> to sensor drivers.
>>
>> This patch also changes the existing of-thermal users to fit the new
>> API design. No functional change is introduced in this patch.
>>
>> Cc: Alexandre Courbot <gnurou@gmail.com>
>> Cc: devicetree@vger.kernel.org
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Cc: Jean Delvare <jdelvare@suse.de>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-tegra@vger.kernel.org
>> Cc: lm-sensors@lm-sensors.org
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Stephen Warren <swarren@wwwdotorg.org>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
>> Reviewed-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
>> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
>> Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>
>> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
>> ---
>>   drivers/hwmon/lm75.c                               |  9 +++--
>>   drivers/hwmon/ntc_thermistor.c                     |  6 +++-
>>   drivers/hwmon/tmp102.c                             |  6 +++-
>
> Do you have objections if I queue this one for 3.19?
>

No.

Guenter

