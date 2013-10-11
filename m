Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JKSFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:05:09 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:42461 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3JKSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:05:07 -0400
Date: Fri, 11 Oct 2013 14:33:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: fix to initialize fname
 always before use it
Message-ID: <20131011173327.GN28369@ghostprotocols.net>
References: <20131011122317.9662.29736.stgit@kbuild-fedora.novalocal>
 <5257EFB3.9030009@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5257EFB3.9030009@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 11, 2013 at 09:31:47PM +0900, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> I've found a bug in my previous patch which was already picked
> in the perf/urgent branch. The buggy commit id is
> 
> e08cfd4bda7683cdbe6971c26cf23e2afdb1e7a8
> 
> And this is not related to the previous series of perf probe
> updates.

Ok, so it must go via perf/urgent or if that ends up not being anymore
possible, via stable, will try the perf/urgent path today,

- Arnaldo
 
> Thank you,
> 
> (2013/10/11 21:23), Masami Hiramatsu wrote:
> > Fix perf probe --list to initialize fname local var always before
> > use it. This may cause a SEGV if there is a probe which is in
> > the function body but not in any inline function.
> > 
> > Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/probe-finder.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > index c044052..e41b094 100644
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -1460,10 +1460,10 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
> >  			goto post;
> >  		}
> >  
> > +		fname = dwarf_decl_file(&spdie);
> >  		if (addr == (unsigned long)baseaddr) {
> >  			/* Function entry - Relative line number is 0 */
> >  			lineno = baseline;
> > -			fname = dwarf_decl_file(&spdie);
> >  			goto post;
> >  		}
> 
> 
> -- 
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
