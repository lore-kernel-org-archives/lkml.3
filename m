Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaDAEGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:06:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDAEGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:06:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 0/9] 3.10.36-stable review
Date: Mon, 31 Mar 2014 21:08:14 -0700
Message-Id: <20140401040754.479538406@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.36 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr  3 04:07:29 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.36-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.36-rc1

Daniel Borkmann <dborkman@redhat.com>
    netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

David Rientjes <rientjes@google.com>
    mm: close PageTail race

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE

Artem Fetishev <artem_fetishev@epam.com>
    x86: fix boot on uniprocessor systems

Hans de Goede <hdegoede@redhat.com>
    Input: cypress_ps2 - don't report as a button pads

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add manual min/max quirk for ThinkPad X240

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: synaptics - add manual min/max quirk

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: mousedev - fix race when creating mixed device

Theodore Ts'o <tytso@mit.edu>
    ext4: atomically set inode->i_flags in ext4_set_inode_flags()


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/x86/include/asm/topology.h         |  3 +-
 drivers/block/aoe/aoecmd.c              |  2 +-
 drivers/input/mouse/cypress_ps2.c       |  1 -
 drivers/input/mouse/synaptics.c         | 55 +++++++++++++++++++++++++
 drivers/input/mousedev.c                | 73 +++++++++++++++++++--------------
 drivers/net/ethernet/marvell/mvneta.c   |  4 +-
 drivers/vfio/vfio_iommu_type1.c         |  4 +-
 fs/ext4/inode.c                         | 15 ++++---
 fs/proc/page.c                          |  2 +-
 include/linux/bitops.h                  | 15 +++++++
 include/linux/huge_mm.h                 | 18 --------
 include/linux/mm.h                      | 14 ++++++-
 mm/ksm.c                                |  2 +-
 mm/memory-failure.c                     |  2 +-
 mm/page_alloc.c                         |  4 +-
 mm/swap.c                               |  4 +-
 net/netfilter/nf_conntrack_proto_dccp.c |  6 +--
 virt/kvm/kvm_main.c                     |  4 +-
 19 files changed, 155 insertions(+), 77 deletions(-)


