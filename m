Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaCOQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 12:25:27 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:54811
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbaCOQZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 12:25:25 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v2,0/1] hyperv: Add support for virtual Receive Side Scaling (vRSS)
Date: Sat, 15 Mar 2014 10:18:06 -0700
Message-Id: <1394903887-30421-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this updated version, I have re-written the send queue selection, which is
based on ndo_select_queue now. I also applied the stop/wake queue for each
queue separately as suggested by reviewers.

Tom Herbert <therbert@google.com> has submitted a Toeplitz library function with
some optimization. But it's not accepted yet. I'm still using my Toeplitz
implementation in netvsc module. Please accept my patch if no other issues, 
because it already provides significant performance enhancement at current
state. I will be happy to switch to the Toeplitz library function when it's
accepted in the future.

Haiyang Zhang (1):
  hyperv: Add support for virtual Receive Side Scaling (vRSS)

 drivers/net/hyperv/hyperv_net.h   |  111 ++++++++++++++++++++++-
 drivers/net/hyperv/netvsc.c       |  132 +++++++++++++++++++++-----
 drivers/net/hyperv/netvsc_drv.c   |  104 ++++++++++++++++++++-
 drivers/net/hyperv/rndis_filter.c |  186 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 500 insertions(+), 33 deletions(-)

-- 
1.7.4.1

