Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3HAQh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab3HAQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:37:56 -0400
Date: Thu, 1 Aug 2013 18:32:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zml@linux.vnet.ibm.com>
Cc: Zach Levis <zach@zachsthings.com>, Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-binfmts-better-handling-of-binfmt-loops.patch added to
	-mm tree
Message-ID: <20130801163237.GA16070@redhat.com>
References: <20130731200805.GA29678@redhat.com> <20130801150532.GA15349@redhat.com> <20130801090223.Horde.UZGId5ir309R_oaPIezA7qA@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801090223.Horde.UZGId5ir309R_oaPIezA7qA@imap.linux.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Zach Levis wrote:
>
> So an example of what this would be used for (going into commit message 
> of a v2 with your earlier suggestions):

Ah, so you are going to send v2, great.

May I ask you to wait a little bit? Once again, I believe that
search_binary_handler() needs a cleanup + minor fix. I'll try
to send the patch today.

> With this patch, an error is printed

I agree, it makes sense to print an error with names.

> and search_binary_handler()
> continues on to the next handler, allowing the original executable to
> run normally so the user can (hopefully) fix their misconfiguration more
> easily.

Still not sure this makes sense, but I can't judge and I won't argue.

>>> And I do not think we should ignore the possible error from
>>> copy_strings(). Even if we know that it succeeded before, another
>>> thread can, say, unmap this memory in between.
>>
>> And since we do copy_strings() again we probably need acct_arg_size()
>> after remove_arg_zero() loop, although this is not that important.
> I'm not sure if that's even necessary.

Yes, I was wrong, thanks for correcting me. We don't need this.

> It looks like there's
> copy_strings()->get_arg_page()->acct_arg_size() that's already called.

This doesn't matter, this won't unaccount the memory. But I was
wrong anyway, we do not need to unaccount because vma won't grow.

Oleg.

