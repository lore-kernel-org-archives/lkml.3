Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3LCFoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:44:21 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65529 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3LCFoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:44:17 -0500
X-AuditID: 9c93017d-b7bb3ae0000068fd-32-529d6faf76fd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
	<1385967199-3759-2-git-send-email-namhyung@kernel.org>
	<20131202124527.GB22212@gmail.com> <20131202125709.GA22404@gmail.com>
	<1385999009.1710.72.camel@leonhard> <20131202163620.GC27781@gmail.com>
	<20131202202459.GF17149@ghostprotocols.net>
Date: Tue, 03 Dec 2013 14:44:15 +0900
In-Reply-To: <20131202202459.GF17149@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 2 Dec 2013 17:24:59 -0300")
Message-ID: <87y542mqts.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013 17:24:59 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 02, 2013 at 05:36:20PM +0100, Ingo Molnar escreveu:
>> * Namhyung Kim <namhyung@kernel.org> wrote:
>> > 2013-12-02 (월), 13:57 +0100, Ingo Molnar:
>> > > So basically, in the end I think it should be possible to have the 
>> > > following behavior:
>
>> > >    perf record -a -e cycles sleep 1
>
>> > >    perf report stat              # Reports as if we ran: 'perf stat -a -e cycles sleep 1'
>> > >    perf report                   # Reports the usual histogram
>
>> > >    perf report --stat            # Reports the perf stat output and the histogram
>
>> > > or so.
>
>> > I don't think we need both of 'perf report stat' and 'perf report
>> > --stat'.  At least it looks somewhat confusing to users IMHO.
>  
>> Okay. Maybe the --stat option would be the more logical choice, 
>> because '--' options can be added arbitrarily, while it would be weird 
>> to add multiple subcommand options.
>  
>> So basically there would be two options:
>  
>>    --show-stat         [--no-show-stat]
>>    --show-histogram    [--no-show-histogram]
>  
>> Today --show-histogram is the only one enabled by default.
>  
>> Running:
>  
>>    perf report --no-show-histogram --show-stat
>
> Why not:
>
> perf stat -i perf.data
>
> and make it be an optional argument, so plain:
>
> perf stat -i
>
> would process perf.data, i.e. would get the samples, accrue the periods,
> calculate the time, etc and then present it as 'perf stat <some
> target>'.

Yeah, actually this came into my head too.  But how about just making
"perf stat" read from perf.data and print output - I mean without the -i
option like other commands do.  Currently perf stat doesn't allow no
argument given it won't confuse existing users.

It should produce same output as Ingo suggested with "perf report
--show-stat --no-show-histogram".

>
> Right now 'perf stat -i' i used for '--no-inherit', perhaps we can just
> have --no-inherit have no short option and grab -i to have the same
> meaning as in 'report', 'script', etc.

Agreed.  Maybe we could change it to plain --inherit.

Thanks,
Namhyung
