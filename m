Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaDVWfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:35:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39030 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDVWfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:35:43 -0400
Message-ID: <5356EEBB.5040402@infradead.org>
Date: Tue, 22 Apr 2014 15:35:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Jan Moskyto Matejka <mq@suse.cz>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix documentation for /proc/stat, line "intr"
References: <1398180580-8089-1-git-send-email-mq@suse.cz> <5356B2AB.3020005@gmail.com>
In-Reply-To: <5356B2AB.3020005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/14 11:19, Michael Kerrisk (man-pages) wrote:
> On 04/22/2014 05:29 PM, Jan Moskyto Matejka wrote:
>> The sum at the beginning of line "intr" includes also unnumbered interrupts.
>> It implies that the sum at the beginning isn't the sum of the remainder of the
>> line, not even an estimation.
>>
>> Fixed the documentation to mention that.
> 
> I'm not really doubting what you claim, Jan, but it would be really
> helpful if you provided some data to support the proposed change
> (Kernel source references, or notes about testing you've done, or 
> pointers to mailing list threads, authoritative note that you are
> the maintainer of some relevant kernel subsystem...). Do you have
> something like that? (It's also useful for the change log.)

I wouldn't mind more of a changelog, but the additional text is
certainly correct.

Thanks.  I'll apply the patch, but more changelog comments are welcome.

> Thanks,
> 
> Michael
> 
>> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
>> ---
>>  Documentation/filesystems/proc.txt | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
>> index f00bee1..4e6f9d0 100644
>> --- a/Documentation/filesystems/proc.txt
>> +++ b/Documentation/filesystems/proc.txt
>> @@ -1245,8 +1245,9 @@ second).  The meanings of the columns are as follows, from left to right:
>>  
>>  The "intr" line gives counts of interrupts  serviced since boot time, for each
>>  of the  possible system interrupts.   The first  column  is the  total of  all
>> -interrupts serviced; each  subsequent column is the  total for that particular
>> -interrupt.
>> +interrupts serviced  including  unnumbered  architecture specific  interrupts;
>> +each  subsequent column is the  total for that particular numbered interrupt.
>> +Unnumbered interrupts are not shown, only summed into the total.
>>  
>>  The "ctxt" line gives the total number of context switches across all CPUs.
>>  
>>
> 
> 


-- 
~Randy
