Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaHPVOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:14:38 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:62649 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPVOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:14:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJxHsr2YKL8vN2W24F_KEcVOAa480+VhCLB+re+hswtfg@mail.gmail.com>
References: <1407628009-24701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <CAGXu5jJxHsr2YKL8vN2W24F_KEcVOAa480+VhCLB+re+hswtfg@mail.gmail.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat, 16 Aug 2014 23:14:16 +0200
Message-ID: <CAFo99gbr=Bk76j1nwEAEke7fqv=HYRq5MwVWUxF5UxL=D9kZwQ@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: workitem.c: Cleaning up
 missing null-terminate after strncpy call
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Masanari Iida <standby24x7@gmail.com>,
        Mike Sampson <mike@sambodata.com>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-12 16:58 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Sat, Aug 9, 2014 at 4:46 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/lustre/lustre/libcfs/workitem.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
>> index 0a03bf7..60326f2 100644
>> --- a/drivers/staging/lustre/lustre/libcfs/workitem.c
>> +++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
>> @@ -365,6 +365,7 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
>>                 return -ENOMEM;
>>
>>         strncpy(sched->ws_name, name, CFS_WS_NAME_LEN);
>> +       sched->ws_name[CFS_WS_NAME_LEN - 1] = '\0';
>>         sched->ws_cptab = cptab;
>>         sched->ws_cpt = cpt;
>
> This seems like a place for strlcpy instead?
>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security

Hi Kees

Sure, strlcpy is preferable in many ways if we only can guarantee that
it is safe.
I have seldom received so much criticism when I start switching to
strlcpy, although much of it was justified :)
Even Linus was getting into the debate.  See more:

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5


I do this only when I'm sure it will not cause any other problems.
But if you or anyone else can guarantee that in this case, so I'd make
a new patch with strlcpy.


Kind regards

Rickard Strandqvist
