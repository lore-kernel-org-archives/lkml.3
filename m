Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaLNUkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:40:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaLNUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.18 00/19] 3.18.1-stable review
Date: Sun, 14 Dec 2014 12:21:11 -0800
Message-Id: <20141214201823.543296369@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.18.1 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Dec 16 20:18:16 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.18.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.18.1-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add EAPD fixup for ASUS Z99He laptop

Al Viro <viro@zeniv.linux.org.uk>
    deal with deadlock in d_walk()

Al Viro <viro@zeniv.linux.org.uk>
    move d_rcu from overlapping d_child to overlapping d_alias

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192ce: Fix missing interrupt ready flag

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192ce: Fix kernel crashes due to missing callback entry

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192ce: Fix editing error that causes silent memory corruption

Daniel Borkmann <dborkman@redhat.com>
    netlink: use jhash as hashfn for rhashtable

Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
    net: fix suspicious rcu_dereference_check in net/sched/sch_fq_codel.c

David Vrabel <david.vrabel@citrix.com>
    xen-netfront: use correct linear area after linearizing an skb

Eric Dumazet <edumazet@google.com>
    tcp: fix more NULL deref after prequeue changes

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: use MAX_HEADER for headroom reserve in output path

Eric Dumazet <edumazet@google.com>
    net: mvneta: fix race condition in mvneta_tx()

willy tarreau <w@1wt.eu>
    net: mvneta: fix Tx interrupt delay

Denis Kirjanov <kda@linux-powerpc.org>
    mips: bpf: Fix broken BPF_MOD

Pravin B Shelar <pshelar@nicira.com>
    openvswitch: Fix flow mask validation.

Tom Herbert <therbert@google.com>
    gre: Set inner mac header in gro complete

Marcelo Leitner <mleitner@redhat.com>
    Fix race condition between vxlan_sock_add and vxlan_sock_release


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/mips/net/bpf_jit.c                         |  4 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |  2 +-
 drivers/net/ethernet/marvell/mvneta.c           |  5 +-
 drivers/net/vxlan.c                             | 10 +---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c     |  3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c    | 24 ++++++--
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h    |  2 +
 drivers/net/xen-netfront.c                      |  3 +
 drivers/staging/lustre/lustre/llite/dcache.c    |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
 drivers/staging/lustre/lustre/llite/namei.c     |  8 +--
 fs/affs/amigaffs.c                              |  2 +-
 fs/autofs4/expire.c                             | 12 ++--
 fs/autofs4/root.c                               |  2 +-
 fs/ceph/dir.c                                   |  8 +--
 fs/ceph/inode.c                                 |  2 +-
 fs/cifs/inode.c                                 |  2 +-
 fs/coda/cache.c                                 |  2 +-
 fs/dcache.c                                     | 80 ++++++++++++-------------
 fs/debugfs/inode.c                              |  2 +-
 fs/exportfs/expfs.c                             |  2 +-
 fs/libfs.c                                      | 12 ++--
 fs/ncpfs/dir.c                                  |  2 +-
 fs/ncpfs/ncplib_kernel.h                        |  4 +-
 fs/nfs/getroot.c                                |  2 +-
 fs/notify/fsnotify.c                            |  4 +-
 fs/ocfs2/dcache.c                               |  2 +-
 include/linux/dcache.h                          |  8 +--
 kernel/trace/trace.c                            |  4 +-
 kernel/trace/trace_events.c                     |  2 +-
 net/ipv4/gre_offload.c                          |  3 +
 net/ipv4/tcp_ipv4.c                             |  4 +-
 net/ipv6/tcp_ipv6.c                             | 28 ++++-----
 net/netlink/af_netlink.c                        |  2 +-
 net/openvswitch/flow_netlink.c                  |  4 +-
 net/sched/sch_fq_codel.c                        |  2 +-
 net/sctp/output.c                               |  4 +-
 security/selinux/selinuxfs.c                    |  6 +-
 sound/pci/hda/patch_analog.c                    |  1 +
 sound/pci/hda/patch_realtek.c                   |  1 +
 sound/usb/midi.c                                |  2 +
 43 files changed, 156 insertions(+), 127 deletions(-)


