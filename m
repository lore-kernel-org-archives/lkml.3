Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3EQQNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:13:01 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45224 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab3EQQNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:13:00 -0400
Message-ID: <51965707.5010305@parallels.com>
Date: Fri, 17 May 2013 20:12:55 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Pavel Tikhomirov <snorcht@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] posix-timers: Show clock ID in proc file
References: <1368742323-46949-1-git-send-email-snorcht@gmail.com> <1368742323-46949-2-git-send-email-snorcht@gmail.com> <20130517155916.GA24976@kroah.com>
In-Reply-To: <20130517155916.GA24976@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 07:59 PM, Greg KH wrote:
> On Fri, May 17, 2013 at 02:12:03AM +0400, Pavel Tikhomirov wrote:
>> Expand information about posix-timers in /proc/<pid>/timers by adding
>> info about clock, with which the timer was created. I.e. in the forth
>> line of timer info after "notify:" line go "ClockID: <clock_id>".
>>
>> Signed-off-by: Pavel Tikhomirov <snorcht@gmail.com>
>> ---
>>  fs/proc/base.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 2dad4a9..8a38eef 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2079,6 +2079,7 @@ static int show_timer(struct seq_file *m, void *v)
>>  		nstr[notify & ~SIGEV_THREAD_ID],
>>  		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
>>  		pid_nr_ns(timer->it_pid, tp->ns));
>> +	seq_printf(m, "ClockID: %d\n", timer->it_clock);
> 
> What userspace tool just broke by adding a new field to this file?

Zero for two reasons:

1. this proc file appeared this merge window
2. this file format is

  <name>: <value>

and should be parsed line-by-line by applications like e.g. /proc/pid/status
or /proc/pid/smaps. Both these files were extended with fields in the past with
no worries to tools, so should be this new one.

> thanks,
> 
> greg k-h
> .
> 


Thanks,
Pavel
