Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3EHDKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:10:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49543 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3EHDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:10:01 -0400
X-Spam-Score: -100.8
Message-ID: <5189C1D6.1040209@asianux.com>
Date: Wed, 08 May 2013 11:09:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module.c: for looping, need use 'goto' instead
 of 'break' to jump out in time
References: <51889EE4.4070504@asianux.com> <87ip2unwkt.fsf@rustcorp.com.au>
In-Reply-To: <87ip2unwkt.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年05月08日 08:29, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>> > In the 'for' looping, when error occurs, the 'break' only jump out of
>> > 'switch', and still in 'for' looping.  If error occurs multiple times,
>> > the original error value will be overwrite.
>> >
>> > Currently, that will not cause issue, but still better to improve it,
>> > so that let it return the first real error code in time.
> We choose to print all the problems, rather than just one.  I don't
> really mind though.
> 

It sounds good: "choose to print all the problems, rather than just one"

If so, it seems enough to only return a bool value to known whether
success or fail, do not need the error details any more (since they are
already been printed)

> It we want this patch, it would be neater to just 'return -ENOEXEC'
> and 'return PTR_ERR(ksym) ?: -ENOENT'.

If we really want this patch (still only print the first error, and
return the real error value), I should send patch v2 (also 'ret' is
obsoleted)

Thanks.

-- 
Chen Gang

Asianux Corporation
