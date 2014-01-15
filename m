Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaAOSaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:30:17 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:36605 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaAOSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:30:12 -0500
Date: Wed, 15 Jan 2014 15:30:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/5] perf report: Add --percentage option
Message-ID: <20140115183003.GC9750@ghostprotocols.net>
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
 <1389674599-28227-4-git-send-email-namhyung@kernel.org>
 <87zjmy2ryj.fsf@tassilo.jf.intel.com>
 <20140114212555.GE29798@ghostprotocols.net>
 <87ob3e9eds.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob3e9eds.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 15, 2014 at 11:18:23AM +0900, Namhyung Kim escreveu:
> On Tue, 14 Jan 2014 18:25:55 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jan 14, 2014 at 01:07:00PM -0800, Andi Kleen escreveu:
> >> Namhyung Kim <namhyung@kernel.org> writes:
> >> >  
> >> > +--percentage::
> >> > +	Determine how to display the overhead percentage of filtered
> >> > entries.
> >> 
> >> This should describe also what a "filtered entry" exactly is. It's not clear
> >> even to me.
> >
> > Yeah, the text should give some context, mentioning the "Zoom"
> > operations that can be done in the TUI (DSO, thread, etc) that allows
> > applying what he is calling "filters".`
> 
> Ah, okay.
> 
> How about this:

Ack, much clearer, minor things below:
 
> 
> -c::
> --comms=::
> 	Only consider symbols in these comms. CSV that understands
> 	file://filename entries.  This option will affect the percentage of
> 	overhead column.  See --percentage for more info.
        the overhead column. ...
> -d::
> --dsos=::
> 	Only consider symbols in these dsos. CSV that understands
> 	file://filename entries.  This option will affect the percentage of
> 	overhead column.  See --percentage for more info.

ditto

> -S::
> --symbols=::
> 	Only consider these symbols. CSV that understands
> 	file://filename entries.  This option will affect the percentage of
> 	overhead column.  See --percentage for more info.

ditto

> 
> --percentage::
> 	Determine how to display the overhead percentage of filtered entries.
> 	Filters can be applied by --comms, --dsos and/or --symbols options and
> 	Zoom operations on the TUI (thread, dso, etc).
> 
> 	"relative" means it's relative to filtered entries only so that the
> 	sum of shown entries will be always 100%.  "absolute" means it retains
> 	original value before and after the filter applied.

Another missing 'the': "... retains the original value ..." plus a
missing 'is' just before 'applied'.

- Arnaldo
