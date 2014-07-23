Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaGWGCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:02:15 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44244 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaGWGCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:02:12 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: filter: split eBPF interpreter out of core networking
Date: Tue, 22 Jul 2014 23:01:57 -0700
Message-Id: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I believe my recent set of RFC/patches [1] provided good visibility on where
I would like to take eBPF subsystem. These two trivial patches is a first step
in that direction:
patch 1 - mechanical split of eBPF interpreter out of filter.c
patch 2 - nominate myself as a maintainer for eBPF core pieces
In the foreseeable future eBPF patches will be going through net-next,
so put netdev as a primary mailing list

[1] git://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf master

Alexei Starovoitov (2):
  net: filter: split filter.c into two files
  bpf: update MAINTAINERS entry

 MAINTAINERS         |    7 +
 kernel/Makefile     |    1 +
 kernel/bpf/Makefile |    1 +
 kernel/bpf/core.c   |  536 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/filter.c   |  511 ------------------------------------------------
 5 files changed, 545 insertions(+), 511 deletions(-)
 create mode 100644 kernel/bpf/Makefile
 create mode 100644 kernel/bpf/core.c

-- 
1.7.9.5

