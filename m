Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbaFSN1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:27:32 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34664 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbaFSN1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:27:30 -0400
Date: Thu, 19 Jun 2014 09:27:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: percpu: micro-optimize round-to-even
Message-ID: <20140619132727.GG11042@htj.dyndns.org>
References: <1403172149-25353-1-git-send-email-linux@rasmusvillemoes.dk>
 <20140619132536.GF11042@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619132536.GF11042@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:25:36AM -0400, Tejun Heo wrote:
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

Another thing is that it isn't even clear whether the micro
optimization is even actually better given that predicted branches are
extremely cheap and this one is extremely predictable.  So, again,
let's please leave it to the compiler.

Thanks.

-- 
tejun
