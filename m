Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946218Ab3FUVyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:54:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:25612 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946146Ab3FUVyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,915,1363158000"; 
   d="scan'208";a="258452394"
Message-ID: <51C4CB7F.2000306@linux.intel.com>
Date: Fri, 21 Jun 2013 14:54:07 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
References: <1371835898.18733.122.camel@gandalf.local.home>  <1371848976.18733.130.camel@gandalf.local.home>  <51C4C215.2040705@linux.intel.com> <1371850091.18733.136.camel@gandalf.local.home>
In-Reply-To: <1371850091.18733.136.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 02:28 PM, Steven Rostedt wrote:
> On Fri, 2013-06-21 at 14:13 -0700, H. Peter Anvin wrote:
>> On 06/21/2013 02:09 PM, Steven Rostedt wrote:
>>> Call Trace:
>>>  [<ffffffff8103539d>] do_fork+0xa8/0x260
>>>  [<ffffffff810ca7b1>] ? trace_preempt_on+0x2a/0x2f
>>>  [<ffffffff812afb3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>
>> This bit of the call chain seems a little odd, no?
> 
> Doesn't the "?" mean its just in the stack but not part of the call
> frame that was used. CONFIG_FRAME_POINTER is set in the config.
> 
> With lockdep and preempt tracing enabled, why would this seem strange?
> 

I didn't think trace_hardirqs_on_thunk called trace_preempt_on but maybe
I misread the code.

	-hpa


