Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaLFFUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:20:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60217 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLFFUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:20:05 -0500
Date: Fri, 05 Dec 2014 21:24:33 -0800 (PST)
Message-Id: <20141205.212433.750912400773154348.davem@davemloft.net>
To: ast@plumgrid.com
Cc: zlim.lnx@gmail.com, edumazet@google.com, dborkman@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] bpf: x86: fix epilogue generation for eBPF
 programs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417301173-23691-1-git-send-email-ast@plumgrid.com>
References: <1417301173-23691-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:20:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Sat, 29 Nov 2014 14:46:13 -0800

> classic BPF has a restriction that last insn is always BPF_RET.
> eBPF doesn't have BPF_RET instruction and this restriction.
> It has BPF_EXIT insn which can appear anywhere in the program
> one or more times and it doesn't have to be last insn.
> Fix eBPF JIT to emit epilogue when first BPF_EXIT is seen
> and all other BPF_EXIT instructions will be emitted as jump.
> 
> Since jump offset to epilogue is computed as:
> jmp_offset = ctx->cleanup_addr - addrs[i]
> we need to change type of cleanup_addr to signed to compute the offset as:
> (long long) ((int)20 - (int)30)
> instead of:
> (long long) ((unsigned int)20 - (int)30)
> 
> Fixes: 622582786c9e ("net: filter: x86: internal BPF JIT")
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

Applied, thanks.
