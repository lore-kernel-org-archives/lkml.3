Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbAZI5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbAZI5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:57:47 -0500
Date: Mon, 26 Jan 2015 09:57:37 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 5/5] perf: Make perf aware of tracefs
Message-ID: <20150126085737.GB13287@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
 <20150124181449.157590751@goodmis.org>
 <20150125173433.GA10390@krava.brq.redhat.com>
 <20150125143151.4c42c836@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125143151.4c42c836@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 02:31:51PM -0500, Steven Rostedt wrote:
> On Sun, 25 Jan 2015 18:34:33 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Sat, Jan 24, 2015 at 01:13:35PM -0500, Steven Rostedt wrote:
> > 
> > SNIP
> > 
> > > @@ -351,11 +385,15 @@ const char *find_tracing_dir(void)
> > >  	if (tracing_found)
> > >  		return tracing;
> > >  
> > > -	debugfs = find_debugfs();
> > > -	if (!debugfs)
> > > -		return NULL;
> > > +	debugfs = find_tracefs();
> > > +	if (!debugfs) {
> > > +		tracing_dir = "/tracing";
> > > +		debugfs = find_debugfs();
> > > +		if (!debugfs)
> > > +			return NULL;
> > 
> > so this pattern 'try tracefs, if that does not work try debugfs'
> > is all over the patch.. how about we add new new 'virtual' fs to
> > encapsulate that, like:
> > 
> >   with followign interface:
> >     bool tpfs_configured(void);
> >     const char *tpfs_find_mountpoint(void);
> >     int tpfs_valid_mountpoint(const char *debugfs);
> >     char *tpfs_mount(const char *mountpoint);
> >     extern char tpfs_mountpoint[];
> > 
> > It does not neceserily needs to reside in tools/lib/api/fs/tpfs.[ch],
> > but I believe we need some form of encapsulation for this.
> 
> I did it this way because perf had no encapsulation for finding debugfs
> paths. I made the change in trace-cmd in one location. Perf does it a
> little different in each place. I have no idea why there was more than
> one location slapping on "/tracing".
> 
> I'd like to get tracefs into perf before doing any redesign of perf's
> infrastructure. That could come later as a cleanup.
> 
> This is not a fast path, it wont hurt performance. I agree it should be
> encapsulated, but that's going outside of the scope of this patch
> series, which is only to add awareness to tracefs, not to clean up
> perf's access to the debugfs/tracing directory.

sure, np.. it could be taken care of later

jirka
