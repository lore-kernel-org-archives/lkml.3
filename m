Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3I0Tex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:34:53 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58400 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3I0Tev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <u4d2odca38.fsf@md.dent.med.uni-muenchen.de>
References: <52326166.4060003@zytor.com> <u4d2odca38.fsf@md.dent.med.uni-muenchen.de>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 27 Sep 2013 12:34:30 -0700
Message-ID: <CACT4Y+aDUqZa8+oiJwKDTL=j-tfT+xn7+2FgC-CGtzLJwwj78g@mail.gmail.com>
Subject: Re: [PATCH] Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
To: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kees@outflux.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 3:03 AM, Wolfram Gloger
<wmglo@dent.med.uni-muenchen.de> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> Actually, the sanest would be:
>>
>>       if (fp  < (unsigned long)stack ||
>>           fp >= (unsigned long)stack+(THREAD_SIZE-16))
>>
>> ... wouldn't it (since we are accessing an 8-byte datum at offset +8?
>
> Ok, splitting hairs maybe, what about this V2 of the patch?
>
> fp is under userspace control.  stack-8 cannot underflow, otherwise we'd
> have much more serious problems in kernel space.
>
> Hence, for dereferencing fp+8:
>
> The case fp == stack-8 is valid.
> As is the case fp == stack+(THREAD_SIZE-16).
> Everything outside is invalid.
>
> About the worst-case implications: Like I said I have not reproduced it
> and cannot really comment on that.


+kees@, linux-kernel@
