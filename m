Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaFZNCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:02:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35229 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaFZNCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:02:31 -0400
Message-ID: <53AC1A02.2040704@arm.com>
Date: Thu, 26 Jun 2014 14:02:58 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 9/9] ARM: kernel: add outer cache support for cacheinfo
 implementation
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-10-git-send-email-sudeep.holla@arm.com> <20140625223748.GM32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140625223748.GM32514@n2100.arm.linux.org.uk>
X-OriginalArrivalTime: 26 Jun 2014 13:02:18.0102 (UTC) FILETIME=[DBF0B960:01CF913E]
X-MC-Unique: 114062614022908501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 25/06/14 23:37, Russell King - ARM Linux wrote:
> On Wed, Jun 25, 2014 at 06:30:44PM +0100, Sudeep Holla wrote:
>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>> index efc5cab..30ca151 100644
>> --- a/arch/arm/mm/cache-l2x0.c
>> +++ b/arch/arm/mm/cache-l2x0.c
>> @@ -105,6 +105,15 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
>>   	}
>>   }
>>
>> +static void l2x0_getinfo(struct outer_cache_info *info)
>> +{
>> +	if (!info)
>> +		return;
>
> Pointless NULL test.  If someone passes NULL to this function (which
> you never do in this file) then we want to know about it because _that_
> is a kernel bug - it is invalid to pass NULL.  Hence the kernel should
> oops.
>
> Please, don't go around adding stupid NULL tests for conditions which
> should _never_ happen, instead, rely on the kernel to oops if these
> invalid conditions occur.  That's why we produce a backtrace from such
> events, to allow invalid conditions to be debugged and fixed.
>
> Having stuff silently ignore in this way does not detect these bugs so
> they go by unnoticed.
>
> Take a moment to read some of the fs/ or kernel/ code, and you'll find
> a lack of NULL checks in there.  That's what gives that code performance,
> because it's not spending its time doing loads of useless NULL checks.
>

Understood, will get rid of it.

>> @@ -894,6 +903,7 @@ static void __init __l2c_init(const struct l2c_init_data *data,
>>   		data->enable(l2x0_base, aux, data->num_lock);
>>
>>   	outer_cache = fns;
>> +	outer_cache.get_info = l2x0_getinfo;
>
> NAK.  Think about it.
>

Ah, will specify in l2c_init_data for individual implementations so that
fixups is possible if needed for get_info. Sorry for missing this.

Regards,
Sudeep

