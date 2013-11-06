Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3KFKmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:42:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37007 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab3KFKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:41:59 -0500
Date: Wed, 6 Nov 2013 10:41:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Jiang Liu <liuj97@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131106104110.GC21074@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-3-git-send-email-liuj97@gmail.com>
 <20131030001245.GB25346@mudshark.cambridge.arm.com>
 <527671E9.8040704@gmail.com>
 <CA+b37P2WU74NU7wG_H+KfmL6Y-fdhipsuOruU-z=wv=8ENwrfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+b37P2WU74NU7wG_H+KfmL6Y-fdhipsuOruU-z=wv=8ENwrfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 03:12:56PM +0000, Sandeepa Prabhu wrote:
> On 3 November 2013 23:55, Jiang Liu <liuj97@gmail.com> wrote:
> > On 10/30/2013 08:12 AM, Will Deacon wrote:
> >> On Fri, Oct 18, 2013 at 04:19:56PM +0100, Jiang Liu wrote:
> >>> +    atomic_set(&text_patch_id, smp_processor_id());
> >>> +    ret = stop_machine(aarch64_insn_patch_text_cb, &patch, cpu_online_mask);
> >>
> >> Instead of doing this, why not instead call aarch64_insn_patch_text_nosync
> >> inline, then call kick_all_cpus_sync immediately afterwards, without the
> >> need to stop_machine.
> > Sandeepa, who is working on kprobe for ARM64, needs the stop_machine()
> > mechanism to synchronize all online CPUs, so it's a preparation for
> > kprobe.
> 
> I had published kprobes patches for ARM64:
> http://lwn.net/Articles/570648/  and using your patcset (v3) for
> patching support, it works so far.
> I CCed you on my RFC but unfortunately to your huawei email not the gmail.
> 
> I can give a try with kick_all_cpus_sync but wanted to understand this
> a bit  detail on hows different from stop_machine and how this work.

My point was just that for nosync patching, the update to the instruction
stream is atomic with respect to instruction fetch, so stop_machine seems a
bit overkill. kick_all_cpus can be used to ensure visibility of the new
instruction.

Jiang Liu seemed to imply that this isn't suitable for kprobes, but I would
like to know if/why that is the case.

Will
