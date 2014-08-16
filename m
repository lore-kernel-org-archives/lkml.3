Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaHPVjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:39:48 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36050 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaHPVjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAFo99gbr=Bk76j1nwEAEke7fqv=HYRq5MwVWUxF5UxL=D9kZwQ@mail.gmail.com>
References: <1407628009-24701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CAGXu5jJxHsr2YKL8vN2W24F_KEcVOAa480+VhCLB+re+hswtfg@mail.gmail.com>
	<CAFo99gbr=Bk76j1nwEAEke7fqv=HYRq5MwVWUxF5UxL=D9kZwQ@mail.gmail.com>
Date: Sat, 16 Aug 2014 16:39:46 -0500
X-Google-Sender-Auth: JqGpkrXNUKjivHJs1_CnLTkhayM
Message-ID: <CAGXu5jLPUZaooSD6yH3zJSW1jmA-kCT204X3indf7JRd5mAuyg@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: workitem.c: Cleaning up
 missing null-terminate after strncpy call
From: Kees Cook <keescook@chromium.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Masanari Iida <standby24x7@gmail.com>,
        Mike Sampson <mike@sambodata.com>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 4:14 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> 2014-08-12 16:58 GMT+02:00 Kees Cook <keescook@chromium.org>:
>> On Sat, Aug 9, 2014 at 4:46 PM, Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se> wrote:
>>> Added a guaranteed null-terminate after call to strncpy.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>> ---
>>>  drivers/staging/lustre/lustre/libcfs/workitem.c |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
>>> index 0a03bf7..60326f2 100644
>>> --- a/drivers/staging/lustre/lustre/libcfs/workitem.c
>>> +++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
>>> @@ -365,6 +365,7 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
>>>                 return -ENOMEM;
>>>
>>>         strncpy(sched->ws_name, name, CFS_WS_NAME_LEN);
>>> +       sched->ws_name[CFS_WS_NAME_LEN - 1] = '\0';
>>>         sched->ws_cptab = cptab;
>>>         sched->ws_cpt = cpt;
>>
>> This seems like a place for strlcpy instead?
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS Security
>
> Hi Kees
>
> Sure, strlcpy is preferable in many ways if we only can guarantee that
> it is safe.
> I have seldom received so much criticism when I start switching to
> strlcpy, although much of it was justified :)
> Even Linus was getting into the debate.  See more:
>
> https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5
>
>
> I do this only when I'm sure it will not cause any other problems.
> But if you or anyone else can guarantee that in this case, so I'd make
> a new patch with strlcpy.

Ah right, yeah, that limitation is weird. In that case, for your original patch:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees


-- 
Kees Cook
Chrome OS Security
