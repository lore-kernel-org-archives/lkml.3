Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3DHEE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:04:27 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50638 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3DHEEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:04:25 -0400
X-Spam-Score: -100.8
Message-ID: <516241AB.7040903@asianux.com>
Date: Mon, 08 Apr 2013 12:03:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: tsacct: strncpy, always be sure of NUL terminated.
References: <5162390C.5060804@asianux.com> <CAHGf_=rPcUWc=YvR4YTQJH=+SSEQ40nSYmSQXX_aJLDMquiPGw@mail.gmail.com>
In-Reply-To: <CAHGf_=rPcUWc=YvR4YTQJH=+SSEQ40nSYmSQXX_aJLDMquiPGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月08日 11:52, KOSAKI Motohiro wrote:
> On Sun, Apr 7, 2013 at 11:27 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> >
>> >   for NUL terminated string, always set '\0' at the end.
>> >
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  kernel/tsacct.c |    3 ++-
>> >  1 files changed, 2 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/kernel/tsacct.c b/kernel/tsacct.c
>> > index a1dd9a1..01bcc4e 100644
>> > --- a/kernel/tsacct.c
>> > +++ b/kernel/tsacct.c
>> > @@ -78,7 +78,8 @@ void bacct_add_tsk(struct user_namespace *user_ns,
>> >         stats->ac_minflt = tsk->min_flt;
>> >         stats->ac_majflt = tsk->maj_flt;
>> >
>> > -       strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
>> > +       strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm) - 1);
>> > +       stats->ac_comm[sizeof(stats->ac_comm) - 1] = '\0';
> sizeof(tsk->comm) is 16 and sizeof(stats->ac_comm) is 32. then this statement
> is strange. and set_task_comm ensure tsk->comm is nul-terminated.
> 
> so your code never change the behavior, right?
> 

  right.

  thank you for your information:
    originally, I really did not check the sizeof details.


> And, If buggy driver change tsk->comm not to use set_task_comm and tsk->comm
> is not nul-terminated, strncpy() still touch unrelated memory and ac_comm may
> expose kernel internal info. that's bad.
> 
> 

  really, that's bad !

  thank you for your information:
    originally, I did not think of a buggy driver can change tsk->comm.


  :-)

-- 
Chen Gang

Asianux Corporation
