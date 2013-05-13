Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3EMC52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:57:28 -0400
Received: from ozlabs.org ([203.10.76.45]:45322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3EMC50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:57:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module.c: for looping, need use 'goto' instead of 'break' to jump out in time
In-Reply-To: <5189C1D6.1040209@asianux.com>
References: <51889EE4.4070504@asianux.com> <87ip2unwkt.fsf@rustcorp.com.au> <5189C1D6.1040209@asianux.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 13 May 2013 10:47:19 +0930
Message-ID: <87li7j3cgw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
> On 2013年05月08日 08:29, Rusty Russell wrote:
>> Chen Gang <gang.chen@asianux.com> writes:
>>> > In the 'for' looping, when error occurs, the 'break' only jump out of
>>> > 'switch', and still in 'for' looping.  If error occurs multiple times,
>>> > the original error value will be overwrite.
>>> >
>>> > Currently, that will not cause issue, but still better to improve it,
>>> > so that let it return the first real error code in time.
>> We choose to print all the problems, rather than just one.  I don't
>> really mind though.
>> 
>
> It sounds good: "choose to print all the problems, rather than just one"
>
> If so, it seems enough to only return a bool value to known whether
> success or fail, do not need the error details any more (since they are
> already been printed)
>
>> It we want this patch, it would be neater to just 'return -ENOEXEC'
>> and 'return PTR_ERR(ksym) ?: -ENOENT'.
>
> If we really want this patch (still only print the first error, and
> return the real error value), I should send patch v2 (also 'ret' is
> obsoleted)

I would take such a patch, since it makes things a little neater.  But
if you don't write it, I wouldn't write it myself, since it's
borderline.

Thanks,
Rusty.
