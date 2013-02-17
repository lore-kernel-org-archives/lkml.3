Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3BQVCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 16:02:37 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47144
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab3BQVCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 16:02:36 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] Drivers: hv 
Date: Sun, 17 Feb 2013 13:30:55 -0800
Message-Id: <1361136655-30979-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch for the vmbus drivers properly cleans up the channel state on receipt
of the "offer rescind" message. The balloon driver patches permit the execution
of both "balloon up" operation as well as the "hot-add" operation in separate
execution contexts. This allows the balloon driver to be more responsive both
in terms of reporting pressure to the host as well as responding to the requests
from the host.

K. Y. Srinivasan (3):
  Drivers: hv: vmbus: Handle channel rescind message correctly
  Drivers: hv: balloon: Execute balloon inflation in a separate context
  Drivers: hv: balloon: Execute hot-add code in a separate context

 drivers/hv/channel_mgmt.c |   11 +++++++
 drivers/hv/hv_balloon.c   |   74 ++++++++++++++++++++++++++++-----------------
 2 files changed, 57 insertions(+), 28 deletions(-)

-- 
1.7.4.1

