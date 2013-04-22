Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3DVMiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:38:52 -0400
Received: from ns.iliad.fr ([212.27.33.1]:43457 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3DVMiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:38:50 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2013 08:38:50 EDT
Message-ID: <51752D98.8070709@freebox.fr>
Date: Mon, 22 Apr 2013 14:31:20 +0200
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Serge Hallyn <serge.hallyn@canonical.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp filters.
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr> <1363618233-6375-2-git-send-email-nschichan@freebox.fr> <20130417145628.88058f0f3104ab9ae551ddd3@linux-foundation.org>
In-Reply-To: <20130417145628.88058f0f3104ab9ae551ddd3@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 11:56 PM, Andrew Morton wrote:
> This patch is killing me.
>
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -6,6 +6,7 @@
>>   #ifdef CONFIG_SECCOMP
>>
>>   #include <linux/thread_info.h>
>> +#include <linux/filter.h>
>>   #include <asm/seccomp.h>
>
> In file included from include/linux/compat.h:18,
>                   from include/linux/filter.h:9,
>                   from include/linux/seccomp.h:9,
>                   from include/linux/sched.h:39,
>                   from arch/x86/kernel/asm-offsets.c:9:
> /usr/src/25/arch/x86/include/asm/compat.h: In function 'arch_compat_alloc_user_space':
> /usr/src/25/arch/x86/include/asm/compat.h:301: error: dereferencing pointer to incomplete type
>
> Problem is, compat.h's arch_compat_alloc_user_space() needs sched.h for
> task_struct but as you can see from the above include tree, sched.h
> includes seccomp.h and everything falls over.  The preprocessed code
> contains the definition of arch_compat_alloc_user_space() *before* the
> definition of task_struct.
>
> This is a basic x86_64 "make clean; make allmodconfig; make".

Hi,

Would including <uapi/linux/filter.h> instead of <linux/filter.h> in seccomp.h 
be an acceptable solution ?

I have tried that and (with an additional forward declaration of struct 
sk_buff) an x86_64 "make clean; make allmodconfig" run finishes succesfully.

If that's ok with you, I can resend the serie with that fix.

Regards,

-- 
Nicolas Schichan
Freebox SAS
