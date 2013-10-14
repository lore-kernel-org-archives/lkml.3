Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab3JNQ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:29:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:44150 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab3JNQ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="392761147"
Message-ID: <525C1CBB.9030708@linux.intel.com>
Date: Mon, 14 Oct 2013 09:32:59 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 07/10] intel_mid: Added custom device_handler support
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com>  <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>  <525C15E8.9010201@zytor.com> <1381767415.25528.10.camel@joe-AO722>
In-Reply-To: <1381767415.25528.10.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:16 AM, Joe Perches wrote:
> On Mon, 2013-10-14 at 09:03 -0700, H. Peter Anvin wrote:
>> On 10/11/2013 08:43 PM, David Cohen wrote:
>>>
>>>   	/* MSIC subdevices */
>>> -	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
>>> -	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data},
>>> -	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
>>> -	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
>>> -	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
>>> -	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data},
>>> -
>>> +	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
>>> +					NULL},
>>> +	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
>>> +	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
>>> +	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
>>> +					NULL},
>>> +	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
>>> +	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
>>> +					NULL},
>>>   	{},
>>>   };
>>>
>>
>> For highly regular arrays like this it is better to keep each line a
>> single line even if it gets a bit too long rather than randomly breaking
>> them.  The alternative is to put every field of every entry on a
>> separate line, but I don't think that is necessary called for here.
>
> True.
>
> Another option is to #define YA macro to produce the
> SFI_DEV_TYPE_IPC, 1, ... NULL that's common to all of them.

Thanks for your feedback. The parameters happen to be similar at this
time, but they won't be after next patches. I believe a macro could 
remove only prefix 'SFI_DEV_TYPE_' and suffix '_platform_data', which
seems enough to reduce line size.

I'll change it in new patch set.

Br, David Cohen

