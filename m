Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaDYRQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:16:30 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33411 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaDYRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:16:27 -0400
Subject: [PATCH 0/4] x86/PCI HPET bugfix and other cleanups
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Bodo Eggert <7eggert@gmx.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 25 Apr 2014 11:16:23 -0600
Message-ID: <20140425171144.312.9601.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two are intended as a bugfix for a very old regression:
https://bugzilla.kernel.org/show_bug.cgi?id=68591 "pci=nocrs required to
boot Asrock M3A UCC".  Without "pci=nocrs", the system hangs during boot
when the PCI core moves the HPET.  Unfortunately I do not have testing
results from the reporter (ping, Bodo :)).

The third and fourth are minor cleanups, no functional change intended
except for the format of some AGP printks.

I intend these for v3.16.

---

Bjorn Helgaas (4):
      x86/PCI: Don't try to move IORESOURCE_PCI_FIXED resources
      x86/PCI: Mark HPET BAR as IORESOURCE_PCI_FIXED
      x86/PCI: Move pcibios_assign_resources() annotation to definition
      x86/gart: Tidy messages and add bridge device info


 arch/x86/kernel/aperture_64.c |   20 ++++++++++++--------
 arch/x86/pci/fixup.c          |   12 ++++++++++++
 arch/x86/pci/i386.c           |   27 ++++++++++++++++-----------
 3 files changed, 40 insertions(+), 19 deletions(-)
