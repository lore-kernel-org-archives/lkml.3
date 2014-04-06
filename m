Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaDFXjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:39:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 00:35:47 +0100
Message-ID: <lsq.1396827347.462803115@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/18] 3.2.57-rc1 review
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.57 release.
There are 18 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 09 00:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.56 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Anisse Astier (1):
      deb-pkg: use KCONFIG_CONFIG instead of .config file directly
         [d20917670ee1fd4b090555e551faea04b014ca97]

Ben Hutchings (3):
      deb-pkg: Fix building for MIPS big-endian or ARM OABI
         [c5e318f67eebbad491615a752c51dbfde7dc3d78]
      deb-pkg: Fix cross-building linux-headers package
         [f8ce239dfc7ba9add41d9ecdc5e7810738f839fa]
      staging: speakup: Prefix set_mask_bits() symbol
         [ca2beaf84d9678c12b17d92623f0e90829d6ca13]

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk
         [421e08c41fda1f0c2ff6af81a67b491389b653a5]

Daniel Borkmann (1):
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages
         [b22f5126a24b3b2f15448c3f2a254fc10cbc2b92]

Emil Goode (2):
      net: asix: add missing flag to struct driver_info
         [d43ff4cd798911736fb39025ec8004284b1b0bc2]
      net: asix: handle packets crossing URB boundaries
         [8b5b6f5413e97c3e8bafcdd67553d508f4f698cd]

Eric Dumazet (1):
      asix: asix_rx_fixup surgery to reduce skb truesizes
         [a9e0aca4b37885b5599e52211f098bd7f565e749]

Florian Westphal (2):
      net: add and use skb_gso_transport_seglen()
         [de960aa9ab4decc3304959f69533eef64d05d8e8]
      net: ip, ipv6: handle gso skbs in forwarding path
         [fe6cc55f3a9a053482a76f5a6b2257cee51b4663]

Hans de Goede (1):
      Input: synaptics - add manual min/max quirk for ThinkPad X240
         [8a0435d958fb36d93b8df610124a0e91e5675c82]

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly
         [5d81de8e8667da7135d3a32a964087c0faf5483f]

Konstantin Khlebnikov (1):
      ipc/msg: fix race around refcount
         [6062a8dc0517bce23e3c2f7d2fea5e22411269a3]

Marcelo Tosatti (2):
      KVM: MMU: handle invalid root_hpa at __direct_map
         [989c6b34f6a9480e397b170cc62237e89bf4fdb9]
      KVM: VMX: fix use after free of vmx->loaded_vmcs
         [26a865f4aa8e66a6d94958de7656f7f1b03c6c56]

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions
         [8d7f6690cedb83456edd41c9bd583783f0703bf0]

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()
         [00a1a053ebe5febcfc2ec498bd894f035ad2aa06]

 Makefile                                |   4 +-
 arch/s390/kernel/head64.S               |   7 +-
 arch/x86/kvm/mmu.c                      |   3 +
 arch/x86/kvm/vmx.c                      |   2 +-
 drivers/input/mouse/synaptics.c         |  55 ++++++++++
 drivers/net/usb/asix.c                  | 174 ++++++++++++++++++--------------
 drivers/staging/speakup/kobjects.c      |   4 +-
 drivers/staging/speakup/main.c          |   2 +-
 drivers/staging/speakup/speakup.h       |   2 +-
 drivers/staging/speakup/varhandlers.c   |   4 +-
 fs/cifs/file.c                          |  33 +++++-
 fs/ext4/inode.c                         |  15 +--
 include/linux/bitops.h                  |  15 +++
 include/linux/skbuff.h                  |  19 ++++
 ipc/msg.c                               |   2 +
 net/core/skbuff.c                       |  25 +++++
 net/ipv4/ip_forward.c                   |  68 ++++++++++++-
 net/ipv6/ip6_output.c                   |  13 ++-
 net/netfilter/nf_conntrack_proto_dccp.c |   6 +-
 scripts/package/builddeb                |  22 ++--
 20 files changed, 361 insertions(+), 114 deletions(-)

-- 
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

