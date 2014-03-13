Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaCMLqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbaCMLqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:46:31 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Neil Jerram <Neil.Jerram@metaswitch.com>,
        Simon Horman <horms@verge.net.au>,
        Arvid Brodin <Arvid.Brodin@xdin.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>
Subject: [PATCH net-next 0/2] bonding: use correct ether type for alb
Date: Thu, 13 Mar 2014 12:41:56 +0100
Message-Id: <1394710918-29540-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There have been reports that, while using the ETH_P_LOOP ether type
(0x0060), the ether type is treated as its packet length.

To avoid that and to not break already existing apps - add new ether type
ETH_P_LOOPBACK that contains the correct id - 0x9000.


CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Simon Wunderlich <sw@simonwunderlich.de>
CC: Neil Jerram <Neil.Jerram@metaswitch.com>
CC: Simon Horman <horms@verge.net.au>
CC: Arvid Brodin <Arvid.Brodin@xdin.com>
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

---
 drivers/net/bonding/bond_alb.c | 2 +-
 include/uapi/linux/if_ether.h  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

