Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaAOCS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:18:28 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43344 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:18:25 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-6b-52d5efefe3cb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/5] perf report: Add --percentage option
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
	<1389674599-28227-4-git-send-email-namhyung@kernel.org>
	<87zjmy2ryj.fsf@tassilo.jf.intel.com>
	<20140114212555.GE29798@ghostprotocols.net>
Date: Wed, 15 Jan 2014 11:18:23 +0900
In-Reply-To: <20140114212555.GE29798@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 14 Jan 2014 18:25:55 -0300")
Message-ID: <87ob3e9eds.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 18:25:55 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 14, 2014 at 01:07:00PM -0800, Andi Kleen escreveu:
>> Namhyung Kim <namhyung@kernel.org> writes:
>> >  
>> > +--percentage::
>> > +	Determine how to display the overhead percentage of filtered
>> > entries.
>> 
>> This should describe also what a "filtered entry" exactly is. It's not clear
>> even to me.
>
> Yeah, the text should give some context, mentioning the "Zoom"
> operations that can be done in the TUI (DSO, thread, etc) that allows
> applying what he is calling "filters".`

Ah, okay.

How about this:


-c::
--comms=::
	Only consider symbols in these comms. CSV that understands
	file://filename entries.  This option will affect the percentage of
	overhead column.  See --percentage for more info.
-d::
--dsos=::
	Only consider symbols in these dsos. CSV that understands
	file://filename entries.  This option will affect the percentage of
	overhead column.  See --percentage for more info.
-S::
--symbols=::
	Only consider these symbols. CSV that understands
	file://filename entries.  This option will affect the percentage of
	overhead column.  See --percentage for more info.

--percentage::
	Determine how to display the overhead percentage of filtered entries.
	Filters can be applied by --comms, --dsos and/or --symbols options and
	Zoom operations on the TUI (thread, dso, etc).

	"relative" means it's relative to filtered entries only so that the
	sum of shown entries will be always 100%.  "absolute" means it retains
	original value before and after the filter applied.


Thanks,
Namhyung
