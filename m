Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3HTFSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:18:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39675 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3HTFSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:18:54 -0400
X-Spam-Score: -101.0
Message-ID: <5212FC01.80607@asianux.com>
Date: Tue, 20 Aug 2013 13:17:53 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sysctl.c: check return value after call proc_put_char()
 in __do_proc_doulongvec_minmax()
References: <5212E481.9080204@asianux.com> <5212E4B2.5020708@asianux.com> <1376975340.2016.42.camel@joe-AO722>
In-Reply-To: <1376975340.2016.42.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 01:09 PM, Joe Perches wrote:
> On Tue, 2013-08-20 at 11:38 +0800, Chen Gang wrote:
>> Need check the return value of proc_put_char(), just like another have
>> done in __do_proc_doulongvec_minmax().
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/sysctl.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 7822cd8..ee00986 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -2214,8 +2214,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>>  			*i = val;
>>  		} else {
>>  			val = convdiv * (*i) / convmul;
>> -			if (!first)
>> +			if (!first) {
>>  				err = proc_put_char(&buffer, &left, '\t');
>> +				if (err)
>> +					goto free;
>> +			}
> 
> I think you should use break and convert it in
> to goto free in patch 2/2.
> 
> Otherwise, this style looks out of place.
> 

Hmm... It sounds reasonable to me, if necessary, I will send patch v2
for them (no reply means not need send patch v2, this time).

Thanks.

>>  			err = proc_put_long(&buffer, &left, val, false);
>>  			if (err)
>>  				break;
> 
> 
> 
> 
> 


-- 
Chen Gang
