Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaCJOOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:14:35 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:36913 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaCJOOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:14:32 -0400
Date: Mon, 10 Mar 2014 11:14:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] perf trace: Decode architecture-specific signal
 numbers
Message-ID: <20140310141426.GB8859@ghostprotocols.net>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
 <1391648441.3003.101.camel@deadeye.wl.decadent.org.uk>
 <1394373333.2861.84.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394373333.2861.84.camel@deadeye.wl.decadent.org.uk>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 09, 2014 at 01:55:33PM +0000, Ben Hutchings escreveu:
> What's happening with this patch?  perf fails to build on alpha or sparc
> since 3.13.

Grrr, I thought I had processed all of these, but this got missed, did
it now, will push soon.

- Arnaldo
 
> Ben.
> 
> On Thu, 2014-02-06 at 01:00 +0000, Ben Hutchings wrote:
> > SIGSTKFLT is not defined on alpha, mips or sparc.
> > SIGEMT and SIGSWI are defined on some architectures and should be
> > decoded here if so.
> > 
> > Fixes: 8bad5b0abfdb ('perf trace: Beautify signal number arg in several syscalls')
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  tools/perf/builtin-trace.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> > index 5c32dcf..25ea64c 100644
> > --- a/tools/perf/builtin-trace.c
> > +++ b/tools/perf/builtin-trace.c
> > @@ -807,7 +807,6 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
> >  	P_SIGNUM(PIPE);
> >  	P_SIGNUM(ALRM);
> >  	P_SIGNUM(TERM);
> > -	P_SIGNUM(STKFLT);
> >  	P_SIGNUM(CHLD);
> >  	P_SIGNUM(CONT);
> >  	P_SIGNUM(STOP);
> > @@ -823,6 +822,15 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
> >  	P_SIGNUM(IO);
> >  	P_SIGNUM(PWR);
> >  	P_SIGNUM(SYS);
> > +#ifdef SIGEMT
> > +	P_SIGNUM(EMT);
> > +#endif
> > +#ifdef SIGSTKFLT
> > +	P_SIGNUM(STKFLT);
> > +#endif
> > +#ifdef SIGSWI
> > +	P_SIGNUM(SWI);
> > +#endif
> >  	default: break;
> >  	}
> >  
> > 
> 
> -- 
> Ben Hutchings
> I say we take off; nuke the site from orbit.  It's the only way to be sure.


