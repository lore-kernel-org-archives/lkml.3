Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935640Ab3DKJ3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:29:48 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36824 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383Ab3DKJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:29:45 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Florian Fainelli <florian@openwrt.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] net: mv643xx_eth: use managed clk and allocation
Date: Thu, 11 Apr 2013 11:29:32 +0200
Message-Id: <1365672574-31123-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With introduction of common clock framework and the ability to provide
gated clocks, mv643xx_eth required calls to get and enable these clock
gates on some platforms. Back then, common clock framework api wasn't
safe for architectures without support for common clocks. This has
changed now and there are also managed (devm_) counterparts for clock
related functions.

The second patch in this series, also converts kzalloc to devm_kzalloc
where applicable.

Both patches have been sent to the corresponding mailing lists as
individual patches before. To get the order required to apply them right,
this patch set combines both patches into one set.

Sebastian Hesselbarth (2):
  net: mv643xx_eth: add shared clk and cleanup existing clk handling
  net: mv643xx_eth: use managed devm_kzalloc

 Documentation/devicetree/bindings/marvell.txt |    3 ++
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   44 +++++++++----------------
 2 files changed, 18 insertions(+), 29 deletions(-)

---
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
-- 
1.7.10.4

