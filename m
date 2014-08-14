Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaHNVpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:45:50 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64492 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaHNVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:45:48 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] sb_edac: i2c_imc staging submission prep
Date: Thu, 14 Aug 2014 14:45:39 -0700
Message-Id: <cover.1408051536.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to submit my i2c_imc driver to -staging, but the sb_edac
driver is currently squatting on my pci id :) sb_edac is a strange
beast: it uses registers from several PCI devcies, but the one that
it registers with the driver core is the SMBUS controller.

This trivial series moves sb_edac's PCI ids to pci_ids.h (they're
not exclusive to the EDAC hardware) and changes the PCI ID that is
used to detect the EDAC hardware.

I think that i2c_imc is a good staging candidate: the driver is IMO
quite clean, the hardware is very common, and I know of some users
(unrelated to me!) that use it for development, but it's not yet
acceptable as a real driver.  In particular, it needs confirmation
from Intel as to whether it handshakes correctly with BIOS.  In the
mean time, it's perfectly safe to use *if you know that your system
isn't doing something special with its DIMM SMBUS registers*.

I have reason to believe that I may be able to get a information
or a review from the right people at Intel in a couple of months,
and I suspect that some people in the NV-DIMM community would be
interested in this stuff.

I realize that the timing is a bit awkward here.  These patches have
been floating around for almost a year.  I'd be okay with them going
in for 3.17 or 3.18.  If I understand correctly, the deadline for
staging drivers is much later than the merge window, but I don't
want to submit the i2c_imc driver itself to staging until these prep
patches are in.

Andy Lutomirski (2):
  Move Intel SNB device ids from sb_edac to pci_ids.h
  sb_edac: Claim a different PCI device

 drivers/edac/sb_edac.c  | 32 +-------------------------------
 include/linux/pci_ids.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 31 deletions(-)

-- 
1.9.3

