Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaGGRdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:33:45 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:35171 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGGRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:33:43 -0400
From: Jim Baxter <jim_baxter@mentor.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>
Subject: [PATCH v2 0/3] usb: gadget: NCM: Fixes and Multi-frame for TX.
Date: Mon, 7 Jul 2014 18:33:16 +0100
Message-ID: <1404754399-10360-1-git-send-email-jim_baxter@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Jim Baxter <jim_baxter@mentor.com>
References: <Jim Baxter <jim_baxter@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 07 Jul 2014 17:33:40.0413 (UTC) FILETIME=[977F76D0:01CF9A09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the ability to support packaging multiple network
packets into a single 16k CDC-NCM NTB.

Patches 1 and 3 are fixes for the receive unwrap function which
previously was unable to handle an NTB with multiple NDP's and a fix
that switches from using skb_clone to creating a new packet to fix the
issue of the truesize being far to big and causing packets to be
dropped incorrectly.

Jim Baxter (3):
  usb: gadget: NCM: RX function support multiple NDPs
  usb: gadget: NCM: Add transmit multi-frame.
  usb: gadget: NCM: Stop RX TCP Bursts getting dropped.

 drivers/usb/gadget/f_ncm.c   |  480 +++++++++++++++++++++++++++++-------------
 drivers/usb/gadget/u_ether.c |   19 +-
 drivers/usb/gadget/u_ether.h |    2 +
 3 files changed, 347 insertions(+), 154 deletions(-)

-- 
1.7.9.5

