Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981AbaKMTZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:03 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:53509 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908AbaKMTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:24:56 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        Horia Geanta <horia.geanta@freescale.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>,
        Michael Neuling <mikey@neuling.org>, Wolfram Sang <wsa@the-dreams.de>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list),
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>,
        Dave Jiang <dave.jiang@intel.com>, Rashika <rashika.kheria@gmail.com>,
        dmaengine@vger.kernel.org (open list:DMA GENERIC OFFLO...),
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...),
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, NeilBrown <neilb@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        Paul McQuade <paulmcquad@gmail.com>,
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/...)
Cc: paulmck@linux.vnet.ibm.com
Subject: [RFC PATCH 00/16] Replace smp_read_barrier_depends() with lockless_derefrence()
Date: Thu, 13 Nov 2014 14:24:06 -0500
Message-Id: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). 

http://lkml.iu.edu/hypermail/linux/kernel/1410.3/04561.html

The following series tries to do this.

There are still some hard-coded locations which I was not sure how to replace
with. I will send in separate patches/questions regarding them.

Pranith Kumar (16):
  crypto: caam - Remove unnecessary smp_read_barrier_depends()
  doc: memory-barriers.txt: Document use of lockless_dereference()
  drivers: dma: Replace smp_read_barrier_depends() with
    lockless_dereference()
  dcache: Replace smp_read_barrier_depends() with lockless_dereference()
  overlayfs: Replace smp_read_barrier_depends() with
    lockless_dereference()
  assoc_array: Replace smp_read_barrier_depends() with
    lockless_dereference()
  hyperv: Replace smp_read_barrier_depends() with lockless_dereference()
  rcupdate: Replace smp_read_barrier_depends() with
    lockless_dereference()
  percpu: Replace smp_read_barrier_depends() with lockless_dereference()
  perf: Replace smp_read_barrier_depends() with lockless_dereference()
  seccomp: Replace smp_read_barrier_depends() with
    lockless_dereference()
  task_work: Replace smp_read_barrier_depends() with
    lockless_dereference()
  ksm: Replace smp_read_barrier_depends() with lockless_dereference()
  slab: Replace smp_read_barrier_depends() with lockless_dereference()
  netfilter: Replace smp_read_barrier_depends() with
    lockless_dereference()
  rxrpc: Replace smp_read_barrier_depends() with lockless_dereference()

 Documentation/memory-barriers.txt |  2 +-
 drivers/crypto/caam/jr.c          |  3 ---
 drivers/dma/ioat/dma_v2.c         |  3 +--
 drivers/dma/ioat/dma_v3.c         |  3 +--
 fs/dcache.c                       |  7 ++-----
 fs/overlayfs/super.c              |  4 +---
 include/linux/assoc_array_priv.h  | 11 +++++++----
 include/linux/hyperv.h            |  9 ++++-----
 include/linux/percpu-refcount.h   |  4 +---
 include/linux/rcupdate.h          | 10 +++++-----
 kernel/events/core.c              |  3 +--
 kernel/events/uprobes.c           |  8 ++++----
 kernel/seccomp.c                  |  7 +++----
 kernel/task_work.c                |  3 +--
 lib/assoc_array.c                 |  7 -------
 mm/ksm.c                          |  7 +++----
 mm/slab.h                         |  6 +++---
 net/ipv4/netfilter/arp_tables.c   |  3 +--
 net/ipv4/netfilter/ip_tables.c    |  3 +--
 net/ipv6/netfilter/ip6_tables.c   |  3 +--
 net/rxrpc/ar-ack.c                | 22 +++++++++-------------
 security/keys/keyring.c           |  6 ------
 22 files changed, 50 insertions(+), 84 deletions(-)

-- 
1.9.1

