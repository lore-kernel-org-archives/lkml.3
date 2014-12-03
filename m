Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaLCNiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:38:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbaLCNit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:38:49 -0500
Date: Wed, 3 Dec 2014 14:38:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 0/8] perf buildid-cache: Add clean command
Message-ID: <20141203133826.GB29325@krava.brq.redhat.com>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
 <20141201222919.GC6774@redhat.com>
 <20141202122518.GA7744@krava.brq.redhat.com>
 <20141202141028.GD6774@redhat.com>
 <CAM9d7cihz5Ywf_129=sm0EOpwRQBdoDA9sHn+TA0EfmhTU1Tmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cihz5Ywf_129=sm0EOpwRQBdoDA9sHn+TA0EfmhTU1Tmw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:13:06PM +0900, Namhyung Kim wrote:
> Hi Arnaldo and Jiri,
> 
> On Tue, Dec 2, 2014 at 11:10 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Tue, Dec 02, 2014 at 01:25:18PM +0100, Jiri Olsa escreveu:
> >> On Mon, Dec 01, 2014 at 08:29:19PM -0200, Arnaldo Carvalho de Melo wrote:
> >
> >> SNIP
> >
> >> > [acme@sandy wb]$
> >
> >> > If we keep the way it is, I think it would be clearer to add a -l/--list
> >> > command and that would:
> >
> >> >   perf buildid-cache --list  # list all the files in the cache
> >> >   perf buildid-cache --list 3d  # list 3 days old files
> >> >   perf buildid-cache --list +3d  # list files 3 days or more older
> >> >   perf buildid-cache --list -3d  # list files up to 3 days old
> >
> >> ok, I was up to old files (and big files) removal only.. not sure
> >> the other way will be actually needed.. but it's easy enought to
> >> add
> >
> > Right, I was thinking something along the lines of checking how much
> > space would be needed if I wanted to keep X days of cache, not how much
> > space I would free if I purged files older than Y days.
> 
> Btw, which timestamp do you use for the checking?  It'd be great if we
> can use atime but some system might use the noatime..

I used atime.. will need to check, I wasnt aware of this

SNIP

> >
> >> >
> >> > > Remove and display items bigger than 200M
> >> > >   $ perf buildid-cache clean -r -a 200M
> >
> >> > But yeah, perhaps we could switch to having subcommands and add:
> >
> >> >   perf buildid-cache [add|remove|update|list]
> >
> >> > What do you think?
> >
> >> yep, those commands seem nicer..
> >
> >> let's see of there're other comments and I'll come up with
> >> new interface after..
> 
> I also like the subcommand style..  What about git-like format to
> specify time range?
> 
> perf buildid-cache list --since '3 days ago'
> perf buildidi-cache remove --before '1 month ago'

yea, thats more readable, I'll check git sources.. hopefully they use
this in some steal-able way ;-)

jirka
