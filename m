Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3JRIcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:32:14 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57245 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3JRIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:32:11 -0400
Message-ID: <5260F208.9000800@hitachi.com>
Date: Fri, 18 Oct 2013 17:32:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com, steve.capper@linaro.org,
        nico@linaro.org, srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        dsaxena@linaro.org, jiang.liu@huawei.com,
        Vijaya.Kumar@caviumnetworks.com
Subject: Re: [PATCH RFC v2 0/6] ARM64: Add kernel probes(Kprobes) support
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
In-Reply-To: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/17 20:17), Sandeepa Prabhu wrote:
> This patchset adds support for kernel probes(kprobes), jump probes(jprobes)
> and return probes(kretprobes) support for ARM64.
> 
> Kprobes mechanism make use of software breakpoint and single stepping
> support available in ARM v8 kernel.
> 

Thank you! This looks much better for me now. ;)

> This patchset make use of (and dependant upon) dynamic kernel patching 
> feature published in patch series: https://lkml.org/lkml/2013/10/15/891
> 
> changes: v1 -> v2
>  1. Implemented review comments on v1
>  2. Debug montior hooks implementation is changed to use rwlocks
>     instead of rcu and spinlock.

Eventually, we'd better reconsider using rcu there, or prohibit probing
readlock related functions. For the first step, this will be good.

>  3. Enabled recursing in kprobes handler for kprobes re-enter support.
>  4. Re-split the patchset to seperate single-stepping, simulation and 
>     kretprobes features.
>  5. instruction simulation is made independent of 'struct kprobes'
>  6. Added 'Linaro Copyright' statements in new added files.
>  7. Used arm64 instead of aarch64 in file names and comments.
> 
> Tested on ARM v8 fast model with sample modules from: samples/kprobes/
> 
> Sandeepa Prabhu (6):
>   arm64: support single-step and breakpoint handler hooks
>   arm64: Kprobes with single stepping support
>   arm64: Kprobes instruction simulation support
>   arm64: Add kernel return probes support(kretprobes)
>   arm64: Enable kprobes support for arm64 platform
>   kprobes: Add cases for arm and arm64 in sample module
> 
>  arch/arm64/Kconfig                      |   2 +
>  arch/arm64/configs/defconfig            |  20 +-
>  arch/arm64/include/asm/debug-monitors.h |  21 +
>  arch/arm64/include/asm/kprobes.h        |  60 +++
>  arch/arm64/include/asm/probes.h         |  50 +++
>  arch/arm64/include/asm/ptrace.h         |   6 +
>  arch/arm64/kernel/Makefile              |   2 +
>  arch/arm64/kernel/condn-helpers.c       | 120 ++++++
>  arch/arm64/kernel/debug-monitors.c      |  86 +++-
>  arch/arm64/kernel/entry.S               |   2 +


>  arch/arm64/kernel/kprobes-arm64.c       | 313 +++++++++++++++
>  arch/arm64/kernel/kprobes-arm64.h       |  30 ++

One comment, this name looks a bit wired. Since it seems that these are
for instruction decoding, can we merge it with probe-decode.h and
rename it as probe-decode.{h,c}? When we implement uprobes, we still
can expand it (add the decoding table for uprobes in the probe-decode.c).

>  arch/arm64/kernel/kprobes.c             | 682 ++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/kprobes.h             |  30 ++
>  arch/arm64/kernel/probes-decode.h       | 110 ++++++
>  arch/arm64/kernel/simulate-insn.c       | 184 +++++++++
>  arch/arm64/kernel/simulate-insn.h       |  33 ++
>  arch/arm64/kernel/vmlinux.lds.S         |   1 +
>  samples/kprobes/kprobe_example.c        |  16 +
>  19 files changed, 1756 insertions(+), 12 deletions(-)

BTW, is there any public git repository which has this series?

Thank you again!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


