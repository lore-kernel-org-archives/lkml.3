Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015Ab3DBIkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101Ab3DBIke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:40:34 -0400
Date: Tue, 2 Apr 2013 10:40:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 6/9] perf sort: Add 'addr' sort key
Message-ID: <20130402084014.GA26618@krava.redhat.com>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
 <1364816125-12212-7-git-send-email-namhyung@kernel.org>
 <20130401204022.GB1022@krava.redhat.com>
 <87wqslfzk4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqslfzk4.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:15:23AM +0900, Namhyung Kim wrote:
> On Mon, 1 Apr 2013 22:40:23 +0200, Jiri Olsa wrote:
> > On Mon, Apr 01, 2013 at 08:35:22PM +0900, Namhyung Kim wrote:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >> 
> >> New addr sort key provides a way to sort the entries by the symbol
> >> addresses.  It can be helpful to figure out symbol resolution problem
> >> when a dso cannot do it properly as well as finding hotpath in a dso
> >> and/or a function.
> >
> > maybe it's just the recent mem profiling patches, but wouldn't
> > it be better to use 'ip' instead of 'addr'?
> >
> > also it's following code getting the data:
> > ...
> >         if (sample_type & PERF_SAMPLE_IP)
> >                 data->ip = perf_instruction_pointer(regs);
> > ...
> >
> > same for the "perf sort: Add 'addr_to/from' sort key" patch
> 
> I'm not sure I understand what you mean exactly.
> 
> I used hist_entry->ip but it was set by al->addr which was converted
> from the original sample ip to a relative ip by map->map_ip().
> 
> I can change it to use ->unmap_ip() before printing.  Is that your
> concern?

what I meant was the 'addr' name itself for -s option, like use:
  '-s ip' instead of '-s addr'

I'm fine with the implementation

jirka

> 
> And it seems that addr in branch info is original ip, Stephane?
> 
> Thanks,
> Namhyung
