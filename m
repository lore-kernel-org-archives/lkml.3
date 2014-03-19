Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbaCSCVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:21:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56963 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758736AbaCSCVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:21:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,682,1389715200"; 
   d="scan'208";a="9722367"
Message-ID: <5328FEB1.6080903@cn.fujitsu.com>
Date: Wed, 19 Mar 2014 10:19:29 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 3/3] sched: Use clamp() and clamp_val() to make it more
 readable.
References: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com> <08e669fea4242209aa625237214410c6bbf67dba.1394619587.git.yangds.fnst@cn.fujitsu.com> <20140318221618.38da4688@gandalf.local.home>
In-Reply-To: <20140318221618.38da4688@gandalf.local.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/19 10:18:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/19 10:18:29,
	Serialize complete at 2014/03/19 10:18:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 10:16 AM, Steven Rostedt wrote:
> On Wed, 12 Mar 2014 18:26:44 +0800
> Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
>
>> As Kees suggested, I use clamp() function to replace the if and
>> else branch, making it more readable and modular.
>>
>> Suggested-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   kernel/sched/core.c | 11 ++---------
>>   1 file changed, 2 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 259ab85..85f4231 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3068,17 +3068,10 @@ SYSCALL_DEFINE1(nice, int, increment)
>>   	 * We don't have to worry. Conceptually one call occurs first
>>   	 * and we have a single winner.
>>   	 */
>> -	if (increment < -NICE_WIDTH)
>> -		increment = -NICE_WIDTH;
>> -	if (increment > NICE_WIDTH)
>> -		increment = NICE_WIDTH;
>> -
> Patch 2 and 3 need to be merged into a single patch.

Okey, I will squash them into one.

Thanx
>
> -- Steve
>
>> +	increment = clamp(increment, -NICE_WIDTH, NICE_WIDTH);
>>   	nice = task_nice(current) + increment;
>> -	if (nice < MIN_NICE)
>> -		nice = MIN_NICE;
>> -	if (nice > MAX_NICE)
>> -		nice = MAX_NICE;
>>   
>> +	nice = clamp_val(nice, MIN_NICE, MAX_NICE);
>>   	if (increment < 0 && !can_nice(current, nice))
>>   		return -EPERM;
>>   
>

