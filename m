Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaCDWRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:17:32 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59110 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbaCDWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:17:23 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Jesse Gross <jesse@nicira.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v5 net-next 0/3] filter: add Extended BPF interpreter and converter
Date: Tue,  4 Mar 2014 14:17:14 -0800
Message-Id: <1393971437-4129-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

V1 patches:
http://thread.gmane.org/gmane.linux.kernel/1605783
V2 patches:
http://thread.gmane.org/gmane.linux.kernel/1642325
V3 patches:
http://thread.gmane.org/gmane.linux.kernel/1656538

V4 summary:
- addressed Daniel comments
- RFC for seccomp with extended BPF
- added extended BPF design doc

V5 summary:
- fixed commit one-liner, removed empty line
- added Hagen's ack

Please review.
Thanks!

Alexei Starovoitov (3):
  filter: add Extended BPF interpreter and converter
  [RFC] seccomp: convert seccomp to use extended BPF
  doc: filter: add Extended BPF documentation

 Documentation/networking/filter.txt |  181 ++++++++
 include/linux/filter.h              |    6 +-
 include/linux/netdevice.h           |    1 +
 include/linux/seccomp.h             |    1 -
 include/uapi/linux/filter.h         |   33 +-
 kernel/seccomp.c                    |  112 +++--
 net/core/filter.c                   |  807 ++++++++++++++++++++++++++++++++++-
 net/core/sysctl_net_core.c          |    7 +
 8 files changed, 1059 insertions(+), 89 deletions(-)

-- 
1.7.9.5

