Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3HLRrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:47:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:56411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab3HLRrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,863,1367996400"; 
   d="scan'208";a="345238780"
Message-ID: <52091FB9.4080805@linux.intel.com>
Date: Mon, 12 Aug 2013 10:47:37 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home> <20130812091707.GB27162@twins.programming.kicks-ass.net> <5208F78A.3000708@linux.intel.com> <20130812160950.GT3008@twins.programming.kicks-ass.net>
In-Reply-To: <20130812160950.GT3008@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 09:09 AM, Peter Zijlstra wrote:
>>
>> On the majority of architectures, including x86, you cannot simply copy
>> a piece of code elsewhere and have it still work.
> 
> I thought we used -fPIC which would allow just that.
> 

Doubly wrong.  The kernel is not compiled with -fPIC, nor does -fPIC
allow this kind of movement for code that contains intramodule
references (that is *all* references in the kernel).  Since we really
doesn't want to burden the kernel with a GOT and a PLT, that is life.

>> You end up doing a
>> bunch of the work that a JIT would do anyway, and would end up with
>> considerably higher complexity and worse results than a true JIT.  
> 
> Well, less complexity but worse result, yes. We'd only poke the specific
> static_branch sites with either NOPs or the (relative) jump target for
> each of these branches. Then copy the result.

Once again, you can't "copy the result".  You end up with a full
disassembler.

	-hpa

