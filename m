Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaHTPCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:02:34 -0400
Received: from www.sr71.net ([198.145.64.142]:35514 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaHTPCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:02:33 -0400
Message-ID: <53F4B887.7060701@sr71.net>
Date: Wed, 20 Aug 2014 08:02:31 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        lauraa@codeaurora.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [v2] TAINT_PERFORMANCE
References: <20140820035751.08C980FB@viggo.jf.intel.com> <20140820081158.GA3991@gmail.com>
In-Reply-To: <20140820081158.GA3991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 01:11 AM, Ingo Molnar wrote:
> In any case I don't think it's a good idea to abuse existing 
> facilities just to gain attention: you'll get the extra 
> attention, but the abuse dilutes the utility of those only 
> tangentially related facilities.

I'm happy to rip the TAINT parts out.  I was just hoping that some
tooling might pick up the taint flags today, and this could get picked
up without modification of whatever those tools are.

I was _really_ hoping the dmesg from the taint would be ugly and loud
enough to be sufficient, but it was relatively terse.

> A better option might be to declare known performance killers 
> in /proc/config_debug or so, and maybe print them once at the 
> end of the bootup, with a 'WARNING:' or 'INFO:' prefix. That 
> way tooling (benchmarks, profilers, etc.) can print them, but 
> it's also present in the syslog, just in case.

Sounds reasonable to me.  As long as we have _something_ that shows up
in dmesg, it will help.
