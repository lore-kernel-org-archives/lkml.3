Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaAEXPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:15:09 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34104 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaAEXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:15:07 -0500
Message-ID: <52C9E773.5080207@gmail.com>
Date: Mon, 06 Jan 2014 01:14:59 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: gregkh@linuxfoundation.org, omar.ramirez@copitl.com, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] Staging: tidspbridge: Use hashtable implementation
References: <52C9AAB3.6050300@gmail.com> <1388948292-5084-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20140105194752.GF5443@mwanda>
In-Reply-To: <20140105194752.GF5443@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.01.2014 21:47, Dan Carpenter wrote:
> Looks much nicer.  I had a few tiny comments, but those could be
> addressed in later patches.  (There is a lot of work to be done on this
> driver).
>
> On Sun, Jan 05, 2014 at 08:58:12PM +0200, Ivaylo Dimitrov wrote:
>> -static u16 name_hash(void *key, u16 max_bucket)
>> +static u32 name_hash(const void *key)
>>   {
>> -	u16 ret;
>> -	u16 hash;
>> -	char *name = (char *)key;
>> +	u32 hash;
>> +	const char *name = (const char *)key;
>                             ^^^^^^^^^^^^^^
>
> I can't compile this driver, but I'm pretty sure this cast is not
> needed.
>
>> -static bool name_match(void *key, void *sp)
>> +static bool name_match(const void *key, const void *sp)
>>   {
>>   	if ((key != NULL) && (sp != NULL)) {
>> -		if (strcmp((char *)key, ((struct dbll_symbol *)sp)->name) ==
>> -		    0)
>> +		if (strcmp((const char *)key,
>> +			   ((const struct dbll_symbol *)sp)->name) == 0)
>>   			return true;
> Unneeded casting.
>
> 		if (strcmp(key, ((struct dbll_symbol *)sp)->name) == 0)
> 			return true;
>
> regards,
> dan carpenter
Yeah, both are not needed (I am thinking C++ most of the time and have 
forgotten that C is much relaxed than C++ :) ). However, I will send a 
new version which fixes that, IMO it is better to fix it while I am on it.

Thanks,
Ivo
