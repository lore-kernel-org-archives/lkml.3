Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbaE2RMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:12:44 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:56532 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729AbaE2RMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:12:42 -0400
From: Jim Baxter <jim_baxter@mentor.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>
Subject: [PATCH v1 0/3] usb: gadget: NCM: Fixes and Multi-frame for TX.
Date: Thu, 29 May 2014 18:12:20 +0100
Message-ID: <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Jim Baxter <jim_baxter@mentor.com>
References: <Jim Baxter <jim_baxter@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 29 May 2014 17:12:38.0839 (UTC) FILETIME=[316E4C70:01CF7B61]
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

