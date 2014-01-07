Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaAGOXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:23:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaAGOWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:22:47 -0500
Date: Tue, 7 Jan 2014 15:22:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 02/16] perf tools: Fix machine initialization
Message-ID: <20140107142225.GC2919@krava.brq.redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
 <1389098853-14466-3-git-send-email-jolsa@redhat.com>
 <20140107141400.GB3845@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107141400.GB3845@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:14:00AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 07, 2014 at 01:47:19PM +0100, Jiri Olsa escreveu:
> > The id_hdr_size field was not properly initialized,
> > setting it to zero.
> 
> Humm, is there any place where 'machine' doesn't come from calloc/zalloc?

machine__new_host, but I used machine allocated on stack
in the tests/dwarf-unwind.c and I thought this was the last
member not being initialized..

now I can see vmlinux_maps array does not get initialized as well..

jirka

> 
> - Arnaldo
>  
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Jean Pihet <jean.pihet@linaro.org>
> > ---
> >  tools/perf/util/machine.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index a98538d..0130279 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -27,6 +27,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
> >  	machine->pid = pid;
> >  
> >  	machine->symbol_filter = NULL;
> > +	machine->id_hdr_size = 0;
> >  
> >  	machine->root_dir = strdup(root_dir);
> >  	if (machine->root_dir == NULL)
> > -- 
> > 1.8.3.1
