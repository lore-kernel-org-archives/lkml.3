Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaHCPH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 11:07:27 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58218 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaHCPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 11:07:26 -0400
Message-ID: <53DE5179.3080402@gmail.com>
Date: Sun, 03 Aug 2014 17:12:57 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 3/4] Add the "verbose" module option.
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>	<1406901650-20841-4-git-send-email-kreijack@inwind.it> <20140803161223.0b26e4bc@endymion.delvare>
In-Reply-To: <20140803161223.0b26e4bc@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2014 04:12 PM, Jean Delvare wrote:
> Hi Goffredo,
> 
> You messed up your Cc's ;-)

I fight hard with git-send-email.... In the next trip I will check two times !


> 
> On Fri,  1 Aug 2014 14:00:49 +0000, Goffredo Baroncelli wrote:
>> The "verbose" option controls the message in the kernel log
>> verbose = 0   no message
>> verbose = 1   log only the fan speed changes
>> verbose = 2   log the fan speed changes and the temperature changes
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>  drivers/macintosh/therm_windtunnel.c | 37 +++++++++++++++++++++++-------------
>>  1 file changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
>> index 1e50455..0c4eb85 100644
>> --- a/drivers/macintosh/therm_windtunnel.c
>> +++ b/drivers/macintosh/therm_windtunnel.c
>> @@ -44,7 +44,11 @@
>>  #include <asm/sections.h>
>>  #include <asm/macio.h>
>>  
>> -#define LOG_TEMP		0			/* continuously log temperature */
>> +static int verbose = 1;	  /* see description below */
> 
> This comment seems useless.
ok

> 
>> +module_param(verbose, int, 0644);
>> +MODULE_PARM_DESC(verbose, "Vebosity level: 0=silent, "
> 
> Typo: Verbosity
Ok
> 
>> +				"1=log the fan tuning, "
>> +				"2=log the temperature.");
> 
> Trailing dot is not needed.
OK


>>  
>>  static struct {
[... cut cut cut ...]
>> +	/*
>> +	 * if verbose >0 log each fan tuning
>> +	 * if verbose >1 log each cpu temperature change
>> +	 */
> 
> I think it is a good idea to have all the printing in a single place.
> 
>> +	if ((verbose > 1 && x.temp != temp ) ||
> 
> No space before closing parenthesis. I know the original code did not
> follow the standard coding style but you have the opportunity to make
> it better. Same many times below. scripts/checkpatch.pl tells you about
> that and many other style issues, most of which are easily fixable.
> 
> Also don't you want to log changes of case temperature too?

yes it make sense.

> 
>> +	    (verbose > 0 && level >= 0)) {
>> +		print_temp("CPU-temp: ", temp );
>> +		if (casetemp)
>> +			print_temp(", Case: ", casetemp );
>> +		if (level >= 0)
>> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
>> +				x.fan_level-level );
>> +		else
>> +			printk(", Fan: %d (tuned +0)\n",x.fan_level);
> 
> I think you can do without the "tuned +0" which doesn't add much value.

Me too. But the old driver does the same, so I preferred to 
leave it as is.

> 
>> +	}
>> +
>> +	x.temp = temp;
>> +	x.casetemp = casetemp;
>> +
>>  	if( level >= 0 )
>>  		tune_fan( level );
>>  }
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
