Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaDVA6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:58:42 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64243 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaDVA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:58:39 -0400
Message-ID: <5355BEBA.8040001@gmail.com>
Date: Tue, 22 Apr 2014 08:58:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, len.brown@intel.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/power/hibernate.c: be sure of 'start' is not bigger
 than 'stop'
References: <53551FCB.3030109@gmail.com> <20140421200930.GA9880@amd.pavel.ucw.cz> <1597133.Gff7RjtQZQ@vostro.rjw.lan>
In-Reply-To: <1597133.Gff7RjtQZQ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 04:43 AM, Rafael J. Wysocki wrote:
> On Monday, April 21, 2014 10:09:30 PM Pavel Machek wrote:
>> On Mon 2014-04-21 21:40:27, Chen Gang wrote:
>>> For do_div(), it need 'u64' type, which means the outside must be sure
>>> of 'start' is not bigger than 'stop', or it will report warning.
>>>
>>> The related warning (with allmodconfig for unicore32):
>>>
>>>     CC      kernel/power/hibernate.o
>>>   kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
>>>   kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>
>>>  {
>>> -	s64 elapsed_centisecs64;
>>> +	u64 elapsed_centisecs64;
>>>  	int centisecs;
>>>  	int k;
>>>  	int kps;
>>>  
>>>  	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
>>> +	if ((s64)elapsed_centisecs64 < 0) {
>>> +		printk(KERN_ERR "PM: stop: %llu < start %llu\n",
>>> +			timeval_to_ns(stop), timeval_to_ns(start));
>>> +		return;
>>> +	}
>>>  	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
>>>  	centisecs = elapsed_centisecs64;
>>>  	if (centisecs == 0)
>>
>> Quite a lot of code to shut up warning in mostly debugging
>> function... is there alternative method of shutting it up? Have you
>> seen < 0 values in wild?
> 
> No, I don't think so.  This is a purely theoretical problem that never
> happens in practice, because all of the callers do the right thing.
> 
> Rafael 
> 

OK, it sounds fine to me, I shall send patch v2 for it.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
