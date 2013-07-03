Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3GCHA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:00:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:46108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab3GCHA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:00:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,986,1363158000"; 
   d="scan'208";a="364001129"
Message-ID: <51D3CC06.3080509@linux.intel.com>
Date: Wed, 03 Jul 2013 10:00:22 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, willemb@google.com, erdnetdev@gmail.com,
        andi@firstfloor.org, hpa@zytor.com, devel-lists@codyps.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH v2 net-next] net: convert lls to use time_in_range()
References: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>   <20130701.140833.1705666564717621661.davem@davemloft.net>   <51D2919F.7050007@linux.intel.com> <51D29329.4060004@linux.intel.com>   <51D2A246.3000705@linux.intel.com>  <1372795835.1919.14.camel@bwh-desktop.uk.level5networks.com>  <51D337D0.1080901@linux.intel.com> <1372797778.1919.17.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1372797778.1919.17.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 23:42, Ben Hutchings wrote:
> On Tue, 2013-07-02 at 23:28 +0300, Eliezer Tamir wrote:
>> On 02/07/2013 23:10, Ben Hutchings wrote:
>>> On Tue, 2013-07-02 at 12:49 +0300, Eliezer Tamir wrote:
>>>> Time in range will fail safely if we move to a different cpu with an
>>>> extremely large clock skew.
>>>> Add time_in_range64() and convert lls to use it.
>>>>
>>>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>>>> ---
>>>> v1->v2
>>>> fixed double call to sched_clock() in can_poll_ll(), checkpatchisms
>>
>>>> +#define time_in_range64(a, b, c) \
>>>> +	(time_after_eq64(a, b) && \
>>>> +	 time_before_eq64(a, c))
>>> [...]
>>>
>>> Why not make this an inline function, so the caller doesn't need to
>>> worry about repeated evaluation?
>>
>> I was following the conventions in jiffies.h
>> (well almost, I did add a few spaces to make checkpatch happy)
>
> I see, but now you have a good reason to change that convention.

I'm not sure that an inline function is always a win.
Macros do get evaluated at an earlier stage.

Having just the new function use a different convention is plain
wrong, people are virtually guarantied to not notice until they
introduce a bug.

Are you suggesting we convert all of jiffies.h into inline functions?

Invoking the principle of least astonishment, I think it's best to keep 
the changes minimal.

Or would you prefer to risk breaking things all over in subtle ways
that are sure to get Linus to go voodoo on your hamster?

I for one care about hamsters.

-Eliezer
