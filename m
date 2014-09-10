Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaIJUvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:51:41 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56036 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaIJUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:51:39 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Romain Perier <romain.perier@gmail.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, Tobias Klauser <tklauser@distanz.ch>,
        Jingoo Han <jg1.han@samsung.com>, Max Schwarz <max.schwarz@online.de>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 0/2] net: arc_emac: fix tx issues
Date: Wed, 10 Sep 2014 22:50:01 +0200
Message-Id: <1410382203-10395-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patches below solve some issues found in the tx ring reclaim
strategy currently implemented in the arc_emac driver.

Without these patches a simple outgoing UDP flow blocks almost
immediately with the socket send buffer full, until some new rx
packets trigger a clean of the tx ring.

Everything seems to work fine on a Radxa Rock with this fix applied.

Changes since v1:
 - reworded commit messages

Beniamino Galvani (2):
  net: arc_emac: enable tx interrupts
  net: arc_emac: prevent reuse of unreclaimed tx descriptors

 drivers/net/ethernet/arc/emac_main.c | 53 +++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 16 deletions(-)

-- 
1.9.1

