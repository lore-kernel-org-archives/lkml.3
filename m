Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DHVA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:00:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52806 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935536Ab3DHVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:00:26 -0400
Date: Mon, 8 Apr 2013 14:00:20 -0700
From: Kent Overstreet <koverstreet@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Message-ID: <20130408210020.GI15749@google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
 <20130327182150.GB25906@google.com>
 <51533A2E.2000501@infradead.org>
 <20130327195050.GB22232@google.com>
 <alpine.DEB.2.02.1304071415220.3441@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304071415220.3441@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 02:15:49PM -0700, David Rientjes wrote:
> On Wed, 27 Mar 2013, Kent Overstreet wrote:
> 
> > Nope - looks like __WARN() doesn't exist if CONFIG_BUG=n, whoops.
> > 
> > Adding this to the queue:
> > 
> > commit 796c213186b850b3e6e8d5fd5799b0fd74721ea3
> > Author: Kent Overstreet <koverstreet@google.com>
> > Date:   Wed Mar 27 12:47:45 2013 -0700
> > 
> >     bcache: Use WARN_ONCE() instead of __WARN()
> >     
> >     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > 
> > diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> > index d4f2164..cb4578a 100644
> > --- a/drivers/md/bcache/bset.c
> > +++ b/drivers/md/bcache/bset.c
> > @@ -883,7 +883,7 @@ struct bkey *bch_btree_iter_next(struct btree_iter *iter)
> >  		iter->data->k = bkey_next(iter->data->k);
> >  
> >  		if (iter->data->k > iter->data->end) {
> > -			__WARN();
> > +			WARN_ONCE(1, "bset was corrupt!\n");
> >  			iter->data->k = iter->data->end;
> >  		}
> >  
> 
> This problem still persists in linux-next as of today, how is this fix 
> being pushed?

Sorry for the delay, I've been moving all last week - I just sent Jens a
pull request with the latest bcache fixes, though.
