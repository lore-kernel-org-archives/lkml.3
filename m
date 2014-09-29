Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaI2XIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:08:45 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:46094 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751946AbaI2XIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:08:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:69:355:379:541:967:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:1801:1981:2194:2199:2393:2525:2553:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4605:5007:6119:6261:6742:7550:7875:8985:9025:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12679:12740:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: linen89_1161f366fa715
X-Filterd-Recvd-Size: 3550
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 0/7] seq_printf cleanups
Date: Mon, 29 Sep 2014 16:08:20 -0700
Message-Id: <cover.1412031505.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <20140929124246.3e39dac8@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seq_printf should return void.

Add a public bool seq_is_full function that can be used to shortcut
unnecesary seq_printf/seq_puts calls when the seq buffer is full.

Start removing the misuses of the seq_printf/seq_puts return value.

Patchset brought forward from an unreplied to set of changes from
back in December 2013.

https://lkml.org/lkml/2013/12/11/713

Renamed seq_is_buf_full to seq_is_full.

Joe Perches (7):
  seq_file: Rename static bool seq_overflow to public bool seq_is_full
  netfilter: Convert print_tuple functions to return void
  dlm: Use seq_is_full - remove seq_printf returns
  dlm: Use seq_puts, remove unnecessary trailing spaces
  fs: Convert show_fdinfo functions to void
  debugfs: Fix misuse of seq_printf return value
  docg3: Fix mixuse of seq_printf return value

 Documentation/filesystems/seq_file.txt       |  28 +--
 Documentation/filesystems/vfs.txt            |   2 +-
 drivers/mtd/devices/docg3.c                  | 112 ++++++------
 drivers/net/tun.c                            |   4 +-
 fs/debugfs/file.c                            |  14 +-
 fs/dlm/debug_fs.c                            | 260 +++++++++++++--------------
 fs/eventfd.c                                 |  15 +-
 fs/eventpoll.c                               |  19 +-
 fs/notify/fdinfo.c                           |  76 ++++----
 fs/notify/fdinfo.h                           |   4 +-
 fs/proc/fd.c                                 |   2 +-
 fs/seq_file.c                                |  28 +--
 fs/signalfd.c                                |  10 +-
 fs/timerfd.c                                 |  27 +--
 include/linux/fs.h                           |   2 +-
 include/linux/seq_file.h                     |   8 +
 include/net/netfilter/nf_conntrack_core.h    |   2 +-
 include/net/netfilter/nf_conntrack_l3proto.h |   4 +-
 include/net/netfilter/nf_conntrack_l4proto.h |   4 +-
 net/netfilter/nf_conntrack_l3proto_generic.c |   5 +-
 net/netfilter/nf_conntrack_proto_dccp.c      |  10 +-
 net/netfilter/nf_conntrack_proto_generic.c   |   5 +-
 net/netfilter/nf_conntrack_proto_gre.c       |  10 +-
 net/netfilter/nf_conntrack_proto_sctp.c      |  10 +-
 net/netfilter/nf_conntrack_proto_tcp.c       |  10 +-
 net/netfilter/nf_conntrack_proto_udp.c       |  10 +-
 net/netfilter/nf_conntrack_proto_udplite.c   |  10 +-
 net/netfilter/nf_conntrack_standalone.c      |  15 +-
 28 files changed, 333 insertions(+), 373 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty
