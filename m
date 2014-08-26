Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbaHZBBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:01:17 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39289 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbaHZBBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:01:15 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 net-next 0/6] introduce BPF syscall
Date: Mon, 25 Aug 2014 18:00:52 -0700
Message-Id: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

splitting big set of patches into smaller sets:

1st(this) set - introduces uapi/linux/bpf.h and BPF syscall for maps only
2nd set will extend BPF syscall with programs and verifier
3rd set will use eBPF in tracing, add samples and verifier tests
4th set will have llvm and C examples

Tested on x64 and i386.
BPF syscall with maps only is usable, but not very useful until the rest comes
Build/boot tested on arm and sparc.
They got new warning 'syscall bpf not implemented'

V5->V6:
- fixed few checkpatch warnings.
  Few lines are still over 80 char, but fixing them will reduce readability
- rebased

V5 thread:
https://lkml.org/lkml/2014/8/24/107

All patches:
git://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf master

Alexei Starovoitov (6):
  net: filter: add "load 64-bit immediate" eBPF instruction
  net: filter: split filter.h and expose eBPF to user space
  bpf: introduce syscall(BPF, ...) and BPF maps
  bpf: enable bpf syscall on x64 and i386
  bpf: add lookup/update/delete/iterate methods to BPF maps
  bpf: add hashtable type of BPF maps

 Documentation/networking/filter.txt |   79 +++++++-
 arch/x86/net/bpf_jit_comp.c         |   17 ++
 arch/x86/syscalls/syscall_32.tbl    |    1 +
 arch/x86/syscalls/syscall_64.tbl    |    1 +
 include/linux/bpf.h                 |   50 +++++
 include/linux/filter.h              |  294 +--------------------------
 include/linux/syscalls.h            |    3 +-
 include/uapi/asm-generic/unistd.h   |    4 +-
 include/uapi/linux/Kbuild           |    1 +
 include/uapi/linux/bpf.h            |  371 ++++++++++++++++++++++++++++++++++
 kernel/bpf/Makefile                 |    2 +-
 kernel/bpf/core.c                   |    5 +
 kernel/bpf/hashtab.c                |  373 +++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c                |  354 +++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                     |    3 +
 lib/test_bpf.c                      |   21 ++
 16 files changed, 1282 insertions(+), 297 deletions(-)
 create mode 100644 include/linux/bpf.h
 create mode 100644 include/uapi/linux/bpf.h
 create mode 100644 kernel/bpf/hashtab.c
 create mode 100644 kernel/bpf/syscall.c

-- 
1.7.9.5

