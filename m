Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaDHHhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:37:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54940 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaDHHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:37:19 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 06/15 V3] perf, c2c: Add in new options to configure latency and stores
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-7-git-send-email-dzickus@redhat.com>
	<20140329171138.GF2022@krava.redhat.com>
	<20140401025535.GT25953@redhat.com>
	<20140406131422.GL1164@krava.brq.redhat.com>
Date: Tue, 08 Apr 2014 16:37:12 +0900
In-Reply-To: <20140406131422.GL1164@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 6 Apr 2014 15:14:22 +0200")
Message-ID: <87sipow9uf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, 6 Apr 2014 15:14:22 +0200, Jiri Olsa wrote:
> On Mon, Mar 31, 2014 at 10:55:35PM -0400, Don Zickus wrote:
>> On Sat, Mar 29, 2014 at 06:11:38PM +0100, Jiri Olsa wrote:
>> > On Mon, Mar 24, 2014 at 03:36:57PM -0400, Don Zickus wrote:
>> > > Modified the code to allow latency settings to be tweaked on the command line
>> > > and also the ability to dynamically profile stores (or disable using stores).
>> > > 
>> > > This allows the tool to be used on older Intel platforms like Westmere.
>> > > 
>> > > Signed-off-by: Don Zickus <dzickus@redhat.com>
>> > > ---
>> > 
>> > SNIP
>> > 
>> > > @@ -316,6 +369,12 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
>> > >  	};
>> > >  	const struct option c2c_options[] = {
>> > >  	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
>> > > +	OPT_INTEGER('l', "latency-level", &lat_level,
>> > > +		 "specify the latency threshold for loads [default=30]"),
>> > > +	OPT_INTEGER('p', "precision-level", &prec_level,
>> > > +		 "specify the precision level of events (0,1,2,3) [default=1]"),
>> > 
>> > could we get also option for user space modifier?
>> 
>> You mean the 'u' modifier, ie cpu/mem-loads/u ?  If so, then I can do that
>> but will that work with the -a option (which is hardcoded in the c2c
>> tool [system-wide mode])?
>
> right, forgot about that.. 

Why?  I think the -a option behavior is orthogonal to the user/kernel
modifier behavior, no?  Do the mem-loads/stores events have any
restriction on that?


> could the -a option be optional as well?
> probably the same way as for record would be the best:
>
>   perf c2c record ./foo       # workload specific
>   perf c2c record -a sleep 3  # system wide

Agreed.

Thanks,
Namhyung
