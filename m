Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaJVXnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:43:13 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39168 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaJVXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
References: <20141021202137.GA20114@www.outflux.net>
	<20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
Date: Wed, 22 Oct 2014 16:43:10 -0700
X-Google-Sender-Auth: pPHZTXWUIxSLuuKxm_HsN_D-9AA
Message-ID: <CAGXu5j+sW89tZDA5GQnkL4E9wHTScftyxUhyAjbWnEfxGocBjg@mail.gmail.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Wise <pabs3@bonedaddy.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 4:26 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 21 Oct 2014 13:21:37 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> From: Paul Wise <pabs3@bonedaddy.net>
>>
>> This partially mitigates a common strategy used by attackers for hiding
>> the full contents of strings in procfs from naive sysadmins who use cat,
>> more or sysctl to inspect the contents of strings in procfs.
>>
>> ...
>>
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -1739,7 +1739,7 @@ static int _proc_do_string(char *data, int maxlen, int write,
>>               while ((p - buffer) < *lenp && len < maxlen - 1) {
>>                       if (get_user(c, p++))
>>                               return -EFAULT;
>> -                     if (c == 0 || c == '\n')
>> +                     if (c == 0 || c == '\n' || c == '\r')
>>                               break;
>>                       data[len++] = c;
>>               }
>
> There are no valid uses of \r in a procfs write?

I struggle to imagine one; everything I found that uses proc_dostring
seems to be names, paths, and commands.

-Kees

-- 
Kees Cook
Chrome OS Security
