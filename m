Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaB1W3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:29:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbaB1W3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:29:46 -0500
Message-ID: <53110DAB.2010908@redhat.com>
Date: Fri, 28 Feb 2014 17:28:59 -0500
From: Joe Mario <jmario@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>  <1393609388-40489-9-git-send-email-dzickus@redhat.com>  <87lhwvawc4.fsf@tassilo.jf.intel.com> <20140228194642.GM25953@redhat.com> <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the resend.  My first msg contained html in it.

On 02/28/2014 04:03 PM, Davidlohr Bueso wrote:
> On Fri, 2014-02-28 at 14:46 -0500, Don Zickus wrote:
>> On Fri, Feb 28, 2014 at 11:08:59AM -0800, Andi Kleen wrote:
>>> Don Zickus <dzickus@redhat.com> writes:
>>>> +
>>>> +static const struct perf_evsel_str_handler handlers[] = {
>>>> +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
>>>> +	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
>>>
>
> Hmm I'm getting this when running a simple record command.
>
> invalid or unsupported event: 'cpu/mem-loads/pp'
>
> This only occurs with c2c, other subcommands work normally. It's as if
> it were an old kernel, but it's Linus' latest. Is this an issue with the
> patch or something I'm missing?
>
> Furthermore, I see:
> ls /sys/bus/event_source/devices/cpu/events
> branch-instructions  branch-misses  cache-misses  cache-references  cpu-cycles  instructions  mem-loads

David:
  It looks like you're running on an older Intel processor, which is missing necessary events for C2C to work.
  As Don noted in his patch 00/19, this was primarily developed and tested on Intel's Ivy Bridge platform.
  If you rerun this on an Ivy Bridge, it should work fine.
  We should add a runtime check for supported platforms.
Joe

> Thanks!
>
>
>

