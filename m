Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab3DBCP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:15:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62744 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab3DBCP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:15:26 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-6b-515a3f3be4be
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 6/9] perf sort: Add 'addr' sort key
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
	<1364816125-12212-7-git-send-email-namhyung@kernel.org>
	<20130401204022.GB1022@krava.redhat.com>
Date: Tue, 02 Apr 2013 11:15:23 +0900
In-Reply-To: <20130401204022.GB1022@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 1 Apr 2013 22:40:23 +0200")
Message-ID: <87wqslfzk4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Apr 2013 22:40:23 +0200, Jiri Olsa wrote:
> On Mon, Apr 01, 2013 at 08:35:22PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> New addr sort key provides a way to sort the entries by the symbol
>> addresses.  It can be helpful to figure out symbol resolution problem
>> when a dso cannot do it properly as well as finding hotpath in a dso
>> and/or a function.
>
> maybe it's just the recent mem profiling patches, but wouldn't
> it be better to use 'ip' instead of 'addr'?
>
> also it's following code getting the data:
> ...
>         if (sample_type & PERF_SAMPLE_IP)
>                 data->ip = perf_instruction_pointer(regs);
> ...
>
> same for the "perf sort: Add 'addr_to/from' sort key" patch

I'm not sure I understand what you mean exactly.

I used hist_entry->ip but it was set by al->addr which was converted
from the original sample ip to a relative ip by map->map_ip().

I can change it to use ->unmap_ip() before printing.  Is that your
concern?

And it seems that addr in branch info is original ip, Stephane?

Thanks,
Namhyung
