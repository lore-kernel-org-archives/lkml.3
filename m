Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3KLQ7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:59:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:58578 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753603Ab3KLQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:59:41 -0500
Date: Tue, 12 Nov 2013 11:59:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
Message-ID: <20131112115935.23d05236@gandalf.local.home>
In-Reply-To: <CA+b37P1xLYWA-a0PwgxT7S7dNr5TdGFscLYFeQhAQUyO_E=Mzw@mail.gmail.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
	<20131108165639.GD15074@mudshark.cambridge.arm.com>
	<527DFC1C.1020107@hitachi.com>
	<CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
	<52808D53.7080904@hitachi.com>
	<5280B6C8.7050807@hitachi.com>
	<20131111105812.GC28302@mudshark.cambridge.arm.com>
	<528114C4.5000506@hitachi.com>
	<CA+b37P08cLAvBYAXSkozLPzrpuXn=N0SUetwL6N8JL+10AtYjQ@mail.gmail.com>
	<5281D848.7000502@hitachi.com>
	<CA+b37P2EgB0toYwhLny8k-cbrziBVXURST5kHNXcY7AF-CNVLg@mail.gmail.com>
	<52820043.6090107@hitachi.com>
	<CA+b37P1xLYWA-a0PwgxT7S7dNr5TdGFscLYFeQhAQUyO_E=Mzw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013 16:25:26 +0530
Sandeepa Prabhu <sandeepa.prabhu@linaro.org> wrote:


> >
> > BTW, I'm currently trying a general housecleaning of __kprobes
> > annotations. It may also have impact on your patch.
> > https://lkml.org/lkml/2013/11/8/187
> Hmm, we can help testing your patchset on arm64 platforms. Also have
> many doubts on the changes you are working [blacklisting probes etc]
> 
> Basically I had tried placing kprobe on memcpy() and the model hung
> (insmod never returned back!). Fast-model I have does not have option
> of any debug so no clue what happened!.
> memcpy() is low-level call being used internally within kprobes, so
> probably we cannot handle probe on that routine, but then how to make
> sure all such API are rejected by kprobe sub-system ?

Working on ports of ftrace, I found that many of the functions in lib/
are used by several locations that just can't be traced, due to how
low level they are. I just simply blacklisted the entire lib/
directory (See the top of lib/Makefile)

I wonder if there's an easy way to blacklist entire directories from
being used by kprobes too. Or at least do it by a file per file basis.

-- Steve
