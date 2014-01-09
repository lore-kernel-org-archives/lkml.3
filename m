Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaAILh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:37:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaAILhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:37:46 -0500
Message-ID: <52CE89F9.4040908@ti.com>
Date: Thu, 9 Jan 2014 17:07:29 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <tj@kernel.org>
CC: <kishon@ti.com>, <b.zolnierkie@samsung.com>, <hdegoede@redhat.com>,
        <arnd@arndb.de>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v4 2/3] ata: ahci_platform: Manage SATA PHY
References: <1389264962-22858-1-git-send-email-rogerq@ti.com> <1389264962-22858-3-git-send-email-rogerq@ti.com> <52CE85E9.7040703@cogentembedded.com>
In-Reply-To: <52CE85E9.7040703@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 04:50 PM, Sergei Shtylyov wrote:
> On 09-01-2014 14:56, Roger Quadros wrote:
> 
>> From: Balaji T K <balajitk@ti.com>
> 
>> Some platforms have a PHY hooked up to the
>> SATA controller. The PHY needs to be initialized
>> and powered up for SATA to work. We do that
>> using the PHY framework.
> 
>> [Roger Q] Cleaned up.
> 
>> CC: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> [...]
> 
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index d5ced13..b476642 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -142,6 +142,39 @@ static int ahci_probe(struct platform_device *pdev)
>>           }
>>       }
>>
>> +    hpriv->phy = devm_phy_get(dev, "sata-phy");
>> +    if (IS_ERR(hpriv->phy)) {
>> +        rc = PTR_ERR(hpriv->phy);
>> +        switch (rc) {
>> +        case -ENODEV:
>> +        case -ENOSYS:
>> +            /* continue normally */
>> +            hpriv->phy = NULL;
>> +            break;
>> +
>> +        case -EPROBE_DEFER:
>> +            goto disable_unprepare_clk;
>> +            break;
> 
>    Well, well, *break* after *goto*? :-)
> 
I know it is pointless functionally, but it is just my preference
aesthetically.

Is it much of an issue if left as is?

cheers,
-roger

