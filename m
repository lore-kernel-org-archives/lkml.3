Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaCKOij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:38:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40236 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbaCKOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:38:38 -0400
Date: Tue, 11 Mar 2014 14:35:36 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/7] arm64: Add ftrace support
Message-ID: <20140311143535.GE7944@mudshark.cambridge.arm.com>
References: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Fri, Feb 28, 2014 at 05:18:37AM +0000, AKASHI Takahiro wrote:
> This patchset implements a function tracer on arm64.
> There was another implementation from Cavium network, but both of us agreed
> to use my patchset as future base. He is supposed to review this code, too.
> 
> The only issue that I had some concern on was "fault protection" code
> in prepare_ftrace_return(). With discussions with Steven and Tim (as author
> of arm ftrace), I removed that code since I'm not quite sure about possibility
> of "fault" occurrences in this function.
> 
> The code is tested on ARMv8 Fast Model with the following tracers & events:
>      function tracer with dynamic ftrace
>      function graph tracer with dynamic ftrace
>      syscall tracepoint
>      irqsoff & preemptirqsoff (which use CALLER_ADDRx)
> and also verified with in-kernel tests, FTRACE_SELFTEST, FTRACE_STARTUP_TEST
> and EVENT_TRACE_TEST_SYSCALLS.
> 
> Prerequisites are:
>  * "arm64: Add regs_return_value() in syscall.h"
>  * "arm64: make a single hook to syscall_trace() for all syscall features" patch

It looks like there might be some more dependencies that that. Do you have a
branch anywhere containing this series, along with all the dependencies so I
can have a play?

Cheers,

Will
