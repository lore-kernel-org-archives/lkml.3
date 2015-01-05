Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbbAEKrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:47:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbbAEKrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:47:03 -0500
Date: Mon, 5 Jan 2015 11:46:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        Stephane Eranian <eranian@google.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH 0/2] perf: Improve user regs sampling
Message-ID: <20150105104616.GA21260@krava.brq.redhat.com>
References: <20150104174105.GA29388@krava.brq.redhat.com>
 <cover.1420396372.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1420396372.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 10:36:18AM -0800, Andy Lutomirski wrote:
> This seems to improve the situation on x86_64 from almost entirely
> broken to mostly working.  Tested with:
> 
> perf record -e cycles --call-graph=dwarf ls

looks good to me.. also:

Tested-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> 
> Andy Lutomirski (2):
>   perf: Move task_pt_regs sampling into arch code
>   x86_64, perf: Improve user regs sampling
> 
>  arch/arm/kernel/perf_regs.c   |  8 ++++
>  arch/arm64/kernel/perf_regs.c |  8 ++++
>  arch/x86/kernel/perf_regs.c   | 90 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h    | 12 +++---
>  include/linux/perf_regs.h     | 16 ++++++++
>  kernel/events/core.c          | 19 ++++-----
>  6 files changed, 137 insertions(+), 16 deletions(-)
> 
> -- 
> 2.1.0
> 
