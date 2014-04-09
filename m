Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaDIBMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:12:35 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50096 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbaDIBMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:12:34 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 05/15 V3] perf, c2c: Rework setup code to prepare for features
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-6-git-send-email-dzickus@redhat.com>
	<20140329171018.GA2022@krava.redhat.com>
	<87ob0cw9na.fsf@sejong.aot.lge.com> <20140408141107.GT8488@redhat.com>
Date: Wed, 09 Apr 2014 10:12:32 +0900
In-Reply-To: <20140408141107.GT8488@redhat.com> (Don Zickus's message of "Tue,
	8 Apr 2014 10:11:07 -0400")
Message-ID: <87eh17uwzj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 10:11:07 -0400, Don Zickus wrote:
> On Tue, Apr 08, 2014 at 04:41:29PM +0900, Namhyung Kim wrote:
>> On Sat, 29 Mar 2014 18:10:18 +0100, Jiri Olsa wrote:
>> > On Mon, Mar 24, 2014 at 03:36:56PM -0400, Don Zickus wrote:
>> >
>> > SNIP
>> >
>> >>  
>> >>  static int perf_c2c__process_load_store(struct perf_c2c *c2c,
>> >> +					struct addr_location *al,
>> >>  					struct perf_sample *sample,
>> >> -					struct addr_location *al)
>> >> +					struct perf_evsel *evsel)
>> >>  {
>> >> -	if (c2c->raw_records)
>> >> -		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
>> >> +	struct mem_info *mi;
>> >> +
>> >> +	mi = sample__resolve_mem(sample, al);
>> >> +	if (!mi)
>> >> +		return -ENOMEM;
>> >
>> > perhaps not directly related to this patchset, but I needed
>> > attached patch to get resolved data in .bss (static), which
>> > for some reason happened to be located in executable segment
>> 
>> Wasn't it a read-only/const data?
>
> I believe it had the 'x' bit set.  Or the kernel was not passing any
> protection bits, so it defaulted to MAP_FUNCTION?

The perf treats a mapping as a data mapping (MAP_VARIABLE) by default if
the 'x' bit is not set.  As Jiri said its a static data, I guessed it's
a const data (set to 0?) and moved into .rodata section and then to the
text segment.

Thanks,
Namhyung
