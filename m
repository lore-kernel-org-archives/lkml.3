Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbaIOT5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbaIOT5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:57:16 -0400
Date: Mon, 15 Sep 2014 16:57:02 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Anton Blanchard <anton@samba.org>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf symbols: Add path to Ubuntu kernel debuginfo file
Message-ID: <20140915195702.GG2259@redhat.com>
References: <20140909091152.2698c0f7@kryten>
 <87d2b1mj8v.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2b1mj8v.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 03:43:28PM +0900, Namhyung Kim escreveu:
> On Tue, 9 Sep 2014 09:11:52 +1000, Anton Blanchard wrote:
> > Ubuntu places the kernel debuginfo in /usr/lib/debug/boot/vmlinux-*
> >
> > Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> It seems that you need to rebase it onto current acme/perf/core as
> there're little change in this area.  The patch itself looks good to me.

I updated the patch, to make it use the kernel_version from the
perf.data file if present, else it uses uts.release as in Anton's patch,
ok?

- Arnaldo
 
> Thanks,
> Namhyung
> 
> 
> > ---
> >
> > Index: b/tools/perf/util/symbol.c
> > ===================================================================
> > --- a/tools/perf/util/symbol.c
> > +++ b/tools/perf/util/symbol.c
> > @@ -1750,7 +1750,7 @@ static int vmlinux_path__init(void)
> >  	struct utsname uts;
> >  	char bf[PATH_MAX];
> >  
> > -	vmlinux_path = malloc(sizeof(char *) * 5);
> > +	vmlinux_path = malloc(sizeof(char *) * 6);
> >  	if (vmlinux_path == NULL)
> >  		return -1;
> >  
> > @@ -1784,6 +1784,12 @@ static int vmlinux_path__init(void)
> >  		 uts.release);
> >  	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
> >  	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
> > +		goto out_fail;
> > +	++vmlinux_path__nr_entries;
> > +	snprintf(bf, sizeof(bf), "/usr/lib/debug/boot/vmlinux-%s",
> > +		 uts.release);
> > +	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
> > +	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
> >  		goto out_fail;
> >  	++vmlinux_path__nr_entries;
> >  
