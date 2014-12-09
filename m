Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaLIR7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:59:07 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:62671 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaLIR7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:59:05 -0500
Message-ID: <54873864.3050606@mvista.com>
Date: Tue, 09 Dec 2014 11:59:00 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        =?UTF-8?B?UGVyIEZvZ2Vsc3Ryw7Zt?= <per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Sanjeev <singhsan@codeaurora.org>, Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: [GIT PULL] ipmi driver updates
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull from:

git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus

For the following changes:
  - Quite a few bug fixes
  - A new driver for the powernv
  - A new driver for the SMBus interface from the IPMI 2.0 specification

These have been in linux-next for a while.

Thanks,

-corey

------------------------------------------
IPMI Updates for 3.19
------------------------------------------

Corey Minyard (17):
      ipmi: Ignore SSIF in the PNP handling
      ipmi: Move the address source to string to ipmi-generic code
      ipmi: clean up the device handling for the bmc device
      ipmi: Remove useless sysfs_name parameters
      ipmi: Fix a bug in hot add/remove
      ipmi: Use the proper type for acpi_handle
      ipmi: Initialize BMC device attributes
      ipmi: Fix handling of BMC flags
      ipmi: rename waiting_msgs to waiting_rcv_msgs
      ipmi: Move message sending into its own function
      ipmi: Make the message handler easier to use for SMI interfaces
      ipmi: Remove the now unnecessary message queue
      ipmi: Remove the now unused priority from SMI sender
      ipmi: Add SMBus interface driver (SSIF)
      ipmi: Periodically check to see if irqs and messages are set right
      ipmi: Fix attention handling for system interfaces
      ipmi: Check the BT interrupt enable periodically

Jeremy Kerr (2):
      powerpc/powernv: Add OPAL IPMI interface
      drivers/char/ipmi: Add powernv IPMI driver

trenn@suse.de (1):
      ipmi: Unregister previously registered driver in error case

------------------------------------------
diffstat
------------------------------------------

 Documentation/IPMI.txt                         |   74 +-
 arch/powerpc/include/asm/opal.h                |   17 +
 arch/powerpc/platforms/powernv/opal-wrappers.S |    2 +
 arch/powerpc/platforms/powernv/opal.c          |   14 +
 drivers/char/ipmi/Kconfig                      |   14 +
 drivers/char/ipmi/Makefile                     |    2 +
 drivers/char/ipmi/ipmi_msghandler.c            |  560 +++----
 drivers/char/ipmi/ipmi_powernv.c               |  310 ++++
 drivers/char/ipmi/ipmi_si_intf.c               |  497 ++++---
 drivers/char/ipmi/ipmi_ssif.c                  | 1870
++++++++++++++++++++++++
 include/linux/ipmi.h                           |    6 +-
 include/linux/ipmi_smi.h                       |   10 +-

