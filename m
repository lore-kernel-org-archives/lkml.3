Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaGKTHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:07:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:46723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbaGKTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:07:19 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH v4] PCI back fixes for 3.17.
Date: Fri, 11 Jul 2014 16:08:47 -0400
Message-Id: <1405109332-31659-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see this set of patches which are fixes to Xen pciback
for 3.17. They are also located at:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pciback-3.17.v4 

These patches do not include the PCI bus reset/slot code as we are still
discussing that.

Konrad Rzeszutek Wilk (5):
      xen-pciback: Document the various parameters and attributes in SysFS
      xen/pciback: Don't deadlock when unbinding.
      xen/pciback: Include the domain id if removing the device whilst still in use
      xen/pciback: Print out the domain owning the device.
      xen/pciback: Remove tons of dereferences

                                                                                                                                                                                        Documentation/ABI/testing/sysfs-driver-pciback |   25 +++++++++++++++
 drivers/xen/xen-pciback/passthrough.c          |    9 ++++-
 drivers/xen/xen-pciback/pci_stub.c             |   41 +++++++++++++------------
 drivers/xen/xen-pciback/pciback.h              |    7 ++--
 drivers/xen/xen-pciback/vpci.c                 |    9 ++++-
 drivers/xen/xen-pciback/xenbus.c               |    4 +-
 6 files changed, 67 insertions(+), 28 deletions(-)

