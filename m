Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaJAG6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:58:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:54178 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaJAG6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:58:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,630,1406617200"; 
   d="scan'208";a="607989074"
Date: Wed, 1 Oct 2014 14:57:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [hw_breakpoint] WARNING: at kernel/trace/trace_kprobe.c:1393
 kprobe_trace_self_tests_init()
Message-ID: <20141001065757.GA17297@wfg-t540p.sh.intel.com>
References: <20140930074305.GA8090@wfg-t540p.sh.intel.com>
 <20140930175844.GA20922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930175844.GA20922@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> > +-----------------------------------------------------------------------+------------+------------+------------------+
> > |                                                                       | 003002e04e | 8b4d801b2b | v3.17-rc7_093000 |
> > +-----------------------------------------------------------------------+------------+------------+------------------+
> > | boot_successes                                                        | 60         | 0          | 0                |
> > | boot_failures                                                         | 0          | 20         | 11               |
> > | WARNING:at_kernel/trace/trace_kprobe.c:kprobe_trace_self_tests_init() | 0          | 20         | 11               |
> > | backtrace:kprobe_trace_self_tests_init                                | 0          | 20         | 11               |
> > | backtrace:warn_slowpath_null                                          | 0          | 20         | 11               |
> > | backtrace:kernel_init_freeable                                        | 0          | 20         | 11               |
> > +-----------------------------------------------------------------------+------------+------------+------------------+
> >
> > [    4.188679] Testing kprobe tracing:
> > [    4.189810] Could not insert probe at kprobe_trace_selftest_target+0: -22
> 
> __register_trace_kprobe() fails.
> 
> No, I am very sure this can't be caused by the commit above. If nothing else,
> task_bp_pinned() changed by this commit is not even called in this case.

Sorry it is a bad bisect -- debug shows that CONFIG_FTRACE_STARTUP_TEST
is not enabled at all in the parent commit, which makes it boot success.
I'll fix this issue in my script and make the bisect stable.

Thanks,
Fengguang
