Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbbAOWKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:10:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbbAOWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y-ckt stable] Linux 3.13.11-ckt14 stable review
Date: Thu, 15 Jan 2015 14:09:36 -0800
Message-Id: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11-ckt14 stable kernel.

This version contains 19 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11-ckt14 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y-ckt extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/powerpc/platforms/cell/spufs/inode.c       |   2 +-
 arch/s390/kernel/compat_linux.c                 |   2 +-
 arch/x86/kernel/process_64.c                    | 101 +++++++++++++++++-------
 arch/x86/kernel/tls.c                           |  23 ++++++
 arch/x86/kvm/emulate.c                          |   4 +-
 arch/x86/vdso/vma.c                             |  43 ++++++----
 drivers/net/ethernet/intel/e1000e/netdev.c      |  20 +++--
 drivers/staging/lustre/lustre/llite/dcache.c    |   2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c |   2 +-
 drivers/staging/lustre/lustre/llite/namei.c     |   8 +-
 drivers/usb/gadget/at91_udc.c                   |  44 ++++++++---
 fs/affs/amigaffs.c                              |   2 +-
 fs/autofs4/expire.c                             |  12 +--
 fs/autofs4/root.c                               |   2 +-
 fs/ceph/dir.c                                   |   8 +-
 fs/ceph/inode.c                                 |   6 +-
 fs/cifs/inode.c                                 |   2 +-
 fs/coda/cache.c                                 |   2 +-
 fs/dcache.c                                     |  86 ++++++++++----------
 fs/debugfs/inode.c                              |   2 +-
 fs/exportfs/expfs.c                             |   2 +-
 fs/isofs/rock.c                                 |   9 +++
 fs/libfs.c                                      |  12 +--
 fs/ncpfs/dir.c                                  |   2 +-
 fs/ncpfs/ncplib_kernel.h                        |   4 +-
 fs/nfs/getroot.c                                |   2 +-
 fs/notify/fsnotify.c                            |   4 +-
 fs/ocfs2/dcache.c                               |   2 +-
 include/linux/cred.h                            |   1 +
 include/linux/dcache.h                          |   8 +-
 include/linux/user_namespace.h                  |   5 ++
 kernel/cgroup.c                                 |   2 +-
 kernel/groups.c                                 |  11 ++-
 kernel/trace/trace.c                            |   4 +-
 kernel/trace/trace_events.c                     |   2 +-
 kernel/uid16.c                                  |   2 +-
 kernel/user_namespace.c                         |  29 +++++--
 net/batman-adv/fragmentation.c                  |   2 +-
 net/ipv6/tcp_ipv6.c                             |   4 +-
 security/keys/gc.c                              |   4 +-
 security/selinux/selinuxfs.c                    |   6 +-
 41 files changed, 321 insertions(+), 169 deletions(-)

Al Viro (2):
      move d_rcu from overlapping d_child to overlapping d_alias
      deal with deadlock in d_walk()

Andy Lutomirski (3):
      x86/tls: Validate TLS entries to protect espfix
      x86_64, switch_to(): Load TLS descriptors before switching DS and ES
      x86_64, vdso: Fix the vdso address randomization algorithm

Andy Whitcroft (1):
      [3.13-stable only] ipv6: fix swapped ipv4/ipv6 mtu_reduced callbacks

David Ertman (1):
      e1000e: Fix no connectivity when driver loaded with cable out

Eric W. Biederman (6):
      userns: Check euid no fsuid when establishing an unprivileged uid mapping
      userns: Document what the invariant required for safe unprivileged mappings.
      userns: Only allow the creator of the userns unprivileged mappings
      groups: Consolidate the setgroups permission checks
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings

Jan Kara (2):
      isofs: Fix infinite looping over CE entries
      isofs: Fix unchecked printing of ER records

Nadav Amit (1):
      [3.13-stable only] KVM: x86: Fix far-jump to non-canonical check

Ronald Wahl (1):
      usb: gadget: at91_udc: move prepare clk into process context

Sasha Levin (1):
      KEYS: close race between key lookup and freeing

Sven Eckelmann (1):
      batman-adv: Calculate extra tail size based on queued fragments
