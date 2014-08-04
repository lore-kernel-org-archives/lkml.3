Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaHDRFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:05:13 -0400
Received: from outrelay08.libero.it ([212.52.84.112]:47671 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHDRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:05:09 -0400
X-libjamoibt: 1823
Message-ID: <53DFBE8D.5050707@inwind.it>
Date: Mon, 04 Aug 2014 19:10:37 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, bryan@whatroute.net
Subject: Re: [PATCH 3/4] Add the "verbose" module option.
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>	 <1406901650-20841-4-git-send-email-kreijack@inwind.it>	 <20140803161223.0b26e4bc@endymion.delvare>	<53DE5179.3080402@gmail.com>	 <20140803175222.3433b646@endymion.delvare>  <53DE650E.4060909@gmail.com> <1407141986.4302.10.camel@chaos.site>
In-Reply-To: <1407141986.4302.10.camel@chaos.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 10:46 AM, Jean Delvare wrote:
> Le Sunday 03 August 2014 à 18:36 +0200, Goffredo Baroncelli a écrit :
>> On 08/03/2014 05:52 PM, Jean Delvare wrote:
>>> On Sun, 03 Aug 2014 17:12:57 +0200, Goffredo Baroncelli wrote:
>>>> On 08/03/2014 04:12 PM, Jean Delvare wrote:
>>>>>> +	    (verbose > 0 && level >= 0)) {
>>>>>> +		print_temp("CPU-temp: ", temp );
>>>>>> +		if (casetemp)
>>>>>> +			print_temp(", Case: ", casetemp );
>>>>>> +		if (level >= 0)
>>>>>> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
>>>>>> +				x.fan_level-level );
>>>>>> +		else
>>>>>> +			printk(", Fan: %d (tuned +0)\n",x.fan_level);
>>>>>
>>>>> I think you can do without the "tuned +0" which doesn't add much value.
>>>>
>>>> Me too. But the old driver does the same, so I preferred to 
>>>> leave it as is.
>>>
>>> I looked at the code again and no, I can't see the old code doing that.
>>> It has "tuned %+d" only in tune_fan() which is only called if
>>> level >= 0. The other printk (when tune_fan isn't called) doesn't have
>>> a "tuned" part.
>>
>> This is taken from an old log of a v3.2 kernel (no changes here):
>>
>> [  886.510879] CPU-temp: 55.4 C, Case: 33.1 C,  Fan: 0 (tuned -11)
>> [  910.522869] CPU-temp: 56.0 C, Case: 33.5 C,  Fan: 0 (tuned +0)
>> [  958.546880] CPU-temp: 57.0 C, Case: 34.1 C,  Fan: 3 (tuned +3)
>>
>> in the code if level <0, then there is no update in the log. But if
>> level >0 and level is equal to the previous one, this leads to
>> have "tuned +0"...
> 
> I agree with that.
> 
>> But I have to be honest: I have not fully understand how 
>> "level" is computed.
> 
> I agree with that too :/
> 
>> The printk without "(tuned %+d)" is never called because 
>> LOG_TEMP was #define(d) equal to 0.
> 
> And this is what your second printk is replacing. So it should not have
> the "(tuned *)" either.
> 
I removed the printk(s) from tune_fan(); the ones leaved replaced 
both the ones inside tune_fan() and the ones outside.

Anyway, Benjamin which is your opinion ? 
For me is equal to remove or to leave "(tune +0)" (when the tuning is equal to 0).
Jean think it is better to remove "(tune +0)" (when the tuning is equal to 0).
So if you haven't any objection I will remove it.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
