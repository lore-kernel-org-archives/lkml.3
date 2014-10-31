Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbaKARcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:32:06 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61949 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147AbaKARcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:32:04 -0400
Date: Fri, 31 Oct 2014 12:28:24 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141031122824.GZ12020@console-pimps.org>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
 <20141031072109.GD12706@worktop.programming.kicks-ass.net>
 <20141031092713.GA23124@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031092713.GA23124@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct, at 10:27:13AM, Ingo Molnar wrote:
> 
>  - user-space gets back the regular errno (-EOPNOTSUPP or -ENOSYS
>    or -EINVAL, etc.) and a string. Strings are really the most 
>    helpful information, because tools can just print that. They 
>    can also match on specific strings and programmatically react 
>    to them if they want to: we can promise to not arbitrarily 
>    change error strings once they are introduced. (but even if 
>    they change, user-space can still print them out.)

I guess we'd run into a problem if userspace doesn't want to just print
the kernel string but instead wants to parse it in some fashion.

That may or may not be a problem in practice, Vince can probably comment
on that. I'm just thinking along the lines of making the perf syscall
interface as useful as possible for tools other than tools/perf.

-- 
Matt Fleming, Intel Open Source Technology Center
