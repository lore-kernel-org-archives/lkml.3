Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaDVP2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:28:34 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62360 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaDVP2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:28:31 -0400
From: Alexey Charkov <alchark@gmail.com>
To: rl@hellgate.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@prisktech.co.nz,
        robh+dt@kernel.org, davem@davemloft.net, ben@decadent.org.uk
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH v2 0/3] net: via-rhine: add support for on-chip Rhine controllers
Date: Tue, 22 Apr 2014 19:28:06 +0400
Message-Id: <1398180489-20230-1-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1390823503-24087-1-git-send-email-alchark@gmail.com>
References: <1390823503-24087-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces platform bus (OpenFirmware) binding for 
via-rhine, as used in various ARM-based Systems-on-Chip by 
VIA/WonderMedia.

This has been tested in OF configuration by myself on a WM8950-based VIA 
APC Rock development board and on a WM8850-based netbook, and in PCI
configuration by Roger.

Please note that the initial version of these patches was signed off by
Roger, but some time has passed since then, so I'm not including his
sign-off until explicit notice.

David, could you please take these to net-next if appropriate?

Thanks a lot,
Alexey

Changes since v1:
 - Fixed indentation of function arguments
 - Switched to 'dev_is_pci' instead of string comparison on bus name
 - Dropped 'rhine,revision' DT attribute, put the revision into OF match
        table instead
 - Included actual device tree nodes where applicable

Alexey Charkov (3):
  net: via-rhine: switch to generic DMA functions
  net: via-rhine: reduce usage of the PCI-specific struct
  net: via-rhine: add OF bus binding

 .../devicetree/bindings/net/via-rhine.txt          |  17 +
 arch/arm/boot/dts/vt8500.dtsi                      |   6 +
 arch/arm/boot/dts/wm8650.dtsi                      |   6 +
 arch/arm/boot/dts/wm8850.dtsi                      |   6 +
 drivers/net/ethernet/via/Kconfig                   |   2 +-
 drivers/net/ethernet/via/via-rhine.c               | 444 ++++++++++++---------
 6 files changed, 302 insertions(+), 179 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/via-rhine.txt

-- 
1.9.1

