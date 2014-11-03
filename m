Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaKCRjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:39:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:58465 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaKCRjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:39:18 -0500
Date: Mon, 3 Nov 2014 18:39:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141103173914.GZ10501@worktop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
 <20141031072109.GD12706@worktop.programming.kicks-ass.net>
 <20141031092713.GA23124@gmail.com>
 <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
 <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
 <20141103162548.GB18464@kernel.org>
 <20141103165019.GY10501@worktop.programming.kicks-ass.net>
 <20141103170059.GC18464@kernel.org>
 <alpine.DEB.2.10.1411031205070.16230@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411031205070.16230@pianoman.cluster.toy>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 12:12:18PM -0500, Vince Weaver wrote:
> I don't know if having an offset/mask helps much.  Knowing your EINVAL
> comes from ->config is nice to know, but if there's 30 different ways
> to get an EINVAL from an improper config then you still can waste a lot
> of time narrowing things down.
> 
> The string solution might be nice, but it is going to take major changes 
> to the code and increase the size a bit.  For example:
> 
> $ cat arch/x86/kernel/cpu/perf* kernel/events/* | grep EINVAL | wc -l
> 100
> 
> And some of the code is passing the return values back through various
> long callchains (and overloaded pointers via casts) where it's not clear 
> how you could also pass a string value.

Yes, nobody said this would be a quick and easy exercise. But I figure
something needs to happen.
