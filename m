Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbaLBMZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:25:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaLBMZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:25:38 -0500
Date: Tue, 2 Dec 2014 13:25:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/8] perf buildid-cache: Add clean command
Message-ID: <20141202122518.GA7744@krava.brq.redhat.com>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
 <20141201222919.GC6774@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201222919.GC6774@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 08:29:19PM -0200, Arnaldo Carvalho de Melo wrote:

SNIP

> [acme@sandy wb]$ 
> 
> If we keep the way it is, I think it would be clearer to add a -l/--list
> command and that would:
> 
>   perf buildid-cache --list  # list all the files in the cache
>   perf buildid-cache --list 3d  # list 3 days old files
>   perf buildid-cache --list +3d  # list files 3 days or more older
>   perf buildid-cache --list -3d  # list files up to 3 days old

ok, I was up to old files (and big files) removal only.. not sure
the other way will be actually needed.. but it's easy enought to
add

> 
> And all these would print the sum of the matching files, i.e. the space
> those files use in the filesystem.
>  
> > Remove cache files older than 3 days:
> >   $ perf buildid-cache clean 3d -r
> 
>   perf buildid-cache --remove [-+]Nd # Same semantics as above
> 
> >     
> > Total cache removal:
> >   $ perf buildid-cache clean -r
> 
>  perf buildid-cache --remove '*'

hum, maybe '--removal all' might be better

>  
> > Remove and display items bigger than 200M
> >   $ perf buildid-cache clean -r -a 200M
> 
> But yeah, perhaps we could switch to having subcommands and add:
> 
>   perf buildid-cache [add|remove|update|list]
> 
> What do you think?

yep, those commands seem nicer.. 

let's see of there're other comments and I'll come up with
new interface after..

thanks,
jirka
