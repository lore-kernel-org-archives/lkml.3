Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaDSWeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaDSWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:34:07 -0400
Date: Sun, 20 Apr 2014 00:33:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf test x86: Fit memory leak in sample_ustack()
Message-ID: <20140419223356.GB6234@krava.redhat.com>
References: <1397920601-27712-1-git-send-email-standby24x7@gmail.com>
 <20140419221913.GA6234@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419221913.GA6234@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 12:19:13AM +0200, Jiri Olsa wrote:
> On Sun, Apr 20, 2014 at 12:16:41AM +0900, Masanari Iida wrote:
> > buf is not freed, when kernel failed to get stack map
> > and return.
> > 
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/arch/x86/tests/dwarf-unwind.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
> > index b602ad9..68f2711 100644
> > --- a/tools/perf/arch/x86/tests/dwarf-unwind.c
> > +++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
> > @@ -26,6 +26,7 @@ static int sample_ustack(struct perf_sample *sample,
> >  	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
> >  	if (!map) {
> >  		pr_debug("failed to get stack map\n");
> > +		kfree(buf);

and changing this to free(buf) ;-)

jirka

> >  		return -1;
> >  	}
> >  
> > -- 
> > 1.9.2.468.g3f0c02a
> > 
