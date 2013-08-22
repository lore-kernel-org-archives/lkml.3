Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3HVMeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:34:04 -0400
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:45583 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3HVMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:34:01 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: "David S. Miller" <davem@davemloft.net>, Mark Brown <broonie@kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [RFC PATCH] phylib: mdio: handle register/unregister/register sequence
Date: Thu, 22 Aug 2013 14:33:56 +0200
Message-Id: <1377174836-10569-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 375487619375462437
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500002/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch is a proposal to support the register/unregister/register
sequence on a given mdio bus.

I use the register/unregister/register sequence to add a fallback when the
of_mdiobus_register (this function calls mdiobus_register with phy_mask
set to ~0) does not register any phy device (because the device tree does
not define any phy).
In this case I call mdiobus_unregister and then call mdiobus_register with
a phy_mask set to 0 to trigger a full mdio bus scan.

I'm not sure this is the right way to do it (this is why I added RFC in the
subject).

Could someone help me figuring out what I should use to implement my fallback ?

1) use the register/unregister/register sequence
2) reimplement the "for (i = 0; i < PHY_MAX_ADDR; i++)" mdiobus_scan loop

Thanks.

Best Regards,
Boris

Boris BREZILLON (1):
  phylib: mdio: handle register/unregister/register sequence

 drivers/net/phy/mdio_bus.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
1.7.9.5

