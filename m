Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaE1T4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:56:37 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48198 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaE1T4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140528195528.GQ29957@tassilo.jf.intel.com>
References: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
	<20140528195528.GQ29957@tassilo.jf.intel.com>
Date: Wed, 28 May 2014 21:56:35 +0200
Message-ID: <CABPqkBRW8akWWrRgFwatHbui6+0JqXi=8T2N_JHZ_x4zLuq9EQ@mail.gmail.com>
Subject: Re: [RFC] perf/x86: PMU IRQ handler issues
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Dave Hansen <dave.hansen@intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:55 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
>> Another explanation is that because we ACK the NMI early, we leave the
>> door open to other interrupts, incl. NIC, and we are interrupting the execution
>
> PMI executes with interrupts off.
>
And that's coming from where?

>> of the PMU IRQ handler, yet that detour is measured in the PMU handler
>> latency, causing more throttling than needed. Is that a plausible scenario too?
>> And if so, I think we need to narrow the window for timing errors, by
>> acking late
>> on all processors and not just HSW.
>
> If you think there's a concrete problem please show an ftrace.
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only
