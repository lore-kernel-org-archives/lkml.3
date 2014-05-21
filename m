Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaEUVjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:39:07 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46063 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaEUVjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:39:04 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...)
Subject: [PATCH RESEND 0/9 net-next] net: of_phy_connect_fixed_link removal
Date: Wed, 21 May 2014 14:38:42 -0700
Message-Id: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set removes of_phy_connect_fixed_link() from the tree now that
we have a better solution for dealing with fixed PHY (emulated PHY) devices
for drivers that require them.

First two patches update the 'fixed-link' Device Tree binding and drivers to
refere to it.

Patches 3 to 7 update the in-tree network drivers that use
of_phy_connect_fixed_link()

Patch 8 removes of_phy_connect_fixed_link

Patch 9 removes the PowerPC code that parsed the 'fixed-link' property.

Patch 9 can be merged via the net-next tree if the PowerPC folks ack it,
but it really has to be merged after the first 8 patches in order to avoid
breakage.

Florian Fainelli (9):
  Documentation: devicetree: add old and deprecated 'fixed-link'
  Documentation: devicetree: net: refer to fixed-link.txt
  net: bcmgenet: use the new fixed PHY helpers
  net: systemport: use the new fixed PHY helpers
  fs_enet: use the new fixed PHY helpers
  gianfar: use the new fixed PHY helpers
  ucc_geth: use the new fixed PHY helpers
  of: mdio: remove of_phy_connect_fixed_link
  powerpc/fsl: fsl_soc: remove 'fixed-link' parsing code

 .../devicetree/bindings/net/broadcom-bcmgenet.txt  |  2 +-
 .../bindings/net/broadcom-systemport.txt           |  2 +-
 .../devicetree/bindings/net/fixed-link.txt         | 12 +++++++
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |  5 +--
 arch/powerpc/sysdev/fsl_soc.c                      | 32 ------------------
 drivers/net/ethernet/broadcom/bcmsysport.c         | 17 ++++++++--
 drivers/net/ethernet/broadcom/bcmsysport.h         |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 21 +++++++-----
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  | 16 +++++----
 drivers/net/ethernet/freescale/gianfar.c           | 14 ++++++--
 drivers/net/ethernet/freescale/ucc_geth.c          | 14 ++++++--
 drivers/of/of_mdio.c                               | 38 ----------------------
 include/linux/of_mdio.h                            | 10 ------
 13 files changed, 75 insertions(+), 109 deletions(-)

-- 
1.9.1

