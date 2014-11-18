Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaKRN2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:28:45 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:42365 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbaKRN2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:28:44 -0500
Message-ID: <1416317295.1735.9.camel@linaro.org>
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Tue, 18 Nov 2014 13:28:15 +0000
In-Reply-To: <1416292375-29560-2-git-send-email-dave.long@linaro.org>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
	 <1416292375-29560-2-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 01:32 -0500, David Long wrote:
> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> 
> Add support for basic kernel probes(kprobes) and jump probes
> (jprobes) for ARM64.
> 
> Kprobes will utilize software breakpoint and single step debug
> exceptions supported on ARM v8.
> 
> software breakpoint is placed at the probe address to trap the
> kernel execution into kprobe handler.
> 
> ARM v8 support single stepping to be enabled while exception return
> (ERET) with next PC in exception return address (ELR_EL1).
> kprobe handler prepares a executable memory slot for out-of-line
> execution with the copy of the original instruction under probe, and
> enable single stepping from the instruction slot. With this scheme,
> the instruction is executed with the exact same register context
> 'except PC' that points to instruction slot.
> 
> Debug mask(PSTATE.D) is enabled only when single stepping a recursive
> kprobes i.e. during kprobes reenter so that probes instruction can be
> single stepped within the kprobe handler -exception- context.

Does this mean that at the point the probed instruction is
single-stepped there is nothing extra that has been pushed on on the
kernel stack by any kprobes handling code? I just want to check that you
aren't going to hit the problems that the 32-bit kprobes code is
currently being fixed for [1]. 

The simulated instructions in patch 2 don't access the stack, so they
are safe from the problem.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/303525.html

-- 
Tixy

