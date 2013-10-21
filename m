Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3JUK6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:58:07 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60486 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3JUK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:58:05 -0400
Date: Mon, 21 Oct 2013 11:58:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] libata fixes v3.12-rc6
Message-ID: <20131021105800.GB26917@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

libata fixes.  The only interesting bit is ata_eh_qc_retry() update
which fixes a problem where a SG_IO command may fail across
suspend/resume cycle without the command actually being at fault.
Other changes are low level driver specific and fairly low impact.

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.12-fixes

for you to fetch changes up to fa070ee6dc70bcc19737a2406d741b089b3149d5:

  libahci: fix turning on LEDs in ahci_start_port() (2013-10-15 09:39:57 -0400)

Thanks.

----------------------------------------------------------------
Gwendal Grignou (1):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Jingoo Han (2):
      ahci: use dev_info() instead of printk()
      ahci_platform: use dev_info() instead of printk()

Lukasz Dorau (1):
      libahci: fix turning on LEDs in ahci_start_port()

Ondrej Zary (1):
      pata_isapnp: Don't use invalid I/O ports

 drivers/ata/ahci.c          |  2 +-
 drivers/ata/ahci_platform.c |  2 +-
 drivers/ata/libahci.c       | 10 +++++++++-
 drivers/ata/libata-eh.c     |  6 +++---
 drivers/ata/pata_isapnp.c   |  2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

--
tejun
