Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3AWViG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:38:06 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38994 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3AWVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130123042714.GD2723@blaptop>
References: <1358848018-3679-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<20130123042714.GD2723@blaptop>
Date: Wed, 23 Jan 2013 18:37:56 -0300
Message-ID: <CALF0-+V6D1Ka9SNyrgRAgTSGLUTp_9y4vYwauSx1qCfU-JOwjA@mail.gmail.com>
Subject: Re: [RFC/PATCH] scripts/tracing: Add trace_analyze.py tool
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Wed, Jan 23, 2013 at 1:27 AM, Minchan Kim <minchan@kernel.org> wrote:
> Hi Ezequiel,
>
> On Tue, Jan 22, 2013 at 06:46:58AM -0300, Ezequiel Garcia wrote:
>> From: Ezequiel Garcia <elezegarcia@gmail.com>
>>
>> The purpose of trace_analyze.py tool is to perform static
>> and dynamic memory analysis using a kmem ftrace
>> log file and a built kernel tree.
>>
>> This script and related work has been done on the CEWG/2012 project:
>> "Kernel dynamic memory allocation tracking and reduction"
>> (More info here [1])
>>
>> It produces mainly two kinds of outputs:
>>  * an account-like output, similar to the one given by Perf, example below.
>>  * a ring-char output, examples here [2].
>>
>> $ ./scripts/tracing/trace_analyze.py -k linux -f kmem.log --account-file account.txt
>> $ ./scripts/tracing/trace_analyze.py -k linux -f kmem.log -c account.txt
>>
>> This will produce an account file like this:
>>
>>     current bytes allocated:     669696
>>     current bytes requested:     618823
>>     current wasted bytes:         50873
>>     number of allocs:              7649
>>     number of frees:               2563
>>     number of callers:              115
>>
>>      total    waste      net alloc/free  caller
>>     ---------------------------------------------
>>     299200        0   298928  1100/1     alloc_inode+0x4fL
>>     189824        0   140544  1483/385   __d_alloc+0x22L
>>      51904        0    47552   811/68    sysfs_new_dirent+0x4eL
>>     [...]
>>
>> [1] http://elinux.org/Kernel_dynamic_memory_analysis
>> [2] http://elinux.org/Kernel_dynamic_memory_analysis#Current_dynamic_footprint
>
> First of all, Thanks for nice work! It could be very useful for
> embedded side.
>
> Questions.
>
> 1. Can we detect different call path but same function?
>    I mean
>
>         A       C
>          \     /
>           B   D
>            \ /
>             E
>             |
>          kmalloc
>
> In this case, E could be called by A or C. I would like to know the call path.
> It could point out exact culprit of memory hogger.
>

I'm sorry, I'm not following you:
How can I know which caller in the call path is the 'real' responsible
for the allocation?

The only way I can think of achieving something like this is by using
kmalloc_track_caller() instead of kmalloc().
This is done in cases where an allocer is known to alloc memory on
behalf of its caller.

> 2. Does it support alloc_pages family?
>    kmem event trace already supports it. If it supports, maybe we can replace
>    CONFIG_PAGE_OWNER hack.
>

Mmm.. no, it doesn't support alloc_pages and friends, for we found
no reason to do it.
However, it sounds like a nice idea, on a first thought.

I'll review CONFIG_PAGE_OWNER patches and see if I can come up with something.

Meantime, and given this is just a script submission, is there anything
preventing to merge this? We can move it to perf, and/or add it
features, etc. later,
on top of this. Does this make sense?

-- 
    Ezequiel
