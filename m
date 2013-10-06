Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3JFDwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:52:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50011 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883Ab3JFDwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:52:38 -0400
X-Sasl-enc: JUpH7Qz9359wK9feoJ4zIqC4QXedp/Svvavsm1tYJzQT 1381031556
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, david@hauweele.net
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v1 0/3] Fix race conditions in mrf24j40 interrupts
Date: Sat,  5 Oct 2013 23:52:21 -0400
Message-Id: <1381031544-2960-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369188080-8904-1-git-send-email-alan@signal11.us>
References: <1369188080-8904-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After testing with the betas of this patchset, it's been rebased and is
ready for inclusion.

David Hauweele noticed that the mrf24j40 would hang arbitrarily after some
period of heavy traffic.  Two race conditions were discovered, and the
driver was changed to use threaded interrupts, since the enable/disable of
interrupts in the driver has recently been a lighning rod whenever issues
arise related to interrupts (costing engineering time), and since threaded
interrupts are the right way to do it.

Alan Ott (3):
  mrf24j40: Move INIT_COMPLETION() to before packet transmission
  mrf24j40: Use threaded IRQ handler
  mrf24j40: Use level-triggered interrupts

 drivers/net/ieee802154/mrf24j40.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

-- 
1.8.1.2

