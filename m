Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaJXAwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:52:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51327 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJXAwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:52:18 -0400
Message-ID: <5449A2BB.1020207@hitachi.com>
Date: Fri, 24 Oct 2014 09:52:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, will.deacon@arm.com,
        dave.long@linaro.org, taras.kondratiuk@linaro.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v6 0/7] ARM: kprobes: enable OPTPROBES for ARM 32.
References: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/22 20:31), Wang Nan wrote:
> Previous 5 version of ARM OPTPROBES patches are unable to deal with
> stack storing instructions correctly. V5 patches disallow optimizing
> every protential stack store instructions based on pessimistic
> assumption. Which, as Tixy comments, 'excludes the main use of
> kprobes'. (https://lkml.org/lkml/2014/8/29/117 )
> 
> The main obstacle which prevents us from computing stack requirement is
> the missing of per-instruction decoder in probes_decode_insn() and its
> friends. Only part of instructions have their decoders (and not in
> each case).
> 
> In this patch series, I propose 'checker', which allows us define
> functions for each type of instruction, extract more information.  Stack
> consumption computing is an example. Checker can be further employed to
> determine whether one instruction is possible to execute directy in
> optimized kprobe. I'd like to expand current checker framework by
> chaining checkers together. After that, I believe most of ARM
> instructions can be executed directly like x86, kprobe performace can be
> improved.
> 
> The first 3 patches introduces checker. After that, patch 4/7 checks
> stack requirement for probed instructions. Patches 5/7 - 7/7 are similar
> to patch v5, except:
> 
>  1. As Tixy proposed, unoptimized probes are also suffer from stack
>     problem (https://lkml.org/lkml/2014/9/1/548 ). Commit d30a0c8b saves
>     64 bytes for them, but for instruction use register addressing (like
>     'str r0, [sp, r1]'), 64 bytes are unsafe. Patch 5/7 prohibit such
>     probing according to stack information collected by checker.

By the way, this sounds like a bugfix rather than an improvement.
Is it possible to separate 1/7-5/7 as a bugfix series? I think those
should go to 3.18.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


