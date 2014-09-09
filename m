Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaIIRbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:31:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaIIRbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:31:03 -0400
Date: Tue, 09 Sep 2014 10:30:59 -0700 (PDT)
Message-Id: <20140909.103059.1330265085939107782.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linuxfoundation.org, luto@amacapital.net,
        rostedt@goodmis.org, dborkman@redhat.com, hannes@stressinduktion.org,
        chema@google.com, edumazet@google.com, a.p.zijlstra@chello.nl,
        hpa@zytor.com, akpm@linuxfoundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 net-next 0/2] load imm64 insn and uapi/linux/bpf.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
References: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 10:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Thu,  4 Sep 2014 22:17:16 -0700

> V9->V10
> - no changes, added Daniel's ack
> 
> Note they're on top of Hannes's patch in the same area [1]
> 
> V8 thread with 'why' reasoning and end goal [2]
> 
> Original set [3] of ~28 patches I'm planning to present in 4 stages:
> 
>   I. this 2 patches to fork off llvm upstreaming
>  II. bpf syscall with manpage and map implementation
> III. bpf program load/unload with verifier testsuite (1st user of
>      instruction macros from bpf.h and 1st user of load imm64 insn)
>  IV. tracing, etc
> 
> [1] http://patchwork.ozlabs.org/patch/385266/
> [2] https://lkml.org/lkml/2014/8/27/628
> [3] https://lkml.org/lkml/2014/8/26/859

Begrudgingly, I've applied this series.

Although I really wish you had included the mechanism for userland to
use the eBPF instructions alongside exporting them to userspace.

You kept saying "LLVM is the user" but that's a bullshit argument
because you aren't including the patches necessary to actually
propagate native eBPF programs into the kernel.

That's what, 1 or 2 patches, right?  Which is not an unreasonable
request.

Anyways, I'm just extremely frustrated with how you operate and work,
you push things way too hard.  I hate to say this, but you are the
kind of submitter who gets his way by being persistent rather than
making well formed pleasant submissions that are easy to integrate.
