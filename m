Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLSEq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 23:46:27 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34770 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSEq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 23:46:26 -0500
Message-ID: <5493AD9A.30509@gmail.com>
Date: Fri, 19 Dec 2014 10:16:18 +0530
From: karthik nayak <karthik.188@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: trivial@kernel.org, gregkh@linuxfoundation.org, anarey@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192u: removed an unnecessary else statement
References: <1418894411-9787-1-git-send-email-karthik.188@gmail.com> <20141218223819.GB6742@hudson.localdomain>
In-Reply-To: <20141218223819.GB6742@hudson.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/19/2014 04:08 AM, Jeremiah Mahler wrote:
> Karthik,
>
> On Thu, Dec 18, 2014 at 02:50:11PM +0530, Karthik Nayak wrote:
>> As per checkpatch warning, removed an unnecessary else statement
>> proceeding an if statement with a return.
>>
>> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
>> ---
>>   drivers/staging/rtl8192u/r8192U_dm.c | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
>> index 936565d..b3b508c 100644
>> --- a/drivers/staging/rtl8192u/r8192U_dm.c
>> +++ b/drivers/staging/rtl8192u/r8192U_dm.c
>> @@ -480,15 +480,13 @@ static void dm_bandwidth_autoswitch(struct net_device *dev)
>>   
>>   	if(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20 ||!priv->ieee80211->bandwidth_auto_switch.bautoswitch_enable){
>>   		return;
>> -	}else{
>> -		if(priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz == false){//If send packets in 40 Mhz in 20/40
>> -			if(priv->undecorated_smoothed_pwdb <= priv->ieee80211->bandwidth_auto_switch.threshold_40Mhzto20Mhz)
>> -				priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = true;
>> -		}else{//in force send packets in 20 Mhz in 20/40
>> -			if(priv->undecorated_smoothed_pwdb >= priv->ieee80211->bandwidth_auto_switch.threshold_20Mhzto40Mhz)
>> -				priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = false;
>> -
>> -		}
>> +	}
>> +	if(priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz == false){//If send packets in 40 Mhz in 20/40
>> +		if(priv->undecorated_smoothed_pwdb <= priv->ieee80211->bandwidth_auto_switch.threshold_40Mhzto20Mhz)
>> +			priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = true;
>> +	}else{//in force send packets in 20 Mhz in 20/40
>> +		if(priv->undecorated_smoothed_pwdb >= priv->ieee80211->bandwidth_auto_switch.threshold_20Mhzto40Mhz)
>> +			priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = false;
>>   	}
>>   }	// dm_BandwidthAutoSwitch
>>   
> [...]
>
> Wow, I don't think I have ever seen a file with so many checkpatch errors!
>
> Instead of only fixing one instance of one error I would fix all
> instances of that type of error.  Since the changes would be very
> similar it should still be easy to review.
>
> You could even make a whole patch series with each patch fixing one type
> of error.  Although I would keep the series to just a few at first until
> you are sure you are doing everything right.
>
Hello Jeremiah,
I agree, there are a lot of errors, so I fixed a single issue.
This is just to get used to checkpatch system.
I can write patches to fix the other things, but I rather not.
I hope you get the point.
Regards
Karthik Nayak
