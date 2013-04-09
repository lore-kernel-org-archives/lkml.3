Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936093Ab3DIUF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:05:56 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34177 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934655Ab3DIUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130409134544.GA6320@redhat.com>
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org>
	<1365113821-22749-5-git-send-email-yinghai@kernel.org>
	<20130409134544.GA6320@redhat.com>
Date: Tue, 9 Apr 2013 13:05:54 -0700
X-Google-Sender-Auth: fjPeXuCAIYpQoNDhNpCcc35VSN0
Message-ID: <CAE9FiQUETs0AGjd+72GOz=Pm=9QicM7L46OaiMwhtUFa65TTvA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 6:45 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 04, 2013 at 03:17:01PM -0700, Yinghai Lu wrote:
>
> [..]
>> @@ -1360,37 +1369,80 @@ static int __init parse_crashkernel_simp
>>
>>       if (*cur == '@')
>>               *crash_base = memparse(cur+1, &cur);
>> -     else if (*cur != ' ' && *cur != '\0') {
>> -             pr_warning("crashkernel: unrecognized char\n");
>> -             return -EINVAL;
>> +     else {
>> +             int i;
>> +
>> +             /* check with known suffix */
>> +             for (i = 0; suffix_tbl[i]; i++)
>> +                     if (!strncmp(cur, suffix_tbl[i], strlen(suffix_tbl[i])))
>> +                             return 0;
>> +
>
> So crashkernel=X@Y;high is a valid syntax? Looks like we will reserve
> X amount of RAM at base Y and ignore "high" or "low".

yes, we should reject them.

>
> [..]
...
>
> Why don't we structure it little differently. Now we seem to have 3
> categories of crashkernel= parameters.
>
> - crashkernel_simple (crashkernel=X or crashkernel=X@Y)
> - crashkernel_mem (crashkernel=range:size,.....)
> - crashkerenl_high_low_suffix (crashkernel=X;high or crashkernel=Y;low)
>
> if (suffix) {
>         parse_crashkernel_high_low_suffix()
> } else {
>         if (first_colon.....)
>                 parse_crashkernel_mem()
>         else
>                 parse_crashkernel_simple();
> }
>
> And now you should not require "simple_only" function parameter and you
> can also do strict syntax checking for each type of crashkernel=
> parameter.

yes, that will the code more readable.

Just send -v4 of this patch that will not reuse parse_crashkernel_simple.

Thanks

Yinghai
