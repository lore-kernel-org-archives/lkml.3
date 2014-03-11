Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaCKRsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:48:07 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37716 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaCKRsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:48:04 -0400
Subject: [PATCH] PCI: INTx disable fix
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Chris Cheng <chris.cheng@atrustcorp.com>,
        Jamie Chen <jamie.chen@intel.com>,
        Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 11 Mar 2014 11:48:02 -0600
Message-ID: <20140311174555.23257.66798.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My earlier "Enable INTx if BIOS left them disabled" patch fixed a problem
with EHCI devices on Intel Baytrail platforms, but had the unintended
consequence of breaking pciehp surprise removal.

This patch should fix the pciehp issue.

This is in my pci/misc branch and intended for v3.14.

---

Bjorn Helgaas (1):
      PCI: Do not enable INTx in pci_reenable_device()


 drivers/pci/pci.c |    3 +++
 1 file changed, 3 insertions(+)
