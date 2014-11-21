Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaKUWSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:18:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaKUWSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:18:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, linux@eikelenboom.it
Subject: [PATCH v4] Fixes for PCI backend for 3.19
Date: Fri, 21 Nov 2014 17:17:44 -0500
Message-Id: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey,

The last time I posted these patches: https://lkml.org/lkml/2014/7/8/533
was so long ago that I don't even remember most comments. The only
one that stuck in mind was David's recommendation to add a new PCI API
call and use that. See patch #6 and #7.

The original posting (v3) had an extra patch that would do slot and
bus reset using do_flr SysFS attribute. I will revisit that once I am
done with this patchset.

I also seem to have had in my a bunch of 'SoB' from David - which
makes no sense - unless I pulled from his tree. Anyhow wherewere
I saw them I removed them.

Please take a look and comment. If I missed some comment from months
ago hopefully the new version has clarified them.


 drivers/pci/pci.c                     |  5 +--
 drivers/xen/xen-pciback/passthrough.c | 14 ++++++--
 drivers/xen/xen-pciback/pci_stub.c    | 60 ++++++++++++++++++++++-------------
 drivers/xen/xen-pciback/pciback.h     |  7 ++--
 drivers/xen/xen-pciback/vpci.c        | 14 ++++++--
 drivers/xen/xen-pciback/xenbus.c      |  4 +--
 include/linux/device.h                |  5 +++
 include/linux/pci.h                   |  2 ++
 8 files changed, 76 insertions(+), 35 deletions(-)

Konrad Rzeszutek Wilk (7):
      xen/pciback: Don't deadlock when unbinding.
      driver core: Provide an wrapper around the mutex to do lockdep warnings
      xen/pciback: Include the domain id if removing the device whilst still in use
      xen/pciback: Print out the domain owning the device.
      xen/pciback: Remove tons of dereferences
      PCI: Expose pci_load_saved_state for public consumption.
      xen/pciback: Restore configuration space when detaching from a guest.

