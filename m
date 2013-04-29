Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3D2Tq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:46:26 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:52586 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761132Ab3D2TqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:46:15 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 0/3] Add support for velocity network driver on platform devices
Date: Tue, 30 Apr 2013 07:46:09 +1200
Message-Id: <1367264772-4557-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 changes:
Rebased against net-next.
Fix errors in pm code.

v2 changes:
Drop patch #1 as requested by David Miller.
Correct the PHYID_ICPLUS_IP101A MII bits - should be ON, rather than OFF.
Read the platform rev_id from the correct register [regs->rev_id]. It's possible
this would work for the PCI version as well and would remove the need for the
'if (pci)' test to set vptr->rev_id.

v1:
The first three patches are general tidyup.

[DROPPED] Patch ## just alphabetizes the #includes to make it easier to read.

Patch #1 replaces vptr->dev with vptr->netdev, in preparation of adding a
struct device *dev in Patch #3

Patch #2 replaces the pci dma functions with the generic versions.

I have build tested these patches but don't have a PCI velocity to run-test it.
I can't see that they should introduce any problems as it is all renames and
function swapping.

Patch #3 adds support for the velocity driver on devicetree platform devices.
Binding document included. This patch is compile-tested for PCI, and boot
tested on a VIA APC8750.

I think it would be pertinent to get some tested-by's for PCI users.

Regards
Tony Prisk

Tony Prisk (3):
  net: velocity: Rename vptr->dev to vptr->netdev
  net: velocity: Convert to generic dma functions
  net: velocity: Add platform device support to VIA velocity driver

 .../devicetree/bindings/net/via-velocity.txt       |   20 +
 drivers/net/ethernet/via/Kconfig                   |    3 +-
 drivers/net/ethernet/via/via-velocity.c            |  563 ++++++++++++++------
 drivers/net/ethernet/via/via-velocity.h            |   35 +-
 4 files changed, 454 insertions(+), 167 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/via-velocity.txt

-- 
1.7.9.5

