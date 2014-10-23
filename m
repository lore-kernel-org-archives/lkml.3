Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJWVy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:54:58 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:62412 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:54:57 -0400
Date: Thu, 23 Oct 2014 23:52:38 +0200
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: Re: [PATCH 15/15] perf: replace _BSD_SOURCE macro by _DEFAULT_SOURCE
Message-ID: <20141023215238.GC24223@marx-slim>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
 <1411422796-27049-16-git-send-email-alexis.berlemont@gmail.com>
 <20140928221553.GA22895@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928221553.GA22895@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro Koskinen wrote:
> Hi,
> 
> On Mon, Sep 22, 2014 at 11:53:16PM +0200, Alexis Berlemont wrote:
> > Starting from glibc-2.20, the macro _BSD_SOURCE is deprecated and
> > should be replaced by _DEFAULT_SOURCE.
> 
> This patch fixes perf build breakage with glibc-2.20, so _DEFAULT_SOURCE
> is needed.
> 
> But shouldn't you also keep _BSD_SOURCE still there for a while for
> backwards compatibility? (Not sure if it has relevance for those
> using older glibcs...).

One more terrible mistake... Sorry.

> 
> Anyway to fix the perf + glibc-2.20 build failure:
> 
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> 
> (BTW, your patch was missing Signed-off-by.)
> 

OK. I fixed that on the next patch set (and I read the doc
linux/Documentation/SubmittingPatches). I hope my next patch set will
be less ludicrous...

Thank you for your feedback.

Alexis

> A.
> 
> > ---
> >  tools/perf/util/util.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> > index 6686436..f56b4e0 100644
> > --- a/tools/perf/util/util.h
> > +++ b/tools/perf/util/util.h
> > @@ -38,7 +38,7 @@
> >  #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
> >  
> >  #define _ALL_SOURCE 1
> > -#define _BSD_SOURCE 1
> > +#define _DEFAULT_SOURCE 1
> >  #define HAS_BOOL
> >  
> >  #include <unistd.h>
> > -- 
> > 2.1.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
