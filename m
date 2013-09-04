Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236Ab3IDICD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:02:03 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52721 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762034Ab3IDICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:02:01 -0400
Message-ID: <5226E8F4.5060505@hitachi.com>
Date: Wed, 04 Sep 2013 17:01:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora> <87ioyht7e4.fsf@sejong.aot.lge.com>
In-Reply-To: <87ioyht7e4.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/04 15:42), Namhyung Kim wrote:
> On Tue, 03 Sep 2013 13:06:55 +0530, Hemant Kumar wrote:
> 
> [SNIP]
> 
>> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
>> index e8a66f9..3d8dcdf 100644
>> --- a/tools/perf/builtin-probe.c
>> +++ b/tools/perf/builtin-probe.c
>> @@ -55,6 +55,7 @@ static struct {
>>  	bool show_funcs;
>>  	bool mod_events;
>>  	bool uprobes;
>> +	bool sdt;
>>  	int nevents;
>>  	struct perf_probe_event events[MAX_PROBES];
>>  	struct strlist *dellist;
>> @@ -325,6 +326,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>>  		     opt_set_filter),
>>  	OPT_CALLBACK('x', "exec", NULL, "executable|path",
>>  			"target executable name or path", opt_set_target),
>> +	OPT_BOOLEAN('S', "sdt", &params.sdt,
>> +		    "Show and probe on the SDT markers"),
> 
> You need to add it to Documentation/perf-probe.txt too.  In addition if
> the --sdt option is only able to work with libelf, it should be wrapped
> into the #ifdef LIBELF_SUPPORT pair.
> 
> And I'm not sure that it's a good idea to have two behavior on a single
> option (S) - show and probe (add).  Maybe it can be separated into two
> or the S option can be used as a flag with existing --list and --add
> option?
> 

Good catch! :)
No, that is really bad idea. All probes must be added by "--add" action.
So we need a new probe syntax for specifying sdt marker.

How about the below syntax?

[EVENT=]%PROVIDER:MARKER [ARG ...]

Of course, this will require to list up all markers with "%" prefix for
continuity.

And since --list option is to list up all existing(defined) probe events,
I think --markers (as like as --funcs) is better for listing it up.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


