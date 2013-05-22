Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3EVJXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:23:13 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62704 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3EVJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130522090643.GB18810@twins.programming.kicks-ass.net>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org>
	<1354024039.6276.72.camel@gandalf.local.home>
	<CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
	<CAKohpo=St0z0L9ei248s3KL_DqZtewQ50o7d=BTdwLFcpM+x3w@mail.gmail.com>
	<CAKohpo=0r=HY5w-XqnXv42eSJcH08C47J+TqWn7vY1aNBhGT_A@mail.gmail.com>
	<CAKohpo=eAGVA540jN8+t0aaqCV9qJRkH0q9-q6QVUYusWQqSYw@mail.gmail.com>
	<alpine.LFD.2.02.1305131223470.2863@ionos>
	<CAKohpokfKPQ3EhMf3WB8koXuH2rF6QoejwNOTw08X+XfnVhpEg@mail.gmail.com>
	<20130522090643.GB18810@twins.programming.kicks-ass.net>
Date: Wed, 22 May 2013 14:53:07 +0530
Message-ID: <CAKohpomMSPGtaTM8+F2+pz=JuWbHZ=+Vu1cdRML1LphuQYfCnA@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        pjt@google.com, paul.mckenney@linaro.org, tj@kernel.org,
        mingo@redhat.com, Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2013 14:36, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 22, 2013 at 02:04:16PM +0530, Viresh Kumar wrote:
>
>> So, this is the clean draft for the idea I had.. (Naming is poor for
>> now):
>>
>> diff --git a/include/linux/timer.h b/include/linux/timer.h
>> index 8c5a197..ad00ebe 100644
>> --- a/include/linux/timer.h
>> +++ b/include/linux/timer.h
>> @@ -20,6 +20,7 @@ struct timer_list {
>>
>>         void (*function)(unsigned long);
>>         unsigned long data;
>> +       int wait_for_migration_to_complete;
>
> If you play games with the alignment constraints of struct tvec_base you
> can get extra low bits to play with for TIMER_FLAG_MASK. See struct
> pool_workqueue for similar games.
>
> That would avoid the struct bloat and I suppose make tglx happy :-)

Sure, once the initial draft is approved we can get it optimized to the
best of our capabilities. :)
