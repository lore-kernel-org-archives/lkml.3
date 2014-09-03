Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaICDRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:17:39 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39419 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaICDRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:17:37 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 net-next 0/4] load imm64 insn and uapi/linux/bpf.h
Date: Tue,  2 Sep 2014 20:17:22 -0700
Message-Id: <1409714246-31054-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

V8->V9
- rebase on top of Hannes's patch in the same area [1]
- no changes to patches 1 and 2
- added patches 3 and 4 as RFC to address Daniel's concern.
  patch 3 moves eBPF instruction macros and
  patch 4 split macros which are shared between classic and eBPF
  into bpf_common.h
  3 and 4 will be used by verifier testsuite and will be reposted later
  during stage III

V8 thread with 'why' reasoning and end goal:
https://lkml.org/lkml/2014/8/27/628

Original set [2] of ~28 patches I'm planning to present in 4 stages:

  I. this 2 patches to fork off llvm upstreaming
 II. bpf syscall with manpage and map implementation
III. bpf program load/unload with verifier testsuite (1st user of
     instruction macros from bpf.h and 1st user of load imm64 insn)
 IV. tracing, etc

[1] http://patchwork.ozlabs.org/patch/385266/
[2] https://lkml.org/lkml/2014/8/26/859

