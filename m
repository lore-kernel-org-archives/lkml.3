Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3KRSmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:42:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3KRSlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/12] 3.4.70-stable review
Date: Mon, 18 Nov 2013 10:41:33 -0800
Message-Id: <20131118184130.257996039@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.70 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Nov 20 18:41:11 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.70-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.70-rc1

Krzysztof Mazur <krzysiek@podlesie.net>
    usb: fix cleanup after failure in hub_configure()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Clear state_saved during suspend

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 7670/1: fix the memset fix

Ivan Djelic <ivan.djelic@parrot.com>
    ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) optimizations

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix potential out-of-bounds in trace_get_user()

Patrick McHardy <kaber@trash.net>
    netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Move one-time init codes from generic_hdmi_init()

Rui li <li.rui27@zte.com.cn>
    USB: add new zte 3g-dongle's pid to option.c

Nikhil P Rao <nikhil.rao@intel.com>
    PCI: fix truncation of resource size to 32 bits

Jason Wang <jasowang@redhat.com>
    net: flow_dissector: fail on evil iph->ihl

Wei Liu <wei.liu2@citrix.com>
    xen-netback: use jiffies_64 value to calculate credit timeout

Ben Hutchings <ben@decadent.org.uk>
    cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectures


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/arm/lib/memset.S                    | 100 +++++++++++++++----------------
 drivers/net/ethernet/chelsio/cxgb3/sge.c |   3 +-
 drivers/net/xen-netback/common.h         |   1 +
 drivers/net/xen-netback/interface.c      |   3 +-
 drivers/net/xen-netback/netback.c        |  10 ++--
 drivers/pci/pci-driver.c                 |   4 ++
 drivers/pci/setup-res.c                  |   3 +-
 drivers/usb/core/hub.c                   |   1 +
 drivers/usb/serial/option.c              |  17 ++++++
 kernel/trace/trace.c                     |   5 +-
 net/core/flow_dissector.c                |   2 +-
 net/netfilter/nf_conntrack_sip.c         |   2 +-
 sound/pci/hda/patch_hdmi.c               |  22 +++++--
 14 files changed, 106 insertions(+), 71 deletions(-)


