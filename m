Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3E3S6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:58:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab3E3S6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:58:39 -0400
Date: Thu, 30 May 2013 14:58:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.10-rc3-tag
Message-ID: <20130530185831.GA2459@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.10-rc3-tag

which has various bug-fixes and cleanups. Nothing earth-shattering.
The signed tag has more details and including it here:
<signed tag>
Fixes:
 - Use proper error paths
 - Clean up APIC IPI usage (incorrect arguments)
 - Delay XenBus frontend resume is backend (xenstored) is not running
 - Fix build error with various combinations of CONFIG_*
</signed tag>

Thank you!

 arch/x86/xen/smp.c                         | 10 ++++----
 arch/x86/xen/smp.h                         |  1 -
 drivers/xen/tmem.c                         |  2 ++
 drivers/xen/xen-pciback/pci_stub.c         |  4 ++--
 drivers/xen/xenbus/xenbus_client.c         |  5 ++--
 drivers/xen/xenbus/xenbus_comms.h          |  1 +
 drivers/xen/xenbus/xenbus_probe.c          | 27 ++++++++++------------
 drivers/xen/xenbus/xenbus_probe.h          |  7 ++++++
 drivers/xen/xenbus/xenbus_probe_frontend.c | 37 +++++++++++++++++++++++++++++-
 include/xen/xenbus.h                       |  1 +
 10 files changed, 68 insertions(+), 27 deletions(-)

Aurelien Chartier (2):
      xenbus: delay xenbus frontend resume if xenstored is not running
      xenbus: save xenstore local status for later use

Frederico Cadete (1):
      xmem/tmem: fix 'undefined variable' build error.

Jan Beulich (1):
      xen-pciback: more uses of cached MSI-X capability offset

Stefan Bader (1):
      xen: Clean up apic ipi interface

Wei Liu (1):
      xenbus_client.c: correct exit path for xenbus_map_ring_valloc_hvm

