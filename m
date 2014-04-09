Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060AbaDIVFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:05:39 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:60202
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaDIVFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:05:37 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net, V1 0/3] Fix issues with Heper-V network offload code
Date: Wed,  9 Apr 2014 15:00:10 -0700
Message-Id: <1397080810-17953-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WS2008 R2 does not support udp checksum offload. Furthermore, ws2012 and
ws2012 r2 have issues offloading udp checksum from Linux guests.
This patch-set addresses these issues as well as other bug fixes.
Please apply.

In this version, I have addressed the comment from David Miller with reagards
to COWing the skb prior to modifying the header (patch 3/3).

K. Y. Srinivasan (3):
  Drivers: net: hyperv: Allocate memory for all possible per-pecket
    information
  Drivers: net: hyperv: Negotiate suitable ndis version for offload
    support
  Drivers: net: hyperv: Address UDP checksum issues

 drivers/net/hyperv/hyperv_net.h   |    1 +
 drivers/net/hyperv/netvsc.c       |    2 +-
 drivers/net/hyperv/netvsc_drv.c   |   23 +++++++++++++++++++++--
 drivers/net/hyperv/rndis_filter.c |   12 +++++++++++-
 4 files changed, 34 insertions(+), 4 deletions(-)

-- 
1.7.4.1

