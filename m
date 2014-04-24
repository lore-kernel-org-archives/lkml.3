Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaDXNls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:41:48 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36473 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaDXNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:41:46 -0400
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying
 output fields (v4)
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20140423125828.GL5328@redhat.com>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
	 <20140422211647.GO8488@redhat.com> <87lhuwr2pk.fsf@sejong.aot.lge.com>
	 <20140423125828.GL5328@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 22:41:39 +0900
Message-ID: <1398346899.1681.18.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

2014-04-23 (수), 08:58 -0400, Don Zickus:
> On Wed, Apr 23, 2014 at 03:15:35PM +0900, Namhyung Kim wrote:
> > On Tue, 22 Apr 2014 17:16:47 -0400, Don Zickus wrote:
> > > ./perf mem record -a grep -r foo /* > /dev/null
> > > ./perf mem report -F overhead,symbol_daddr,pid -s symbol_daddr,pid --stdio 
> > >
> > > I was thinking I could sort everything based on the symbol_daddr and pid.
> > > Then re-sort the output to display the highest 'symbol_daddr,pid' pair.
> > > But it didn't seem to work that way.  Instead it seems like I get the
> > > original sort just displayed in the -F format.
> > 
> > Could you please show me the output of your example?
> 
> 
> # To display the perf.data header info, please use --header/--header-only
> # options.
> #
> # Samples: 96K of event 'cpu/mem-loads/pp'
> # Total weight : 1102938
> # Sort order   : symbol_daddr,pid
> #
> # Overhead Data Symbol          Command:  Pid
> # ........ ......................................................................
> #
>      0.00%  [k] 0xffff8807a8c1cf80 grep:116437
>      0.00%  [k] 0xffff8807a8c8cee0 grep:116437
>      0.00%  [k] 0xffff8807a8dceea0 grep:116437
>      0.01%  [k] 0xffff8807a9298dc0 grep:116437
>      0.01%  [k] 0xffff8807a934be40 grep:116437
>      0.00%  [k] 0xffff8807a9416ec0 grep:116437
>      0.02%  [k] 0xffff8807a9735700 grep:116437
>      0.00%  [k] 0xffff8807a98e9460 grep:116437
>      0.02%  [k] 0xffff8807a9afc890 grep:116437
>      0.00%  [k] 0xffff8807aa64feb0 grep:116437
>      0.02%  [k] 0xffff8807aa6b0030 grep:116437

Hmm.. it seems that it's exactly sorted by the data symbol addresses, so
I don't see any problem here.  What did you expect?  If you want to see
those symbol_daddr,pid pair to be sorted by overhead, you can use the
one of -F or -s option only.

IOW, "perf mem report -F overhead,symbol_daddr,pid" and "perf mem report
-s symbol_daddr,pid" should show same result.  FYI but "perf mem report
-F overhead,symbol_daddr,pid -s symbol_addr,pid" will be different.

It's due to a compatibility reason.  If -s option is used without -F
option, it'll prepend 'overhead' sort key to preserve old behavior (adds
the fields to output but sort by overhead only).

Thanks,
Namhyung


