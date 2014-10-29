Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaJ2Rwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:52:38 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:51755 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaJ2Rp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:29 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 00/15] net: dsa: Fixes and enhancements
Date: Wed, 29 Oct 2014 10:44:52 -0700
Message-Id: <1414604707-22407-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.545127B9.0150,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 24
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 01/15 addresses a bug indicated by an an annoying and unhelpful
log message.

Patches 02/15 and 03/15 are minor enhancements, adding support for
known switch revisions.

Patches 04/15 and 05/15 add support for MV88E6352 and MV88E6176.

Patch 06/15 adds support for hardware monitoring, specifically for
reporting the chip temperature, to the dsa subsystem.

Patches 07/15 and 08/15 implement hardware monitoring for MV88E6352,
MV88E6176, MV88E6123, MV88E6161, and MV88E6165.

Patch 09/15 and 10/15 add support for EEPROM access to the DSA subsystem.

Patch 11/15 implements EEPROM access for MV88E6352 and MV88E6176.

Patch 12/15 adds support for reading switch registers to the DSA
subsystem.

Patches 13/15 amd 14/15 implement support for reading switch registers
to the drivers for MV88E6352, MV88E6176, MV88E6123, MV88E6161, and MV88E6165.

Patch 15/15 adds support for reading additional RMON registers to the drivers
for  MV88E6352, MV88E6176, MV88E6123, MV88E6161, and MV88E6165.

The series was tested on top of v3.18-rc2 in an x86 system with MV88E6352.
Testing in systems with 88E6131, 88E6060 and MV88E6165 was done earlier
(I don't have access to those systems right now). The series was also build
tested using my build system at http://server.roeck-us.net:8010/builders.
Look into the 'dsa' column for build results.

The series merges cleanly into net-next as of today (10/29).

v3:
- Fix bug in eeprom patches seen if devicetree is enabled:
  eeprom-length property is attached to switch devicetree node,
  not to dsa node, and there was a compile error.
v2:
- Made reporting chip temperatures through the hwmon subsystem optional
  with new Kconfig option
- Changed the hwmon chip name to <network device name>_dsa<index>
- Made EEPROM presence and size configurable through platform and devicetree
  data
- Various minor changes and fixes (see individual patches for details)

----------------------------------------------------------------
The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git dsa

for you to fetch changes up to 245472a4f3ca2a68c5632f2c37da41aa2d3fb2f0:

  net: dsa: Provide additional RMON statistics (2014-10-29 08:55:37 -0700)

----------------------------------------------------------------
Guenter Roeck (15):
      net: dsa: Don't set skb->protocol on outgoing tagged packets
      net: dsa: Report known silicon revisions for Marvell 88E6060
      net: dsa: Report known silicon revisions for Marvell 88E6131
      net: dsa: Add support for Marvell 88E6352
      net: dsa/mv88e6352: Add support for MV88E6176
      net: dsa: Add support for reporting switch chip temperatures
      net: dsa/mv88e6352: Report chip temperature
      net: dsa/mv88e6123_61_65: Report chip temperature
      net: dsa: Add support for switch EEPROM access
      dsa: Add new optional devicetree property to describe EEPROM size
      net: dsa/mv88e6352: Implement EEPROM access functions
      net: dsa: Add support for reading switch registers with ethtool
      net: dsa/mv88e6123_61_65: Add support for reading switch registers
      net: dsa/mv88e6352: Add support for reading switch registers
      net: dsa: Provide additional RMON statistics

 Documentation/devicetree/bindings/net/dsa/dsa.txt |   9 +-
 MAINTAINERS                                       |   5 +
 drivers/net/dsa/Kconfig                           |   9 +
 drivers/net/dsa/Makefile                          |   3 +
 drivers/net/dsa/mv88e6060.c                       |   5 +-
 drivers/net/dsa/mv88e6123_61_65.c                 |  73 +-
 drivers/net/dsa/mv88e6131.c                       |  12 +-
 drivers/net/dsa/mv88e6352.c                       | 788 ++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx.c                       |  53 +-
 drivers/net/dsa/mv88e6xxx.h                       |  15 +
 include/net/dsa.h                                 |  33 +
 net/dsa/Kconfig                                   |  11 +
 net/dsa/dsa.c                                     | 135 ++++
 net/dsa/slave.c                                   |  64 ++
 net/dsa/tag_dsa.c                                 |   2 -
 net/dsa/tag_edsa.c                                |   2 -
 net/dsa/tag_trailer.c                             |   2 -
 17 files changed, 1202 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6352.c
