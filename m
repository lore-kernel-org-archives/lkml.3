Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaHTVIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:08:43 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47262 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaHTVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <87mwayj39c.fsf@rustcorp.com.au>
References: <1408564816-1778-1-git-send-email-arjun024@gmail.com> <87mwayj39c.fsf@rustcorp.com.au>
From: Arjun Sreedharan <arjun024@gmail.com>
Date: Thu, 21 Aug 2014 02:38:19 +0530
Message-ID: <CAJFMrCG1OXrdRoUNqtZYdBqE_0dj+a3yAfFhuyFvTte7Ozbo0w@mail.gmail.com>
Subject: Re: [PATCH] params: fix potential memory leak in add_sysfs_param()
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2014 02:19, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Arjun Sreedharan <arjun024@gmail.com> writes:
>> Do not leak memory when attrs is non NULL and
>> krealloc() fails. Without temporary variable,
>> reference to it is lost.
>>
>> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
>
> ...
>
>>       }
>> -     /* Despite looking like the typical realloc() bug, this is safe.
>> -      * We *want* the old 'attrs' to be freed either way, and we'll store
>> -      * the new one in the success case. */
>> -     attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
>> -     if (!attrs) {
>> +
>> +     new_attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
>> +     if (!new_attrs) {
>
> I think that comment you deleted is pretty clear.  Is it wrong?
>
> Cheers,
> Rusty.

I believe it's wrong. I do not understand how `this is safe` from memory leak.
If krealloc() fails, there is nothing in place to free memory held by @attrs
