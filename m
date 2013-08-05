Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3HERC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:02:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:36712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab3HERCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,819,1367996400"; 
   d="scan'208";a="357827885"
Message-ID: <51FFDAA0.6020107@linux.intel.com>
Date: Mon, 05 Aug 2013 10:02:24 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home>
In-Reply-To: <1375721715.22073.80.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 09:55 AM, Steven Rostedt wrote:
> 
> Almost a full year ago, Mathieu suggested something like:
> 
> if (unlikely(x)) __attribute__((section(".unlikely"))) {
>         ...
> } else __attribute__((section(".likely"))) {
>         ...
> }
> 
> https://lkml.org/lkml/2012/8/9/658
> 
> Which got me thinking. How hard would it be to set a block in its own
> section. Like what Mathieu suggested, but it doesn't have to be
> ".unlikely".
> 
> if (x) __attibute__((section(".foo"))) {
> 	/* do something */
> }
> 

One concern I have is how this kind of code would work when embedded
inside a function which already has a section attribute.  This could
easily cause really weird bugs when someone "optimizes" an inline or
macro and breaks a single call site...

	-hpa


