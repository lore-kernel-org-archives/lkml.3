Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbaKUE2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:28:35 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:61834 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbaKUE2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:28:34 -0500
Message-ID: <546EBF70.9020706@linaro.org>
Date: Thu, 20 Nov 2014 23:28:32 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>	 <1416292375-29560-2-git-send-email-dave.long@linaro.org> <1416317295.1735.9.camel@linaro.org>
In-Reply-To: <1416317295.1735.9.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/14 08:28, Jon Medhurst (Tixy) wrote:
> On Tue, 2014-11-18 at 01:32 -0500, David Long wrote:
>> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>>
>> Add support for basic kernel probes(kprobes) and jump probes
>> (jprobes) for ARM64.
>>
>> Kprobes will utilize software breakpoint and single step debug
>> exceptions supported on ARM v8.
>>
>> software breakpoint is placed at the probe address to trap the
>> kernel execution into kprobe handler.
>>
>> ARM v8 support single stepping to be enabled while exception return
>> (ERET) with next PC in exception return address (ELR_EL1).
>> kprobe handler prepares a executable memory slot for out-of-line
>> execution with the copy of the original instruction under probe, and
>> enable single stepping from the instruction slot. With this scheme,
>> the instruction is executed with the exact same register context
>> 'except PC' that points to instruction slot.
>>
>> Debug mask(PSTATE.D) is enabled only when single stepping a recursive
>> kprobes i.e. during kprobes reenter so that probes instruction can be
>> single stepped within the kprobe handler -exception- context.
>
> Does this mean that at the point the probed instruction is
> single-stepped there is nothing extra that has been pushed on on the
> kernel stack by any kprobes handling code? I just want to check that you
> aren't going to hit the problems that the 32-bit kprobes code is
> currently being fixed for [1].
>
> The simulated instructions in patch 2 don't access the stack, so they
> are safe from the problem.
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/303525.html
>

Took me a while to read through the background on this.  I believe it is 
true nothing extra is put on the stack in the single-step case.

-dl

