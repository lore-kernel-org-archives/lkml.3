Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3EVCC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:02:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50611 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab3EVCB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:01:26 -0400
X-Sasl-enc: vMtKmLGM1NIfxykM7g57I0k/qA4NjEKHaXI8lLQb+0SZ 1369188084
From: Alan Ott <alan@signal11.us>
To: david@hauweele.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, Alan Ott <alan@signal11.us>
Subject: [PATCH beta 1] 0/3] Fix race conditions in mrf24j40 interrupts
Date: Tue, 21 May 2013 22:01:17 -0400
Message-Id: <1369188080-8904-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.11.2

