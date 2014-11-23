Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaKWWWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 17:22:25 -0500
Received: from 1wt.eu ([62.212.114.60]:64586 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaKWWWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 17:22:23 -0500
Date: Sun, 23 Nov 2014 23:22:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.32.64
Message-ID: <20141123222221.GA18563@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.32.64.

The patch and changelog will appear soon at the following locations:
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.64.xz
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.64.gz
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/ChangeLog-2.6.32.64

The updated 2.6.32.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?h=linux-2.6.32.y

Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK            -
          i386 |    build:OK            -
           arm |      -             build:OK

Thanks to those who still take care of providing fixes, and to Greg
for the final packaging.

Willy

---------
 Documentation/lzo.txt               | 164 ++++++++++++++++
 Makefile                            |   2 +-
 arch/arm/lib/memset.S               | 100 +++++-----
 arch/mips/include/asm/thread_info.h |   3 +
 arch/mips/kernel/scall32-o32.S      |   2 +-
 arch/mips/kernel/scall64-64.S       |   2 +-
 arch/mips/kernel/scall64-n32.S      |   2 +-
 arch/mips/kernel/scall64-o32.S      |   2 +-
 arch/x86/include/asm/ptrace.h       |  16 ++
 arch/x86/kernel/entry_32.S          |  13 +-
 drivers/char/tty_io.c               |   7 +-
 drivers/md/dm-crypt.c               |  20 +-
 drivers/md/raid5.c                  |   2 +
 drivers/net/gianfar.c               |   6 -
 drivers/net/macvlan.c               |   1 +
 drivers/net/ppp_generic.c           |   2 +-
 drivers/net/pppoe.c                 |   2 +-
 drivers/net/sunvnet.c               |  20 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   4 +
 drivers/usb/serial/kobil_sct.c      |   4 +-
 drivers/usb/serial/option.c         | 129 ++++++++++++-
 fs/isofs/inode.c                    |  15 +-
 fs/isofs/isofs.h                    |  23 ++-
 fs/isofs/rock.c                     |  39 ++--
 fs/namei.c                          |   1 +
 fs/nfsd/nfs4xdr.c                   |   8 +-
 fs/proc/base.c                      |   1 -
 include/linux/lzo.h                 |  15 +-
 include/linux/ptrace.h              |   3 +
 include/net/sctp/sm.h               |   6 +-
 include/sound/core.h                |   2 +
 kernel/futex.c                      |   1 +
 kernel/trace/ring_buffer.c          |  12 +-
 lib/lzo/lzo1x_compress.c            | 335 ++++++++++++++++++--------------
 lib/lzo/lzo1x_decompress.c          | 370 +++++++++++++++++++-----------------
 lib/lzo/lzodefs.h                   |  38 ++--
 mm/mlock.c                          |   2 +
 mm/rmap.c                           |  14 +-
 net/appletalk/ddp.c                 |   3 -
 net/compat.c                        |   9 +-
 net/core/filter.c                   |   8 +-
 net/core/iovec.c                    |  10 +-
 net/core/skbuff.c                   |   2 +-
 net/ipv4/igmp.c                     |  10 +-
 net/ipv4/ip_options.c               |   4 +
 net/ipv4/tcp_input.c                |   2 +-
 net/ipv4/tcp_vegas.c                |   3 +-
 net/ipv4/tcp_veno.c                 |   2 +-
 net/netfilter/nfnetlink_log.c       |  14 +-
 net/sctp/associola.c                |  17 +-
 net/sctp/output.c                   |   2 +-
 net/sctp/sm_make_chunk.c            | 100 +++++-----
 net/sctp/sm_statefuns.c             |  18 +-
 net/sctp/ulpevent.c                 | 122 ++----------
 sound/core/control.c                |  38 +++-
 sound/core/init.c                   |   1 +
 56 files changed, 1092 insertions(+), 661 deletions(-)

Summary of changes from 2.6.32.63 to 2.6.32.64
==============================================
Al Viro (2):
      fix autofs/afs/etc. magic mountpoint breakage
      fix misuses of f_count() in ppp and netlink

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb

Andy Lutomirski (1):
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Christoph Paasch (2):
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christoph Schulz (1):
      net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann (3):
      net: sctp: fix information leaks in ulpevent layer
      net: sctp: inherit auth_capable on INIT collisions
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

Eric Dumazet (2):
      ipv4: fix buffer overflow in ip_options_compile()
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Florian Westphal (2):
      netfilter: nf_log: account for size of NLMSG_DONE attribute
      netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) optimizations

Jan Kara (1):
      isofs: Fix unbounded recursion when processing relocated directories

Johan Hovold (1):
      USB: kobil_sct: fix non-atomic allocation in write path

Lars-Peter Clausen (3):
      ALSA: control: Make sure that id->index does not overflow
      ALSA: control: Handle numid overflow
      ALSA: control: Protect user controls against concurrent access

Markos Chandras (1):
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Markus F.X.J. Oberhumer (1):
      lib/lzo: Update LZO compression to current upstream version

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Mikulas Patocka (2):
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue
      dm crypt: fix access beyond the end of allocated space

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

NeilBrown (1):
      md/raid6: avoid data corruption during recovery of double-degraded RAID6

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix

Peter Hurley (1):
      tty: Fix high cpu load if tty is unreleaseable

Ralf Baechle (1):
      MIPS: Cleanup flags in syscall flags handlers.

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiovecend

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Stefan Bader (1):
      x86_32, entry: Clean up sysenter_badsys declaration

Steven Rostedt (Red Hat) (1):
      ring-buffer: Always reset iterator to reader page

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

Willy Tarreau (4):
      Revert "nfsd: correctly handle return value from nfsd_map_name_to_*"
      Documentation: lzo: document part of the encoding
      lzo: check for length overrun in variable length encoding.
      Linux 2.6.32.64

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Zhu Yanjun (2):
      gianfar: disable vlan tag insertion by default
      sctp: not send SCTP_PEER_ADDR_CHANGE notifications with failed probe

dingtianhong (1):
      igmp: fix the problem when mc leave group

