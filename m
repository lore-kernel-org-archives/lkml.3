Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaCAJNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 04:13:33 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64091 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaCAJNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 04:13:04 -0500
Date: Sat, 1 Mar 2014 10:12:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Fix strict alias issue for find_first_bit
Message-ID: <20140301091258.GB5885@gmail.com>
References: <1393622751-21513-1-git-send-email-acme@infradead.org>
 <1393622751-21513-3-git-send-email-acme@infradead.org>
 <20140228212923.GI14089@laptop.programming.kicks-ass.net>
 <531123D8.6000201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531123D8.6000201@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 2/28/14, 2:29 PM, Peter Zijlstra wrote:
> >Hurm; didn't I suggest using -fno-strict-aliasing just like the kernel
> >does? Because the C aliasing rules are bonghits heavy?
> 
> you, and Ingo in 2009 -- 65014ab3

Yeah, so that's certainly true for the kernel, but for user-space the 
aggressive optimizations that come with the aliasing rules were pretty 
good, last I checked.

So it would be nice to check the code generation and performance 
impact of -fno-strict-aliasing on perf (if any). If the impact is 
restricted to an odd few annotations for weird, low-level methods
like find_bit(), then we might be able to live with it.

The aliasing warnings can also find real bugs and uncleanlinesses.

So I'm really of two minds regarding this.

Thanks,

	Ingo
