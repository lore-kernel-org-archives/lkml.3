Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaKJGgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:36:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39650 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKJGgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:49 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/3] perf symbol: Implement a very simple ELF symbol parser
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
	<1415337606-2186-2-git-send-email-namhyung@kernel.org>
	<20141107152618.GM18464@kernel.org>
Date: Mon, 10 Nov 2014 15:36:48 +0900
In-Reply-To: <20141107152618.GM18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 7 Nov 2014 12:26:18 -0300")
Message-ID: <87ioinv9xb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 7 Nov 2014 12:26:18 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 07, 2014 at 02:20:05PM +0900, Namhyung Kim escreveu:
>> It'll be used to show (userspace) symbol names when libelf isn't (or
>> cannot be) linked.
>
> Does this deals with prelink, etc?

I believe so. :)

>  
>>   # Overhead  Command     Shared Object      Symbol
>>   # ........  ..........  .................  .........................
>>   #
>>       37.01%  mem-memcpy  libc-2.17.so       [.] __memcpy_ssse3_back

  namhyung@sejong:linux$ readelf -WS /lib64/libc-2.17.so | grep prelink
    [41] .gnu.prelink_undo PROGBITS        0000000000000000 200368 000c30 01      0   0  8

  namhyung@sejong:linux$ nm /lib64/libc-2.17.so | grep __memcpy_ssse3_back
  0000003153f46f40 t __memcpy_ssse3_back


Thanks,
Namhyung


>>       24.25%  perf        ld-2.17.so         [.] _dl_relocate_object
>>       22.16%  perf        [kernel.kallsyms]  [k] kmem_cache_alloc
>>       14.29%  mem-memset  libc-2.17.so       [.] __memset_sse2
>>        2.21%  perf        [kernel.kallsyms]  [k] flush_signal_handlers
>>        0.07%  perf        [kernel.kallsyms]  [k] intel_pmu_enable_all
