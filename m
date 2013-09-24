Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3IXSNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:13:07 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18293 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IXSNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:13:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Sep 2013 11:13:04 -0700
Message-ID: <5241D62E.1060705@nvidia.com>
Date: Tue, 24 Sep 2013 14:13:02 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com> <20130919202706.GB4470@ulmo> <523B6257.4040302@nvidia.com> <20130920075302.GB8575@ulmo>
In-Reply-To: <20130920075302.GB8575@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/2013 3:53 AM, Thierry Reding wrote:
>>>> +     name = charger_device->pdata->name;
>>>> +     if (!name) {
>>>> +             name = kasprintf(GFP_KERNEL, "bq24735-%s",
>>>> +                              dev_name(&client->dev));
>>>
>>> Won't the device name already include bq24735 because of the driver
>>> name?
>>
>> In my experience this comes up with a name like "bq24735-5-0009". Thats
>> why I added the bq24735 in the beginning, so the name is more descriptive.
> 
> Yes, you're right. Perhaps in that case it's even easier to just stick
> with a static string such as "bq24735" or "bq24735-charger". It's likely
> to be the only device of that type in a machine. If you want to include
> the device name, perhaps something like "%s/bq24735" (5-0009/bq24735) is
> clearer that 5-0009 is actually the bus-specific name.
> 

So it turns out if I try to put in a '/' or '\' they are translated to
'!' in sysfs, so the name comes out to be '5-0009!bq24735'. Perhaps
'bq24735@5-0009' to still signify that the 5-009 is more of an address
than chip name? What do you think Thierry?

-rhyland

-- 
nvpublic
