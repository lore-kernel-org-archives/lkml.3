Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaLIWAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:00:06 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49151 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLIWAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:00:04 -0500
Message-ID: <548770E6.7040002@kernel.dk>
Date: Tue, 09 Dec 2014 15:00:06 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Arianna Avanzini <avanzini.arianna@gmail.com>
CC: namhyung@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] trace, blktrace: don't let the sysfs interface
 remove trace from running list
References: <8761env4vf.fsf@sejong.aot.lge.com>	<1415616049-1132-1-git-send-email-avanzini.arianna@gmail.com> <20141113210744.7a725036@gandalf.local.home>
In-Reply-To: <20141113210744.7a725036@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 07:07 PM, Steven Rostedt wrote:
> 
> Jens (Cc'd) maintains the blktrace. He can take this if he wants.
> 
> -- Steve
> 
> 
> On Mon, 10 Nov 2014 11:40:49 +0100
> Arianna Avanzini <avanzini.arianna@gmail.com> wrote:
> 
>> Currently, blktrace can be started/stopped via its ioctl-based interface
>> (used by the userspace blktrace tool) or via its ftrace interface. The
>> function blk_trace_remove_queue(), called each time an "enable" tunable
>> of the ftrace interface transitions to zero, removes the trace from the
>> running list, even if no function from the sysfs interface adds it to
>> such a list. This leads to a null pointer dereference.
>> This commit changes the blk_trace_remove_queue() function so that it
>> does not remove the blk_trace from the running list.
>>
>> v2:
>>     - Now the patch removes the invocation of list_del() instead of
>>       adding an useless if branch, as suggested by Namhyung Kim.
>>
>> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
>> ---
>>  kernel/trace/blktrace.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>> index c1bd4ad..bd05fd2 100644
>> --- a/kernel/trace/blktrace.c
>> +++ b/kernel/trace/blktrace.c
>> @@ -1493,9 +1493,6 @@ static int blk_trace_remove_queue(struct request_queue *q)
>>  	if (atomic_dec_and_test(&blk_probes_ref))
>>  		blk_unregister_tracepoints();
>>  
>> -	spin_lock_irq(&running_trace_lock);
>> -	list_del(&bt->running_list);
>> -	spin_unlock_irq(&running_trace_lock);
>>  	blk_trace_free(bt);
>>  	return 0;

Applied, thanks!

-- 
Jens Axboe

