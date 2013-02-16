Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3BPK1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 05:27:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18054 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3BPK1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 05:27:35 -0500
Message-ID: <511F5F04.9000009@oracle.com>
Date: Sat, 16 Feb 2013 18:27:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>
Subject: Re: [RESEND] [PATCH] kernel/res_counter.c: remove useless return
 statement at res_counter_member()
References: <510C9E74.3070402@oracle.com> <20130214152122.920f4936.akpm@linux-foundation.org>
In-Reply-To: <20130214152122.920f4936.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and David,

On 02/15/2013 07:21 AM, Andrew Morton wrote:
> On Sat, 02 Feb 2013 13:04:52 +0800
> Jeff Liu <jeff.liu@oracle.com> wrote:
> 
>> The return statement after BUG() is invalid, move BUG() to the default choice of the switch.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  kernel/res_counter.c |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index ff55247..748a3bc 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -135,10 +135,9 @@ res_counter_member(struct res_counter *counter, int member)
>>  		return &counter->failcnt;
>>  	case RES_SOFT_LIMIT:
>>  		return &counter->soft_limit;
>> +	default:
>> +		BUG();
>>  	};
>> -
>> -	BUG();
>> -	return NULL;
>>  }
>>  
>>  ssize_t res_counter_read(struct res_counter *counter, int member,
> 
> I expect it was done that way to avoid a hey-theres-no-return-statement
> warning when CONFIG_BUG=n.
> 
Sorry for my late response, I just got back from vacation.  So it's better to
keep it as it is.

Thanks,
-Jeff

