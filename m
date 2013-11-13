Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab3KMOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:20:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64302 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab3KMOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:20:48 -0500
Date: Wed, 13 Nov 2013 14:20:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
Message-ID: <20131113142039.GE28881@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
 <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
 <20131108165639.GD15074@mudshark.cambridge.arm.com>
 <527DFC1C.1020107@hitachi.com>
 <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
 <52808D53.7080904@hitachi.com>
 <5280B6C8.7050807@hitachi.com>
 <20131111105812.GC28302@mudshark.cambridge.arm.com>
 <20131113135807.GJ26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113135807.GJ26898@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:58:07PM +0000, Peter Zijlstra wrote:
> On Mon, Nov 11, 2013 at 10:58:12AM +0000, Will Deacon wrote:
> > Single-stepping on x86 is different to the step behaviour on arm64 afaik. On
> > ARM, we have to manually remove the breakpoint, perform a single-step, then
> > add the breakpoint again. If we re-enable debug exceptions in the kprobe
> > handler, the step will complete early and we'll never step off the
> > breakpoint.
> 
> This is about hardware breakpoints right? Which are per-cpu? Otherwise
> removing the breakpoint would open up a hole for another thread to slip
> through while you're single stepping.

Correct, but our hardware breakpoints don't have any resume feature, so they
have to be disabled on the relevant CPU, then stepped on that same CPU
before they can be reactivated.

Will
