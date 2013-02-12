Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3BLTj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:39:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:27795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153Ab3BLTjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:39:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,652,1355126400"; 
   d="scan'208";a="290221848"
Message-ID: <511A9A64.3040108@linux.intel.com>
Date: Tue, 12 Feb 2013 11:39:16 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [RFC][PATCH] tracing/syscalls: Have ia32 compat syscalls show
 raw format
References: <1360692087.21867.42.camel@gandalf.local.home>  <511A85E8.7030303@linux.intel.com> <1360694555.21867.69.camel@gandalf.local.home>
In-Reply-To: <1360694555.21867.69.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 10:42 AM, Steven Rostedt wrote:
> 
> And currently the output is just plain broken. This isn't a hack. You
> should have seen my first attempt. Now THAT was a hack! My first attempt
> was extremely intrusive, and required a lot of arch changes. But then I
> realized it was too much, and found that I could do the same thing
> pretty much completely contained within just the tracing code itself.
> 
> I know you feel that the syscall tracing is broken/hack/whatever. But it
> exists as of today, and yes, there's lots of users out there depending
> on it.
> 

I am getting extremely frustrated with this cycle:

1. "We should have done <X> but we did <Y> because <X> was too
    hard/required arch changes/..."
2. "Well, <Y> is broken, but people rely on it.  We should have done
    <X> but now it is too hard/breaks legacy/... so let's do <Z>..."
3. Lather, rinse, repeat.

The whole system with trace metadata seems to be broken at the core,
*exactly* because it intercepts at a different place than the one which
has a well-defined ABI and every hack, kluge and patch which doesn't fix
that fundamental design error will just make it worse and just kicks the
can further down the road.

	-hpa



