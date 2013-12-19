Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3LSUns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:43:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35722 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3LSUnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:43:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 0/2] PCI: allocate 64bit mmio pref
Date: Thu, 19 Dec 2013 12:44:01 -0800
Message-Id: <1387485843-17403-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmio 64 allocation that could help Guo Chao <yan@linux.vnet.ibm.com> on powerpc mmio allocation.
It will try to assign 64 bit resource above 4g at first.

And it is based on current pci/next and pci/resource.

-v2: update after patch that move device_del down to pci_destroy_dev.
     add "Try best to allocate pref mmio 64bit above 4G"

-v3: refresh and send out after pci_clip_resource() changes,
     as Bjorn is not happy with attachments.

-v4: make pcibios_resource_to_bus take bus directly.

-v5: fix non-pref mmio64 allocation problem found by Guo Chao.
     refresh last three as Bjorn update first two and put them in pci/resource

-v6: try above 4G at first, then restart again for under 4G.
     so we can drop patch that sort pci root bus resource list.

Yinghai Lu (2):
  PCI: Try to allocate mem64 above 4G at first
  PCI: Try best to allocate pref mmio 64bit above 4g

 drivers/pci/bus.c       |  34 ++++++++----
 drivers/pci/setup-bus.c | 138 ++++++++++++++++++++++++++++++++----------------
 drivers/pci/setup-res.c |  20 ++++++-
 3 files changed, 135 insertions(+), 57 deletions(-)

-- 
1.8.4

