Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3BMHhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:37:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51324 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab3BMHht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:37:49 -0500
X-Sasl-enc: qfe/p7ctVxEdZIkt1RQ/HOR4Qf/VmuwjI1QRM8FvxSaG 1360741068
Message-ID: <1360741066.2288.7.camel@perseus.themaw.net>
Subject: Re: [PATCH linux-next] autofs4: autofs4_catatonic_mode(): remove
 redundant null check on kfree()
From: Ian Kent <raven@themaw.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org
Date: Wed, 13 Feb 2013 15:37:46 +0800
In-Reply-To: <511B3F5B.4050803@msgid.tls.msk.ru>
References: <1360689138-59191-1-git-send-email-tim.gardner@canonical.com>
	 <1360740008.2288.3.camel@perseus.themaw.net>
	 <511B3F5B.4050803@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 11:23 +0400, Michael Tokarev wrote:
> 13.02.2013 11:20, Ian Kent wrote:
> > On Tue, 2013-02-12 at 10:12 -0700, Tim Gardner wrote:
> >> smatch analysis:
> >>
> >> fs/autofs4/waitq.c:46 autofs4_catatonic_mode() info: redundant null
> >>   check on wq->name.name calling kfree()
> >
> > I'm not sure about this change.
> >
> > autofs4_catatonic_mode() could be called when there are remaining
> > entries in the wait queue, which is nulled, so autofs4_wait_release()
> > won't see the the discarded waits if it is called.
> 
> Ian, this is about something else really.  The patch is about the
> NULL check before calling kfree() -- it does the NULL check internally.
> It is nothing about code flow or anything else, it is about calling
> kfree() unconditionally regardless whenever the argument is actually
> NULL or non-NULL.  It makes the code shorter and easier to read.

Oh, right, kfree() does the a NULL check since a long time now.
My bad, sorry.

> 
> You can add my
> 
> Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>

So, you would like me to forward this to Linus?

I'd be inclined to wait until the window for 3.9 opens since Linus
probably has more than enough to do finalizing 3.8 right now.

Ian


