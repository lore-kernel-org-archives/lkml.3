Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaDXVBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbaDXVBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:01:14 -0400
Date: Thu, 24 Apr 2014 17:00:15 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying
 output fields (v4)
Message-ID: <20140424210015.GJ8488@redhat.com>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
 <20140422211647.GO8488@redhat.com>
 <87lhuwr2pk.fsf@sejong.aot.lge.com>
 <20140423125828.GL5328@redhat.com>
 <1398346899.1681.18.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398346899.1681.18.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:41:39PM +0900, Namhyung Kim wrote:
> Hi Don,
> 
> 2014-04-23 (수), 08:58 -0400, Don Zickus:
> > On Wed, Apr 23, 2014 at 03:15:35PM +0900, Namhyung Kim wrote:
> > > On Tue, 22 Apr 2014 17:16:47 -0400, Don Zickus wrote:
> > > > ./perf mem record -a grep -r foo /* > /dev/null
> > > > ./perf mem report -F overhead,symbol_daddr,pid -s symbol_daddr,pid --stdio 
> > > >
> > > > I was thinking I could sort everything based on the symbol_daddr and pid.
> > > > Then re-sort the output to display the highest 'symbol_daddr,pid' pair.
> > > > But it didn't seem to work that way.  Instead it seems like I get the
> > > > original sort just displayed in the -F format.
> > > 
> > > Could you please show me the output of your example?
> > 
> > 
> > # To display the perf.data header info, please use --header/--header-only
> > # options.
> > #
> > # Samples: 96K of event 'cpu/mem-loads/pp'
> > # Total weight : 1102938
> > # Sort order   : symbol_daddr,pid
> > #
> > # Overhead Data Symbol          Command:  Pid
> > # ........ ......................................................................
> > #
> >      0.00%  [k] 0xffff8807a8c1cf80 grep:116437
> >      0.00%  [k] 0xffff8807a8c8cee0 grep:116437
> >      0.00%  [k] 0xffff8807a8dceea0 grep:116437
> >      0.01%  [k] 0xffff8807a9298dc0 grep:116437
> >      0.01%  [k] 0xffff8807a934be40 grep:116437
> >      0.00%  [k] 0xffff8807a9416ec0 grep:116437
> >      0.02%  [k] 0xffff8807a9735700 grep:116437
> >      0.00%  [k] 0xffff8807a98e9460 grep:116437
> >      0.02%  [k] 0xffff8807a9afc890 grep:116437
> >      0.00%  [k] 0xffff8807aa64feb0 grep:116437
> >      0.02%  [k] 0xffff8807aa6b0030 grep:116437
> 
> Hmm.. it seems that it's exactly sorted by the data symbol addresses, so
> I don't see any problem here.  What did you expect?  If you want to see
> those symbol_daddr,pid pair to be sorted by overhead, you can use the
> one of -F or -s option only.

Good question.  I guess I was hoping to see things sorted by overhead, but
as you said removing all the -F options gives me that.  I have been
distracted with other fires this week, I lost focus at what I was trying
to accomplish.

Let me figure that out again and try to come up with a more clear email
explaining what I was looking for (for myself at least :-) ).

Sorry for the distraction.

Cheers,
Don
