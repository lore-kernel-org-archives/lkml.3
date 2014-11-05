Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaKEGJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:09:44 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47361 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaKEGJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:09:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, srikar@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
	<87389z7j3x.fsf@sejong.aot.lge.com> <545867BC.9070000@hitachi.com>
Date: Wed, 05 Nov 2014 15:09:32 +0900
In-Reply-To: <545867BC.9070000@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 04 Nov 2014 14:44:28 +0900")
Message-ID: <87lhnqw543.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Tue, 04 Nov 2014 14:44:28 +0900, Masami Hiramatsu wrote:
> (2014/11/04 12:14), Namhyung Kim wrote:
>> Hi Masami,
>> 
>> On Fri, 31 Oct 2014 14:51:29 -0400, Masami Hiramatsu wrote:
>>> So by using all of them, we can make an "event cache" file on all
>>> functions (except for inlined functions) as below.
>>>
>>>   # perf probe --max-probes=100000 --no-inlines -a '* $params' -o event.cache
>>>
>>> builds "event.cache" file in which event settings for
>>> all function entries, like below;
>>>
>>>   p:probe/reset_early_page_tables _text+12980741
>>>   p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
>>>   p:probe/exit_amd_microcode _text+14692680
>>>   p:probe/early_make_pgtable _text+12981274 address=%di:u64
>>>   p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
>>>   p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
>>>   p:probe/reserve_ebda_region _text+12982117
>> 
>> Does this event cache support kernel modules too?  AFAIK it can have a
>> different address whenever loaded even on a same kernel.
>
> Yes, for the modules perf probe uses target function symbol directly instead
> of _text.
>
>  ----
>  perf probe -m xfs -o - -q -a xfs_acl_exists
>  p:probe/xfs_acl_exists xfs:xfs_acl_exists+0
>  ----

Ah, great! :)

Thanks,
Namhyung
