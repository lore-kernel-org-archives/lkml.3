Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaDWM6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaDWM6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:58:54 -0400
Date: Wed, 23 Apr 2014 08:58:28 -0400
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
Message-ID: <20140423125828.GL5328@redhat.com>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
 <20140422211647.GO8488@redhat.com>
 <87lhuwr2pk.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhuwr2pk.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:15:35PM +0900, Namhyung Kim wrote:
> Hi Don,
> 
> On Tue, 22 Apr 2014 17:16:47 -0400, Don Zickus wrote:
> > On Wed, Apr 16, 2014 at 12:05:37PM +0900, Namhyung Kim wrote:
> >> Hello,
> >> 
> >> This is a patchset implementing -F/--fields option to setup output
> >> field/column as Ingo requested.  It depends on my --percentage
> >> patchset [1].
> >> 
> >> The -F option can receive any sort keys that -s option recognize, plus
> >> following fields (name can be changed):
> >> 
> >>   overhead, overhead_sys, overhead_us, sample, period
> >> 
> >> The overhead_guest_sys and overhead_guest_us might be avaiable when
> >> you profile guest machines.
> >> 
> >> Output will be sorted by in order of fields and sort keys passed by -s
> >> option will be added to the output field list automatically.  If you
> >> want to change the order of sorting you can give -s option in addition
> >> to -F option.  To support old behavior, it'll also prepend 'overhead'
> >> field to the sort keys unless you give -F option explicitly.
> >
> > So I am struggling a little bit to get this working correctly.  I had it
> > in my head that I could sort internally with -s and re-sort the output
> > based on -F, but it doesn't seem to be working that way.
> 
> Hmm.. probably it's me miss something on perf mem side..  I don't have
> an access to a machine to test it now.
> 
> >
> > For example with
> >
> > ./perf mem record -a grep -r foo /* > /dev/null
> > ./perf mem report -F overhead,symbol_daddr,pid -s symbol_daddr,pid --stdio 
> >
> > I was thinking I could sort everything based on the symbol_daddr and pid.
> > Then re-sort the output to display the highest 'symbol_daddr,pid' pair.
> > But it didn't seem to work that way.  Instead it seems like I get the
> > original sort just displayed in the -F format.
> 
> Could you please show me the output of your example?


# To display the perf.data header info, please use --header/--header-only
# options.
#
# Samples: 96K of event 'cpu/mem-loads/pp'
# Total weight : 1102938
# Sort order   : symbol_daddr,pid
#
# Overhead Data Symbol          Command:  Pid
# ........ ......................................................................
#
     0.00%  [k] 0xffff8807a8c1cf80 grep:116437
     0.00%  [k] 0xffff8807a8c8cee0 grep:116437
     0.00%  [k] 0xffff8807a8dceea0 grep:116437
     0.01%  [k] 0xffff8807a9298dc0 grep:116437
     0.01%  [k] 0xffff8807a934be40 grep:116437
     0.00%  [k] 0xffff8807a9416ec0 grep:116437
     0.02%  [k] 0xffff8807a9735700 grep:116437
     0.00%  [k] 0xffff8807a98e9460 grep:116437
     0.02%  [k] 0xffff8807a9afc890 grep:116437
     0.00%  [k] 0xffff8807aa64feb0 grep:116437
     0.02%  [k] 0xffff8807aa6b0030 grep:116437

Cheers,
Don
