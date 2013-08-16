Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3HPM3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3HPM3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:29:37 -0400
Date: Fri, 16 Aug 2013 14:23:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach L <zach@zachsthings.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, keescook@chromium.org,
        cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] fs/binfmts: Better handling of binfmt loops
Message-ID: <20130816122351.GA19291@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1376497898-18619-3-git-send-email-zach@zachsthings.com> <20130814175014.GA1080@redhat.com> <CADAMjFkDgyH+X=4UnNEKwgjjf4DxDvzkcKxJQpzLFnKL-ajK2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADAMjFkDgyH+X=4UnNEKwgjjf4DxDvzkcKxJQpzLFnKL-ajK2Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Zach L wrote:
>
> On 08/14/2013 10:50 AM, Oleg Nesterov wrote:
> > On 08/14, Zach Levis wrote:
> >>
> > Honestly, I dislike this version even more, sorry. The patch becomes
> > much more complex, and and it is still not clear to me why do we want
> > these complications.
> >
> It's a larger patch but the majority of the increase is from is
> splitting the binfmt initialization code into a separate function to
> address the issue you brought up where the state of the binprm was not
> entirely restored

I understand the reason. But I do not understand the value. IMHO, the
problem this patch tries to fix falls into the "don't do this" category
and doesn't worth the trouble.

> [snip]

This certainly answers my question you snipped ;)

> > And btw, if we want this, then why we only do this if recursion_depth == 0?
> > Just condider '#!/path-to-the-binary-which-wants-this-patch".
> Unless recursion_depth is 0, there could be a binfmt in between that
> would expect its changes to the binprm to remain in effect in lower
> handlers, so even with your example

My point was, this doesn't fix the same problem if depth != 0.

But yes, "depth > 0" can't simply do init_bprm().

> > And again, the patch (afaics) translates -ELOOP into -ENOEXEC on failure,
> > not good.
> it doesn't do that,

It does, afaics. Just suppose that -ELOOP comes from load_script(). We
restore everything and call the next handler which returns ENOEXEC.

And at first glance v5 does the same.

Oleg.

