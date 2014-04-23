Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaDWGPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:15:40 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:36435 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaDWGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:15:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying output fields (v4)
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
	<20140422211647.GO8488@redhat.com>
Date: Wed, 23 Apr 2014 15:15:35 +0900
In-Reply-To: <20140422211647.GO8488@redhat.com> (Don Zickus's message of "Tue,
	22 Apr 2014 17:16:47 -0400")
Message-ID: <87lhuwr2pk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Tue, 22 Apr 2014 17:16:47 -0400, Don Zickus wrote:
> On Wed, Apr 16, 2014 at 12:05:37PM +0900, Namhyung Kim wrote:
>> Hello,
>> 
>> This is a patchset implementing -F/--fields option to setup output
>> field/column as Ingo requested.  It depends on my --percentage
>> patchset [1].
>> 
>> The -F option can receive any sort keys that -s option recognize, plus
>> following fields (name can be changed):
>> 
>>   overhead, overhead_sys, overhead_us, sample, period
>> 
>> The overhead_guest_sys and overhead_guest_us might be avaiable when
>> you profile guest machines.
>> 
>> Output will be sorted by in order of fields and sort keys passed by -s
>> option will be added to the output field list automatically.  If you
>> want to change the order of sorting you can give -s option in addition
>> to -F option.  To support old behavior, it'll also prepend 'overhead'
>> field to the sort keys unless you give -F option explicitly.
>
> So I am struggling a little bit to get this working correctly.  I had it
> in my head that I could sort internally with -s and re-sort the output
> based on -F, but it doesn't seem to be working that way.

Hmm.. probably it's me miss something on perf mem side..  I don't have
an access to a machine to test it now.

>
> For example with
>
> ./perf mem record -a grep -r foo /* > /dev/null
> ./perf mem report -F overhead,symbol_daddr,pid -s symbol_daddr,pid --stdio 
>
> I was thinking I could sort everything based on the symbol_daddr and pid.
> Then re-sort the output to display the highest 'symbol_daddr,pid' pair.
> But it didn't seem to work that way.  Instead it seems like I get the
> original sort just displayed in the -F format.

Could you please show me the output of your example?

Thanks,
Namhyung
