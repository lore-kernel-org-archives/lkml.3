Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3AXQ60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:58:26 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40042 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3AXQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:58:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAJn8CcE2eXK83-Jsia37dLoEwVjhQ=SiDru5fFzWGp+bzEScWA@mail.gmail.com>
References: <20130107113144.GA7544@redhat.com>
	<20130109183248.GA8293@somewhere.redhat.com>
	<CAJn8CcE2eXK83-Jsia37dLoEwVjhQ=SiDru5fFzWGp+bzEScWA@mail.gmail.com>
Date: Thu, 24 Jan 2013 17:58:20 +0100
Message-ID: <CAFTL4hzhdXkh2cy_iCr1iQJ5boJ=k1D61s+Z48YUk-JuENG7cw@mail.gmail.com>
Subject: Re: [PATCH v2 repost] sched: cputime: avoid multiplication overflow
 (in common cases)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/24 Xiaotian Feng <xtfeng@gmail.com>:
> On Thu, Jan 10, 2013 at 2:33 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> --- a/kernel/sched/cputime.c
>> +++ b/kernel/sched/cputime.c
>> @@ -509,11 +509,11 @@ EXPORT_SYMBOL_GPL(vtime_account);
>>  # define nsecs_to_cputime(__nsecs)     nsecs_to_jiffies(__nsecs)
>>  #endif
>>
>> -static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
>> +static cputime_t scale_utime(cputime_t stime, cputime_t rtime, cputime_t total)
>
> s/scale_utime/scale_stime.

Whoops! :-)

Thanks I'm fixing this.
