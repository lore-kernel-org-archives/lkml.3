Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3KSVfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:35:44 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36609 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3KSVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:35:40 -0500
Subject: [PATCH v2 0/3] PCIe Capability accessor fixes [stable backports]
To: stable@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        linux-kernel@vger.kernel.org, Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Date: Tue, 19 Nov 2013 14:35:37 -0700
Message-ID: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix issues reported by Yuval Mintz
<yuvalmin@broadcom.com> and Myron Stowe <myron.stowe@redhat.com>.

These fix pcie_capability_read_dword() and related accessors, which first
appeared in v3.7.  I backported these to v3.10.19 because that appears to
be the oldest maintained stable kernel that is affected.

These patches replace the ones I posted yesterday at [1], because Myron
pointed out that an additional patch, "Remove PCIe Capability version
checks," is needed to fix the issue he found [2].

[1] http://lkml.kernel.org/r/20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com
[2] https://bugzilla.kernel.org/show_bug.cgi?id=65211


---

Bjorn Helgaas (3):
      PCI: Allow PCIe Capability link-related register access for switches
      PCI: Remove PCIe Capability version checks
      PCI: Support PCIe Capability Slot registers only for ports with slots


 drivers/pci/access.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)
