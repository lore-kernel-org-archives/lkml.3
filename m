Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaK3P4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:56:36 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60615 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaK3P4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:56:34 -0500
Message-ID: <547B3E30.3030600@roeck-us.net>
Date: Sun, 30 Nov 2014 07:56:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Fix temperature bug handling in i8k_get_temp()
References: <201411181546.51284@pali> <1416322614-10308-1-git-send-email-pali.rohar@gmail.com> <547ADC90.8000507@roeck-us.net> <201411301548.16031@pali>
In-Reply-To: <201411301548.16031@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.547B3E32.0041,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 11/30/2014 06:48 AM, Pali Rohár wrote:
[ ... ]
>>>
>>> +	if (temp > I8K_MAX_TEMP)
>>> +		return -ERANGE;
>>
>> Can we return -ENODATA in this case ? I think that would be
>> more appropriate.
>>
>
> This is internal kernel function, no problem. If you prefer
> NODATA instead RANGE I will change it.
>
The idea was to return ENODATA to user space (see below).

>>>    #endif
>>>
>>>    	return temp;
>>>
>>> @@ -499,6 +501,8 @@ static ssize_t
>>> i8k_hwmon_show_temp(struct device *dev,
>>>
>>>    	int temp;
>>>    	
>>>    	temp = i8k_get_temp(index);
>>>
>>> +	if (temp == -ERANGE)
>>> +		return -EINVAL;
>>
>> and can we also return -ENODATA to user space ?
>> This would make the code a bit cleaner.
>>
>> Thanks,
>> Guenter
>
> There was some problems when I tested similar patch for radeon.ko
> (do not report temperature to userspace when card is turned off).
>

You mean when returning -ENODATA to user space ?
I tested that; it worked for me and does what we want it to do
(the sensors command to displays N/A). This would avoid having
to change -ERANGE to a different error code above.

Guenter


