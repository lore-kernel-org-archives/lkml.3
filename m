Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaJaQyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:54:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:52717 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaJaQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:54:48 -0400
Date: Fri, 31 Oct 2014 10:54:44 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Zhu <r65037@freescale.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [GIT PULL] PCI fixes for v3.18
Message-ID: <20141031165444.GA6168@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These changes, intended for v3.18, fix:

  - An unintentional sysfs filename change.  5136b2da770d, which appeared
    in v3.13, changed "enable" to "enabled", and this changes it back.  Old
    users of "enable" are currently broken and will be helped by this
    change.  Anything that started to use "enabled" after v3.13 will be
    broken by this change.  If necessary, we can add a symlink to make both
    work, but this patch doesn't do that.

    See http://lkml.kernel.org/r/20141030163028.GA22250@kroah.com ("[PATCH]
    PCI: fix name of 'enable' sysfs file").

  - An i.MX6 clock problem that prevents mx6 nitrogen boards from booting.

  - A mistaken duplicate merge that added a check twice.  Nothing's broken;
    this just removes the unnecessary code.

Bjorn


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.18-fixes-1

for you to fetch changes up to d8e7d53a2fc14e0830ab728cb84ee19933d3ac8d:

  PCI: Rename sysfs 'enabled' file back to 'enable' (2014-10-30 11:17:10 -0600)

----------------------------------------------------------------
PCI updates for v3.18:

  Sysfs
    - Fix "enable" filename change (Greg Kroah-Hartman)

  PCI device hotplug
    - Revert duplicate merge (Kamal Mostafa)

  Freescale i.MX6
    - Wait for clocks to stabilize after ref_en (Richard Zhu)

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      PCI: Rename sysfs 'enabled' file back to 'enable'

Kamal Mostafa (1):
      Revert duplicate "PCI: pciehp: Prevent NULL dereference during probe"

Richard Zhu (1):
      PCI: imx6: Wait for clocks to stabilize after ref_en

 drivers/pci/host/pci-imx6.c       | 13 ++++++++++---
 drivers/pci/hotplug/pciehp_core.c |  7 -------
 drivers/pci/pci-sysfs.c           |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)
