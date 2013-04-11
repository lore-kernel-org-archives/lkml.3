Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3DKEBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:01:01 -0400
Received: from ozlabs.org ([203.10.76.45]:43680 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3DKEA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:00:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: kallsyms: parameters checking, for EXPORT_SYMBOL_GPL functions
In-Reply-To: <51654557.3000308@asianux.com>
References: <5163AE9A.8060505@asianux.com> <871uai7tzu.fsf@rustcorp.com.au> <51654557.3000308@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 11 Apr 2013 12:22:37 +0930
Message-ID: <87ppy14w3u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
> On 2013年04月10日 14:57, Rusty Russell wrote:
>> Chen Gang <gang.chen@asianux.com> writes:
>>> >   for EXPORT_SYMBOL_GPL functions, necessary to check their parameters.
>>> >
>>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> Why?
>> 
>> If someone misuses these functions, they crash and thus indicate that
>> the caller shouldn't do that.
>> 
>
>   for me, I think:
>
>     if it is used by self (such as static functions):
>       I prefer to crash immediatly.
>       it will help us to find issue, quickly.
>
>     if it can be used by others (such as EXPORT_SYMBOL_GPL):
>       I prefer to return fail and tell caller that parameter is invalid.
>       it is more polite to callers, and still indicate it may be an issue.
>
>   :-)

I disagree.  Calling with invalid parameters is a bug.  You've just
covered up some cases of invalid use and made it less likely to be
found.  Because the caller won't notice they screwed up.

We could sprinkle WARN_ON() everywhere, but I prefer the crash.  Even
harder to ignore.

There's no limit to how many of these checks we could put in, and we can
*never* take them out.  I don't want to code that way.

>> Or is someone already doing this?
>> 
>
>   really has:
>
>     kernel: __wake_up_sync_key in kernel/sched/core.c.
>     lib: *printf.
>     mm:  kfree.

No, I mean "is someone calling these functions with NULL".

Cheers,
Rusty.
