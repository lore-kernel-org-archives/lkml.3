Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbaFSO35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:29:57 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:58329 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757944AbaFSO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:29:55 -0400
Date: Thu, 19 Jun 2014 09:29:52 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: percpu: micro-optimize round-to-even
In-Reply-To: <20140619132536.GF11042@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406190925430.2785@gentwo.org>
References: <1403172149-25353-1-git-send-email-linux@rasmusvillemoes.dk> <20140619132536.GF11042@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Tejun Heo wrote:

> On Thu, Jun 19, 2014 at 12:02:29PM +0200, Rasmus Villemoes wrote:
> > This change shaves a few bytes off the generated code.
> >
> > Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > ---
> >  mm/percpu.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 2ddf9a9..978097f 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -720,8 +720,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
> >  	if (unlikely(align < 2))
> >  		align = 2;
> >
> > -	if (unlikely(size & 1))
> > -		size++;
> > +	size += size & 1;
>
> I'm not gonna apply this.  This isn't that hot a path.  It's not
> worthwhile to micro optimize code like this.

Dont we have an ALIGN() macro for this?

