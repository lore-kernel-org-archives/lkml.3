Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaDIARJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:17:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:36410 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaDIARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:17:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 06/15 V3] perf, c2c: Add in new options to configure latency and stores
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-7-git-send-email-dzickus@redhat.com>
	<20140329171138.GF2022@krava.redhat.com>
	<20140401025535.GT25953@redhat.com>
	<20140406131422.GL1164@krava.brq.redhat.com>
	<20140407181618.GD5328@redhat.com>
Date: Wed, 09 Apr 2014 09:17:04 +0900
In-Reply-To: <20140407181618.GD5328@redhat.com> (Don Zickus's message of "Mon,
	7 Apr 2014 14:16:18 -0400")
Message-ID: <87r457uzjz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014 14:16:18 -0400, Don Zickus wrote:
> On Sun, Apr 06, 2014 at 03:14:22PM +0200, Jiri Olsa wrote:
>> On Mon, Mar 31, 2014 at 10:55:35PM -0400, Don Zickus wrote:
>> > On Sat, Mar 29, 2014 at 06:11:38PM +0100, Jiri Olsa wrote:
>> > > > @@ -316,6 +369,12 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
>> > > >  	};
>> > > >  	const struct option c2c_options[] = {
>> > > >  	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
>> > > > +	OPT_INTEGER('l', "latency-level", &lat_level,
>> > > > +		 "specify the latency threshold for loads [default=30]"),
>> > > > +	OPT_INTEGER('p', "precision-level", &prec_level,
>> > > > +		 "specify the precision level of events (0,1,2,3) [default=1]"),
>> > > 
>> > > could we get also option for user space modifier?
>> > 
>> > You mean the 'u' modifier, ie cpu/mem-loads/u ?  If so, then I can do that
>> > but will that work with the -a option (which is hardcoded in the c2c
>> > tool [system-wide mode])?
>> 
>> right, forgot about that.. could the -a option be optional as well?
>> probably the same way as for record would be the best:
>> 
>>   perf c2c record ./foo       # workload specific
>>   perf c2c record -a sleep 3  # system wide
>
> I understand what you are saying, but our tool was written to find cache
> contention across the system, so -a is usually implied.  Most of our
> profiling is done system-wide.

Hmm.. any chance it can be used for non-system-wide analysis?  I think
tool should provide a way to do it if it's a valid usecase.  And adding
-a option when recording doesn't look too hard. :)


> I would rather implement the opposite option --no-system-wide, if that
> is ok.

Please just add -a/--system-wide (maybe use can make it default if no
argument/workload is given like perf top does) then tool will provide
the --no-* option automatically.

Thanks,
Namhyung
