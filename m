Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaB0Ps4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:48:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49797 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaB0Psy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLVfekwi_fgjLDp9zVAenxEUwADM-6Kb=NzP7aJV6n+kw@mail.gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<76266614ae965cacc59033bd20385fbcf6393770.1393493277.git.rashika.kheria@gmail.com>
	<CAGXu5jLVfekwi_fgjLDp9zVAenxEUwADM-6Kb=NzP7aJV6n+kw@mail.gmail.com>
Date: Thu, 27 Feb 2014 09:48:54 -0600
Message-ID: <CABqD9haxuQv9FG1a+r79UYuhs9xhJVeeAB3rm7xzqTqM7FcwtA@mail.gmail.com>
Subject: Re: [PATCH 35/46] kernel: Mark function as static in kernel/seccomp.c
From: Will Drewry <wad@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        James Morris <james.l.morris@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 9:33 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Feb 27, 2014 at 4:20 AM, Rashika Kheria
> <rashika.kheria@gmail.com> wrote:
>> Mark function as static in kernel/seccomp.c because it is not used
>> outside this file.
>>
>> This eliminates the following warning in kernel/seccomp.c:
>> kernel/seccomp.c:296:6: warning: no previous prototype for 'seccomp_attach_user_filter' [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Will Drewry <wad@chromium.org>

It amazing what things slip through.  Thanks!

>> ---
>>  kernel/seccomp.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index b7a1004..0e004a7 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -293,7 +293,7 @@ fail:
>>   *
>>   * Returns 0 on success and non-zero otherwise.
>>   */
>> -long seccomp_attach_user_filter(char __user *user_filter)
>> +static long seccomp_attach_user_filter(char __user *user_filter)
>>  {
>>         struct sock_fprog fprog;
>>         long ret = -EFAULT;
>> --
>> 1.7.9.5
>>
