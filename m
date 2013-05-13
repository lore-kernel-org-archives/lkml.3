Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3EMDdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:33:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30807 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3EMDdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:33:53 -0400
X-Spam-Score: -100.8
Message-ID: <51905EEF.2050901@asianux.com>
Date: Mon, 13 May 2013 11:33:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module.c: for looping, need use 'goto' instead
 of 'break' to jump out in time
References: <51889EE4.4070504@asianux.com> <87ip2unwkt.fsf@rustcorp.com.au> <5189C1D6.1040209@asianux.com> <87li7j3cgw.fsf@rustcorp.com.au>
In-Reply-To: <87li7j3cgw.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 09:17 AM, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>> > On 2013年05月08日 08:29, Rusty Russell wrote:
>>> >> Chen Gang <gang.chen@asianux.com> writes:
>>>>> >>> > In the 'for' looping, when error occurs, the 'break' only jump out of
>>>>> >>> > 'switch', and still in 'for' looping.  If error occurs multiple times,
>>>>> >>> > the original error value will be overwrite.
>>>>> >>> >
>>>>> >>> > Currently, that will not cause issue, but still better to improve it,
>>>>> >>> > so that let it return the first real error code in time.
>>> >> We choose to print all the problems, rather than just one.  I don't
>>> >> really mind though.
>>> >> 
>> >
>> > It sounds good: "choose to print all the problems, rather than just one"
>> >
>> > If so, it seems enough to only return a bool value to known whether
>> > success or fail, do not need the error details any more (since they are
>> > already been printed)
>> >
>>> >> It we want this patch, it would be neater to just 'return -ENOEXEC'
>>> >> and 'return PTR_ERR(ksym) ?: -ENOENT'.
>> >
>> > If we really want this patch (still only print the first error, and
>> > return the real error value), I should send patch v2 (also 'ret' is
>> > obsoleted)
> I would take such a patch, since it makes things a little neater.  But
> if you don't write it, I wouldn't write it myself, since it's
> borderline.

OK, thank, I should write it, and now I will "choose to print all the
problems, and return a bool value", and it will be as a cleanup patch.

I will finish it within 2 days (2013-05-15).

If have additional suggestions or completions, please reply.


Thanks.
-- 
Chen Gang

Asianux Corporation
