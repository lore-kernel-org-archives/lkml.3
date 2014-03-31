Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaCaD50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:57:26 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:45176 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaCaD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:57:24 -0400
MIME-Version: 1.0
Date: Sun, 30 Mar 2014 20:57:23 -0700
X-Google-Sender-Auth: Bn6x2RmXUiC8nWzVGvMneg-Xzmw
Message-ID: <CA+55aFw5-PSWjw8vRx9Z+taT3iNsOL8wc7_M47fdwTXsHRUgsQ@mail.gmail.com>
Subject: Linux 3.14 out
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we had a few fairly late changes that I could have done without,
but the changelog from -rc8 is still pretty small, and I'm feeling
pretty good about it all. If we did end up with any last-minute
problems due to the final spurt of patches, they'll be pretty
specific, and it really didn't make sense to me to delay the release
without anything known pending. Much of the final spurt were either
marked for stable or known regressions.

So 3.14 is out there, and the merge window for 3.15 is thus open.
Please do spend the time to test out 3.14, though, even if you might
otherwise be in a hurry to send me your pending queue for the next
release.

           Linus

---
Al Viro (6):
      make prepend_name() work correctly when called with negative *buflen
      rcuwalk: recheck mount_lock after mountpoint crossing attempts
      resizable namespace.c hashes
      keep shadowed vfsmounts together
      don't bother with propagate_mnt() unless the target is shared
      switch mnt_hash to hlist

Alex Elder (1):
      rbd: drop an unsafe assertion

Anthony Olech (1):
      Input: da9052_onkey - use correct register bit for key status

Artem Fetishev (1):
      x86: fix boot on uniprocessor systems

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Daniel Vetter (1):
      drm/i915: Undo gtt scratch pte unmapping again

Dave Airlie (3):
      drm/udl: take reference to device struct for dma-bufs
      drm/nouveau: fail runtime pm properly.
      drm/radeon: fix runtime suspend breaking secondary GPUs

David Vrabel (1):
      Revert "xen: properly account for _PAGE_NUMA during xen pte translations"

Dmitry Torokhov (1):
      Input: mousedev - fix race when creating mixed device

Elias Vanderstuyft (1):
      Input: don't modify the id of ioctl-provided ff effect on upload failure

Eric Biggers (2):
      vfs: atomic f_pos access in llseek()
      vfs: Don't let __fdget_pos() get FMODE_PATH files

Eric Dumazet (2):
      net: unix: non blocking recvmsg() should not return -EINTR
      tcp: fix get_timewait4_sock() delay computation on 64bit

Eric Paris (1):
      AUDIT: Allow login in non-init namespaces

Flavio Leitner (1):
      openvswitch: fix a possible deadlock and lockdep warning

Hannes Frederic Sowa (1):
      ipv6: move DAD and addrconf_verify processing to workqueue

Hans de Goede (2):
      Input: cypress_ps2 - don't report as a button pads
      Input: synaptics - add manual min/max quirk for ThinkPad X240

J. R. Okajima (1):
      nfsd: fix lost nfserrno() call in nfsd_setattr()

Jan Kara (2):
      fs: Avoid userspace mounting anon_inodefs filesystem
      vfs: Allocate anon_inode_inode in anon_inode_init()

Jason Wang (1):
      virtio-net: correct error handling of virtqueue_kick()

Jay Vosburgh (1):
      MAINTAINERS: bonding: change email address

Jean-Francois Dagenais (1):
      Input: adp5588-keys - get value from data out when dir is out

John Stultz (1):
      time: Revert to calling clock_was_set_delayed() while in irq context

Linus Torvalds (2):
      fs: remove now stale label in anon_inode_init()
      Linux 3.14

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Oliver Neukum (1):
      usbnet: include wait queue head in device structure

Pravin B Shelar (1):
      ip_tunnel: Fix dst ref-count.

Randy Dunlap (1):
      MAINTAINERS: resume as Documentation maintainer

Sasha Levin (3):
      random32: assign to network folks in MAINTAINERS
      random32: avoid attempt to late reseed if in the middle of seeding
      ocfs2: check if cluster name exists before deref

Scott Wood (1):
      i2c: cpm: Fix build by adding of_address.h and of_irq.h

Steven Rostedt (Red Hat) (1):
      tracing: Fix traceon trigger condition to actually turn tracing on

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Thomas Petazzoni (3):
      net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
      net: mvneta: fix usage as a module on RGMII configurations
      net: mvneta: use devm_ioremap_resource() instead of of_iomap()

Toshiaki Makita (2):
      bridge: Fix inabillity to retrieve vlan tags when tx offload is disabled
      bridge: Fix handling stacked vlan tags

Veaceslav Falico (1):
      MAINTAINERS: bonding: change email address

Vlad Yasevich (8):
      tg3: Do not include vlan acceleration features in vlan_features
      vlan: Set hard_header_len according to available acceleration
      net: Account for all vlan headers in skb_mac_gso_segment
      bridge: Fix crash with vlan filtering and tcpdump
      qlge: Do not propaged vlan tag offloads to vlans
      ifb: Remove vlan acceleration from vlan_features
      veth: Turn off vlan rx acceleration in vlan_features
      vlan: Warn the user if lowerdev has bad vlan features.

Wei Liu (1):
      xen/balloon: flush persistent kmaps in correct position

Wei Yang (1):
      net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one
during reset

Zoltan Kiss (1):
      core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle errors
